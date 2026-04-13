import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/secondary_button.dart';
import '../providers/report_provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.reviewReport),
      ),
      body: SafeArea(
        child: Consumer<ReportProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.paddingScreen),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.reviewSubtitle,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Accident Type Section
                        _buildSection(
                          title: AppStrings.accidentType,
                          icon: Icons.car_crash_rounded,
                          child: _buildInfoRow(
                            'Type',
                            provider.selectedAccidentType ?? 'Not selected',
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // Location Section
                        _buildSection(
                          title: AppStrings.accidentLocation,
                          icon: Icons.location_on_rounded,
                          child: _buildInfoRow(
                            'Location',
                            provider.locationText,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // Driver Details Section
                        _buildSection(
                          title: AppStrings.details,
                          icon: Icons.person_rounded,
                          child: Column(
                            children: [
                              _buildInfoRow(AppStrings.fullName, provider.fullName),
                              const SizedBox(height: 8),
                              _buildInfoRow(AppStrings.phoneNumber, provider.phoneNumber),
                              const SizedBox(height: 8),
                              _buildInfoRow(AppStrings.vehiclePlateNumber, provider.vehiclePlateNumber),
                              if (provider.insuranceCompany.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(AppStrings.insuranceCompany, provider.insuranceCompany),
                              ],
                              if (provider.accidentDescription.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(AppStrings.accidentDescription, provider.accidentDescription),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // Evidence Section
                        _buildSection(
                          title: AppStrings.evidence,
                          icon: Icons.photo_library_rounded,
                          child: provider.capturedPhotos.isEmpty
                              ? const Text(
                                  'No photos captured',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${provider.capturedPhotos.length} photo(s) captured',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 80,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            provider.capturedPhotos.length,
                                        separatorBuilder: (a1, a2) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: AppColors.accentLight,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .borderRadiusSm),
                                              border: Border.all(
                                                  color: AppColors.accent),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.image_rounded,
                                                  color: AppColors.primary,
                                                  size: 24,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '#${index + 1}',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
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
                        text: AppStrings.submit,
                        icon: Icons.send_rounded,
                        onPressed: () => context.go('/report/success'),
                      ),
                      const SizedBox(height: AppConstants.spacingSm + 4),
                      SecondaryButton(
                        text: AppStrings.edit,
                        icon: Icons.edit_rounded,
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingCard),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
