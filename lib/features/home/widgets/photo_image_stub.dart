import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

Widget buildPhotoImage({
  required String imageUrl,
  required Widget placeholder,
}) {
  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) => placeholder,
  );
}
