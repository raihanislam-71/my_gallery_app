import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

final Set<String> _registeredViewTypes = {};

Widget buildPhotoImage({
  required String imageUrl,
  required Widget placeholder,
}) {
  final viewType = 'img-view-${imageUrl.hashCode}';

  if (_registeredViewTypes.add(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final image = html.ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';
      image.setAttribute('loading', 'lazy');
      image.setAttribute('decoding', 'async');
      return image;
    });
  }

  return HtmlElementView(viewType: viewType);
}
