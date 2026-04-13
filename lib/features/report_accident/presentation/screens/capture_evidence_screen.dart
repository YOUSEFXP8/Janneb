import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../common/widgets/primary_button.dart';
import '../providers/report_provider.dart';

class CaptureEvidenceScreen extends StatelessWidget {
  const CaptureEvidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.captureEvidence),
        actions: [
          TextButton(
            onPressed: () => context.push('/report/location'),
            child: const Text('Skip'),
          ),
        ],
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
                      AppStrings.captureEvidenceSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Camera Placeholder
                    Container(
                      width: double.infinity,
                      height: 240,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 36,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Camera Preview',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Camera access will be enabled later',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),

                    // Capture and Gallery Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Consumer<ReportProvider>(
                            builder: (context, provider, _) {
                              return ElevatedButton.icon(
                                onPressed: () {
                                  provider.addPhoto('placeholder_photo_${provider.capturedPhotos.length + 1}');
                                },
                                icon: const Icon(Icons.camera_alt_rounded,
                                    size: 20),
                                label: const Text(AppStrings.capturePhoto),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadius),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Consumer<ReportProvider>(
                            builder: (context, provider, _) {
                              return OutlinedButton.icon(
                                onPressed: () {
                                  provider.addPhoto('gallery_photo_${provider.capturedPhotos.length + 1}');
                                },
                                icon: const Icon(Icons.photo_library_rounded,
                                    size: 20),
                                label: const Text(AppStrings.gallery),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  minimumSize: const Size(0, 48),
                                  side: const BorderSide(
                                      color: AppColors.primary, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadius),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Photos Grid
                    Consumer<ReportProvider>(
                      builder: (context, provider, _) {
                        if (provider.capturedPhotos.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppStrings.photosCaptured} (${provider.capturedPhotos.length})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spacingSm + 4),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: provider.capturedPhotos.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.accentLight,
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.borderRadiusSm),
                                        border: Border.all(
                                            color: AppColors.border),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.image_rounded,
                                              color: AppColors.primary,
                                              size: 32,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Photo ${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            provider.removePhoto(index),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: AppColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: PrimaryButton(
                text: AppStrings.continueText,
                onPressed: () => context.push('/report/location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
