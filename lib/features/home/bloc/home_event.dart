import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeFetchPhotos extends HomeEvent {
  const HomeFetchPhotos();
}

class DashboardTabChanged extends HomeEvent {
  const DashboardTabChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class GalleryFavoriteToggled extends HomeEvent {
  const GalleryFavoriteToggled(this.photoId);

  final String photoId;

  @override
  List<Object?> get props => [photoId];
}
