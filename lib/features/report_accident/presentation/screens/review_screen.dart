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
            final car = provider.selectedCar;
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

                        // ── Session ────────────────────────────────────
                        _buildSection(
                          title: 'Accident Session',
                          icon: Icons.qr_code_rounded,
                          child: _buildInfoRow(
                            'Session ID',
                            provider.sessionId ?? 'Not selected',
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // ── Location ───────────────────────────────────
                        _buildSection(
                          title: AppStrings.accidentLocation,
                          icon: Icons.location_on_rounded,
                          child: provider.latitude != null
                              ? Column(
                                  children: [
                                    _buildInfoRow(
                                      'Latitude',
                                      provider.latitude!.toStringAsFixed(6),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      'Longitude',
                                      provider.longitude!.toStringAsFixed(6),
                                    ),
                                  ],
                                )
                              : _buildInfoRow(
                                  'Location',
                                  provider.locationText,
                                ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // ── Your Vehicle ───────────────────────────────
                        if (car != null) ...[
                          _buildSection(
                            title: 'Your Vehicle',
                            icon: Icons.directions_car_rounded,
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  'Make',
                                  car['manufacturer'] as String? ?? '—',
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  'Type',
                                  car['car_type'] as String? ?? '—',
                                ),
                                if ((car['color'] as String?)?.isNotEmpty ==
                                    true) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Color',
                                    car['color'] as String,
                                  ),
                                ],
                                if (car['year'] != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Year',
                                    car['year'].toString(),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  'Plate',
                                  provider.vehiclePlateNumber,
                                ),
                                if (provider.insuranceCompany.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Insurance',
                                    provider.insuranceCompany,
                                  ),
                                ],
                                if ((car['insurance_id'] as String?)
                                        ?.isNotEmpty ==
                                    true) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Policy ID',
                                    car['insurance_id'] as String,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                        ],

                        // ── Reporter Details ───────────────────────────
                        _buildSection(
                          title: AppStrings.details,
                          icon: Icons.person_rounded,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                AppStrings.fullName,
                                provider.fullName,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                AppStrings.phoneNumber,
                                provider.phoneNumber,
                              ),
                              if (car == null &&
                                  provider.vehiclePlateNumber.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  'Plate',
                                  provider.vehiclePlateNumber,
                                ),
                              ],
                              if (car == null &&
                                  provider.insuranceCompany.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  AppStrings.insuranceCompany,
                                  provider.insuranceCompany,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // ── Accident Details ───────────────────────────
                        _buildSection(
                          title: 'Accident Details',
                          icon: Icons.car_crash_rounded,
                          child: Column(
                            children: [
                              if (provider.accidentType.isNotEmpty) ...[
                                _buildInfoRow(
                                  'Type',
                                  provider.accidentType,
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (provider.weatherCondition.isNotEmpty) ...[
                                _buildInfoRow(
                                  'Weather',
                                  provider.weatherCondition,
                                ),
                                const SizedBox(height: 8),
                              ],
                              _buildInfoRow(
                                'Injuries',
                                provider.injuriesReported ? 'Yes' : 'No',
                              ),
                              if (provider.accidentDescription.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  AppStrings.accidentDescription,
                                  provider.accidentDescription,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // ── Evidence ───────────────────────────────────
                        _buildSection(
                          title: AppStrings.evidence,
                          icon: Icons.photo_library_rounded,
                          child: provider.images.isEmpty
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
                                      '${provider.images.length} photo(s) captured',
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
                                        itemCount: provider.images.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (context, index) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              AppConstants.borderRadiusSm,
                                            ),
                                            child: Image.file(
                                              provider.images[index],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
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
          width: 110,
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
