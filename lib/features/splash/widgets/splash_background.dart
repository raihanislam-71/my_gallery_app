import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              top: -110,
              left: -110,
              child: _Circle(diameter: 380),
            ),
            Positioned(
              right: -110,
              bottom: -110,
              child: _Circle(diameter: 340),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.splashCircle,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(dimension: diameter),
    );
  }
}
