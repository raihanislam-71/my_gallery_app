import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class GalleryPhoto {
  const GalleryPhoto({
    required this.id,
    required this.size,
    required this.date,
    required this.topColor,
    required this.bottomColor,
    this.imageUrl,
    this.isAiGenerated = false,
    this.isFavorite = false,
  });

  final String id;
  final String size;
  final String date;
  final Color topColor;
  final Color bottomColor;
  final String? imageUrl;
  final bool isAiGenerated;
  final bool isFavorite;

  factory GalleryPhoto.fromJson(Map<String, dynamic> json, int index) {
    final rawSize = json['fileSize'];
    double sizeNum = 0.0;
    if (rawSize is num) {
      sizeNum = rawSize.toDouble();
    } else if (rawSize is String) {
      sizeNum = double.tryParse(rawSize) ?? 0.0;
    }
    final formattedSize =
        sizeNum > 0 ? '${sizeNum.toStringAsFixed(2)} MB' : '1.5 MB';

    final createdAt = json['createdAt']?.toString() ?? '';
    String formattedDate = 'Recent';
    if (createdAt.isNotEmpty) {
      try {
        final dt = DateTime.parse(createdAt);
        final months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        formattedDate = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      } catch (_) {}
    }

    final imageUrl = json['image']?.toString();
    final isAi = (json['isAiGenerated'] == true) ||
        (imageUrl != null && imageUrl.contains('ai-images'));
    final isFav = json['isFavorite'] == true;

    final colors = [
      [const Color(0xFFCFC7FF), AppColors.photoPurple],
      [const Color(0xFFC1E3FF), AppColors.photoBlue],
      [const Color(0xFFFFD1BC), AppColors.photoOrange],
      [const Color(0xFFC2F3D5), AppColors.photoGreen],
    ];
    final colorPair = colors[index % colors.length];

    return GalleryPhoto(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '$index',
      size: formattedSize,
      date: formattedDate,
      topColor: colorPair[0],
      bottomColor: colorPair[1],
      imageUrl: imageUrl,
      isAiGenerated: isAi,
      isFavorite: isFav,
    );
  }
}

const recentGalleryPhotos = [
  GalleryPhoto(
    id: '1',
    size: '3.87 MB',
    date: '23 Aug 2026',
    topColor: Color(0xFFCFC7FF),
    bottomColor: AppColors.photoPurple,
  ),
  GalleryPhoto(
    id: '2',
    size: '3.08 MB',
    date: '23 Aug 2026',
    topColor: Color(0xFFC1E3FF),
    bottomColor: AppColors.photoBlue,
  ),
  GalleryPhoto(
    id: '3',
    size: '17 Aug 2026',
    date: '17 Aug 2026',
    topColor: Color(0xFFFFD1BC),
    bottomColor: AppColors.photoOrange,
  ),
  GalleryPhoto(
    id: '4',
    size: '1.05 MB',
    date: '10 Aug 2026',
    topColor: Color(0xFFC2F3D5),
    bottomColor: AppColors.photoGreen,
    isAiGenerated: true,
  ),
];
