import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app_exam/features/home/models/gallery_photo.dart';

void main() {
  test('parses imageUrl from API image field', () {
    const url = 'https://na8ure.sfo3.digitaloceanspaces.com/images/220552';
    final photo = GalleryPhoto.fromJson({'_id': 'photo-1', 'image': url}, 0);

    expect(photo.imageUrl, url);
  });

  test('parses imageUrl from nested API image object', () {
    const url = 'https://cdn.example.com/photo.jpg';
    final photo = GalleryPhoto.fromJson({
      'id': 'photo-2',
      'image': {'secure_url': url},
    }, 1);

    expect(photo.imageUrl, url);
  });

  test('resolves relative API image path and displays API metadata', () {
    final photo = GalleryPhoto.fromJson({
      'id': 'photo-3',
      'imageUrl': '/uploads/photo.jpg',
      'fileSize': 3870000,
      'createdAt': '2026-08-23T12:00:00.000Z',
    }, 2);

    expect(photo.imageUrl, 'https://api.fototidy.com/uploads/photo.jpg');
    expect(photo.size, '3.87 MB');
    expect(photo.date, '23 Aug 2026');
  });
}
