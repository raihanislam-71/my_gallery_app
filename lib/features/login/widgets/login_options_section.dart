import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'login_social_button.dart';

class LoginOptionsSection extends StatelessWidget {
  const LoginOptionsSection({super.key, required this.onAction});

  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDivider(),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: LoginSocialButton(
                label: 'Google',
                onPressed: () => onAction(
                  'Google sign-in will be connected after API setup.',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LoginSocialButton(
                label: 'Apple',
                onPressed: () => onAction(
                  'Apple sign-in will be connected after API setup.',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.mutedText, fontSize: 14),
            ),
            GestureDetector(
              onTap: () => onAction(
                'Sign up will be available after the registration screen is added.',
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(color: AppColors.mutedText, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
      ],
    );
  }
}
