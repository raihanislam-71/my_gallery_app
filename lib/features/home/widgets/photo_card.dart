import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/gallery_photo.dart';

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
          Image.network(
            photo.imageUrl!,
            fit: BoxFit.cover,
            headers: const {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: photo.topColor.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Image load error for ${photo.imageUrl}: $error');
              return _buildGradientPlaceholder();
            },
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
        child: Icon(
          Icons.image_outlined,
          color: Colors.white,
          size: 34,
        ),
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
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
