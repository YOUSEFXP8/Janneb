import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/secondary_button.dart';
import '../providers/report_provider.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.accidentLocation),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingScreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.locationSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Map Placeholder
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadiusLg),
                        border: Border.all(
                          color: AppColors.border,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Grid pattern to sim map
                          CustomPaint(
                            size: const Size(double.infinity, 300),
                            painter: _MapGridPainter(),
                          ),
                          // Center pin
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Map will be integrated later',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Location Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.paddingCard),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.my_location_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Consumer<ReportProvider>(
                            builder: (context, provider, _) {
                              return Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.currentLocation,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      provider.locationText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: Column(
                children: [
                  PrimaryButton(
                    text: AppStrings.confirmLocation,
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: () {
                      context
                          .read<ReportProvider>()
                          .confirmLocation();
                      context.push('/report/driver-details');
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingSm + 4),
                  SecondaryButton(
                    text: AppStrings.adjustLocation,
                    icon: Icons.edit_location_alt_rounded,
                    onPressed: () {
                      // Placeholder - no maps integration
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
