import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_urls.dart';

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
    final formattedSize = _formatFileSize(
      json['fileSize'] ?? json['file_size'] ?? json['size'],
    );

    final createdAt =
        (json['createdAt'] ??
                json['created_at'] ??
                json['uploadedAt'] ??
                json['uploadDate'] ??
                json['date'])
            ?.toString() ??
        '';
    String formattedDate = 'Recent';
    if (createdAt.isNotEmpty) {
      try {
        final dt = DateTime.parse(createdAt);
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        formattedDate = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      } catch (_) {}
    }

    final imageUrl = _resolveImageUrl(json);
    final isAi =
        (json['isAiGenerated'] == true) ||
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

  static String _formatFileSize(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      final parsed = double.tryParse(value.trim());
      if (parsed == null) return value.trim();
      value = parsed;
    }

    if (value is! num || value <= 0) return 'Size unavailable';

    var sizeInMegabytes = value.toDouble();
    if (sizeInMegabytes >= 1000) {
      sizeInMegabytes /= 1000000;
    }

    return '${sizeInMegabytes.toStringAsFixed(2)} MB';
  }

  static String? _resolveImageUrl(Map<String, dynamic> json) {
    const directKeys = [
      'image',
      'imagePath',
      'image_path',
      'imageUrl',
      'imageURL',
      'image_url',
      'photo',
      'photoUrl',
      'photo_url',
      'url',
      'path',
      'src',
      'fileUrl',
      'file_url',
      'secureUrl',
      'secure_url',
    ];

    for (final key in directKeys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return _makeAbsoluteUrl(value.trim());
      }
      if (value is Map) {
        final nestedUrl = _resolveImageUrl(Map<String, dynamic>.from(value));
        if (nestedUrl != null) return nestedUrl;
      }
    }

    for (final key in const ['thumbnail', 'preview', 'attachment', 'data']) {
      final value = json[key];
      if (value is Map) {
        final nestedUrl = _resolveImageUrl(Map<String, dynamic>.from(value));
        if (nestedUrl != null) return nestedUrl;
      }
    }

    return null;
  }

  static String _makeAbsoluteUrl(String url) {
    final parsed = Uri.parse(url);
    if (parsed.hasScheme) return url;

    final origin = Uri.parse(ApiUrls.baseUrl).origin;
    return Uri.parse(origin).resolve(url).toString();
  }
}
