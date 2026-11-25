import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DashboardBottomBar extends StatelessWidget {
  const DashboardBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddPhoto,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddPhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildTab(0, Icons.home_outlined, 'Home'),
              _buildTab(1, Icons.photo_outlined, 'Gallery'),
              Expanded(child: _buildAddButton()),
              _buildTab(2, Icons.favorite_border, 'Favorites'),
              _buildTab(3, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.mutedText;

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.35),
        child: InkWell(
          onTap: onAddPhoto,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
