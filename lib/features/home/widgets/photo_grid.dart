import 'package:flutter/material.dart';

import '../bloc/home_state.dart';
import '../models/gallery_photo.dart';
import 'photo_card.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    super.key,
    required this.photos,
    required this.state,
    required this.onFavoriteTap,
  });

  final List<GalleryPhoto> photos;
  final HomeState state;
  final ValueChanged<String> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: photos.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return PhotoCard(
          photo: photo,
          isFavorite: state.isFavorite(photo.id),
          onFavoriteTap: () => onFavoriteTap(photo.id),
        );
      },
    );
  }
}
