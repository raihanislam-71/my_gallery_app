import 'package:equatable/equatable.dart';

import '../models/gallery_photo.dart';

class HomeState extends Equatable {
  const HomeState({
    this.selectedTab = 0,
    this.photos = const [],
    this.favoritePhotoIds = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  final int selectedTab;
  final List<GalleryPhoto> photos;
  final List<String> favoritePhotoIds;
  final bool isLoading;
  final String errorMessage;

  bool isFavorite(String photoId) => favoritePhotoIds.contains(photoId);

  HomeState copyWith({
    int? selectedTab,
    List<GalleryPhoto>? photos,
    List<String>? favoritePhotoIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      photos: photos ?? this.photos,
      favoritePhotoIds: favoritePhotoIds ?? this.favoritePhotoIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? '',
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        photos,
        favoritePhotoIds,
        isLoading,
        errorMessage,
      ];
}
