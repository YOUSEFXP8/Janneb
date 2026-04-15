import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/emergency_button.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 16),
              const Text(
                'Emergency Assistance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap to call immediately',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              // Warning Banner
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Only use in genuine emergencies',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              EmergencyButton(
                title: 'Call Police',
                subtitle: '911',
                icon: Icons.phone_in_talk_rounded,
                color: AppColors.error,
                onTap: () => _showSnackBar(context, 'Calling Police...'),
              ),
              const SizedBox(height: 16),
              EmergencyButton(
                title: 'Call Ambulance',
                subtitle: '997',
                icon: Icons.medical_services_outlined,
                color: AppColors.error,
                onTap: () => _showSnackBar(context, 'Calling Ambulance...'),
              ),
              const SizedBox(height: 16),
              EmergencyButton(
                title: 'Call Insurance',
                subtitle: 'Tawuniya Insurance',
                icon: Icons.shield_outlined,
                color: AppColors.primary,
                onTap: () => _showSnackBar(context, 'Calling Insurance...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
