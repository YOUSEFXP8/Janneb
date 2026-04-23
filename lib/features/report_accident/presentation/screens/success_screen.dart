import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/secondary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/report_provider.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success Icon
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Success Message
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Text(
                      AppStrings.reportSubmitted,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    const Text(
                      AppStrings.successMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Report Reference
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.receipt_long_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Report Reference',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'CR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Buttons
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    PrimaryButton(
                      text: 'View Report',
                      icon: Icons.description_rounded,
                      onPressed: () async {
                        final auth = context.read<AuthProvider>();
                        final report = context.read<ReportProvider>();
                        final nationalId = auth.nationalId ?? '';
                        await report.fetchReports(nationalId);
                        if (!mounted) return;
                        report.resetReport();
                        // ignore: use_build_context_synchronously
                        context.go('/my-reports');
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingSm + 4),
                    SecondaryButton(
                      text: AppStrings.returnHome,
                      icon: Icons.home_rounded,
                      onPressed: () {
                        context.read<ReportProvider>().resetReport();
                        context.go('/home');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}
