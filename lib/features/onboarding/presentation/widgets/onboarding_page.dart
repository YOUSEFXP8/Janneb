import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingScreen,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Illustration placeholder
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusXl),
            ),
            child: Icon(
              icon,
              size: 100,
              color: iconColor,
            ),
          ),
          const Spacer(flex: 1),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
