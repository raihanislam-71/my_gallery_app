import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            title: 'Total Photos',
            value: '9',
            isHighlighted: true,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Storage Used',
            value: '16.4 MB',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    this.isHighlighted = false,
  });

  final String title;
  final String value;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isHighlighted ? Colors.white : AppColors.text;

    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: foregroundColor, fontSize: 12),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
