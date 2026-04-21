import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

enum StepStatus { completed, active, pending }

class GuideStepItem extends StatelessWidget {
  const GuideStepItem({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
    this.onTap,
  });

  final int stepNumber;
  final String title;
  final String subtitle;
  final IconData icon;
  final StepStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingScreen,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _StepCircle(stepNumber: stepNumber, status: status, icon: icon),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: status == StepStatus.pending
                          ? FontWeight.w400
                          : FontWeight.w600,
                      color: status == StepStatus.pending
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (status != StepStatus.completed)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: status == StepStatus.active
                    ? AppColors.textPrimary
                    : AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.stepNumber,
    required this.status,
    required this.icon,
  });

  final int stepNumber;
  final StepStatus status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case StepStatus.completed:
        return Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
        );
      case StepStatus.active:
        return Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        );
      case StepStatus.pending:
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
              ),
            ),
          ),
        );
    }
  }
}
