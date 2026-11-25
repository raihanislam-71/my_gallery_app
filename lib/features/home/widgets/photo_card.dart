import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/gallery_photo.dart';
import 'photo_image_stub.dart'
    if (dart.library.js_interop) 'photo_image_web.dart'
    as photo_image;

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.photo,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final GalleryPhoto photo;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: _buildImagePreview()),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (photo.imageUrl != null && photo.imageUrl!.isNotEmpty)
          photo_image.buildPhotoImage(
            imageUrl: photo.imageUrl!,
            placeholder: _buildGradientPlaceholder(),
          )
        else
          _buildGradientPlaceholder(),
        if (photo.isAiGenerated)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8B5C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onFavoriteTap,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primary : AppColors.mutedText,
                  size: 21,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientPlaceholder() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [photo.topColor, photo.bottomColor],
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white, size: 34),
      ),
    );
  }

  Widget _buildDetails() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 9, 8, 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              photo.size,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              photo.date,
              style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
