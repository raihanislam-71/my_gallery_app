import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.primary,
    this.showShadow = true,
    this.cornerRadius,
  });

  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final bool showShadow;
  final double? cornerRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius ?? size * 0.28),
        boxShadow: showShadow
            ? const [
                BoxShadow(
                  color: Color(0x28000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Icon(
        Icons.check,
        size: size * 0.5,
        color: iconColor,
      ),
    );
  }
}
