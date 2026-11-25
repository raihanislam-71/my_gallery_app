import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/api_client.dart';
import '../models/gallery_photo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({NetworkCaller? networkCaller})
      : _networkCaller = networkCaller ?? NetworkCaller(),
        super(const HomeState()) {
    on<HomeFetchPhotos>(_onFetchPhotos);
    on<DashboardTabChanged>((event, emit) {
      if (event.index >= 0 && event.index <= 3) {
        emit(state.copyWith(selectedTab: event.index));
      }
    });
    on<GalleryFavoriteToggled>((event, emit) {
      final favorites = List<String>.from(state.favoritePhotoIds);
      if (favorites.contains(event.photoId)) {
        favorites.remove(event.photoId);
      } else {
        favorites.add(event.photoId);
      }
      emit(state.copyWith(favoritePhotoIds: favorites));
    });
  }

  final NetworkCaller _networkCaller;

  Future<void> _onFetchPhotos(
    HomeFetchPhotos event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    final response = await _networkCaller.getRequest(url: ApiUrls.myPhotos);

    if (response.isSuccess && response.responseData != null) {
      final rawData = response.responseData['data'];
      if (rawData is List) {
        final List<GalleryPhoto> loadedPhotos = [];
        for (int i = 0; i < rawData.length; i++) {
          final item = rawData[i];
          if (item is Map<String, dynamic>) {
            loadedPhotos.add(GalleryPhoto.fromJson(item, i));
          }
        }

        final favoriteIds = loadedPhotos
            .where((p) => p.isFavorite)
            .map((p) => p.id)
            .toList();

        emit(state.copyWith(
          photos: loadedPhotos,
          favoritePhotoIds:
              favoriteIds.isEmpty ? state.favoritePhotoIds : favoriteIds,
          isLoading: false,
        ));
        return;
      }
    }

    emit(state.copyWith(
      isLoading: false,
      photos: recentGalleryPhotos,
      errorMessage: response.errorMessage ?? 'Failed to load photos.',
    ));
  }
}
