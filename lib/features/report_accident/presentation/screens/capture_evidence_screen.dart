import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../common/widgets/primary_button.dart';
import '../providers/report_provider.dart';

class CaptureEvidenceScreen extends StatefulWidget {
  const CaptureEvidenceScreen({super.key});

  @override
  State<CaptureEvidenceScreen> createState() => _CaptureEvidenceScreenState();
}

class _CaptureEvidenceScreenState extends State<CaptureEvidenceScreen> {
  final _picker = ImagePicker();

  Future<void> _captureFromCamera(ReportProvider provider) async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) provider.addImage(File(image.path));
  }

  Future<void> _pickFromGallery(ReportProvider provider) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) provider.addImage(File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.captureEvidence),
        actions: [
          TextButton(
            onPressed: () => context.push('/report/location'),
            child: Text(l10n.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingScreen),
                child: Consumer<ReportProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.takePhotosDesc,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingLg),

                        ElevatedButton.icon(
                          onPressed: () => _captureFromCamera(provider),
                          icon: const Icon(Icons.camera_alt_rounded, size: 22),
                          label: Text(l10n.takePhoto),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _captureFromCamera(provider),
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                ),
                                label: Text(l10n.capturePhoto),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _pickFromGallery(provider),
                                icon: const Icon(
                                  Icons.photo_library_rounded,
                                  size: 20,
                                ),
                                label: Text(l10n.gallery),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  minimumSize: const Size(0, 48),
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingLg),

                        if (provider.images.isNotEmpty) ...[
                          Text(
                            '${l10n.photosCaptured} (${provider.images.length})',
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
                            itemCount: provider.images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadiusSm,
                                    ),
                                    child: Image.file(
                                      provider.images[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () =>
                                          provider.removeImage(index),
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
                      ],
                    );
                  },
                ),
              ),
            ),

            Consumer<ReportProvider>(
              builder: (context, provider, _) {
                final count = provider.images.length;
                final canContinue = count >= 2;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingScreen,
                    0,
                    AppConstants.paddingScreen,
                    AppConstants.paddingScreen,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (i) {
                          final filled = i < count;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 32,
                            height: 6,
                            decoration: BoxDecoration(
                              color: filled
                                  ? AppColors.primary
                                  : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        canContinue
                            ? l10n.photosCapturedCount(count)
                            : l10n.photosProgress(count),
                        style: TextStyle(
                          fontSize: 13,
                          color: canContinue
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: l10n.continueText,
                        onPressed: canContinue
                            ? () => context.push('/report/location')
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
