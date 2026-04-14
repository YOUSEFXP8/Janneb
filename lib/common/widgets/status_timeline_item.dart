import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusTimelineItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isLast;
  final bool isCurrent;

  const StatusTimelineItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.isCompleted,
    this.isLast = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.primary
                    : (isCurrent
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.border),
                border: isCurrent
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent ? AppColors.primary : Colors.white,
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isCompleted ? AppColors.primary : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted || isCurrent
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
