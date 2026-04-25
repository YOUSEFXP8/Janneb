import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/secondary_button.dart';
import '../providers/report_provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reviewReport),
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
                        Text(
                          l10n.reviewSubtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingLg),

                        _buildSection(
                          title: l10n.accidentSessionSection,
                          icon: Icons.qr_code_rounded,
                          child: _buildInfoRow(
                            l10n.sessionId,
                            provider.sessionId ?? '—',
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        _buildSection(
                          title: l10n.accidentLocation,
                          icon: Icons.location_on_rounded,
                          child: provider.latitude != null
                              ? GestureDetector(
                                  onTap: () async {
                                    final uri = Uri.parse(
                                      'https://www.google.com/maps/search/?api=1&query=${provider.latitude},${provider.longitude}',
                                    );
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.viewOnMap,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _buildInfoRow(
                                  l10n.locationLabel,
                                  provider.locationText,
                                ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        if (car != null) ...[
                          _buildSection(
                            title: l10n.yourVehicle,
                            icon: Icons.directions_car_rounded,
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  l10n.make,
                                  car['manufacturer'] as String? ?? '—',
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  l10n.type,
                                  car['car_type'] as String? ?? '—',
                                ),
                                if ((car['color'] as String?)?.isNotEmpty ==
                                    true) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    l10n.color,
                                    car['color'] as String,
                                  ),
                                ],
                                if (car['year'] != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    l10n.year,
                                    car['year'].toString(),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  l10n.plate,
                                  provider.vehiclePlateNumber,
                                ),
                                if (provider.insuranceCompany.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    l10n.insuranceCompany,
                                    provider.insuranceCompany,
                                  ),
                                ],
                                if ((car['insurance_id'] as String?)
                                        ?.isNotEmpty ==
                                    true) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    l10n.policyId,
                                    car['insurance_id'] as String,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                        ],

                        _buildSection(
                          title: l10n.details,
                          icon: Icons.person_rounded,
                          child: Column(
                            children: [
                              _buildInfoRow(l10n.fullName, provider.fullName),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                l10n.phoneNumber,
                                provider.phoneNumber,
                              ),
                              if (car == null &&
                                  provider.vehiclePlateNumber.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  l10n.plate,
                                  provider.vehiclePlateNumber,
                                ),
                              ],
                              if (car == null &&
                                  provider.insuranceCompany.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  l10n.insuranceCompany,
                                  provider.insuranceCompany,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        _buildSection(
                          title: l10n.accidentDetails,
                          icon: Icons.car_crash_rounded,
                          child: Column(
                            children: [
                              if (provider.accidentDescription.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  l10n.accidentDescription,
                                  provider.accidentDescription,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        _buildSection(
                          title: l10n.evidence,
                          icon: Icons.photo_library_rounded,
                          child: provider.images.isEmpty
                              ? Text(
                                  l10n.noPhotosCaptured,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.photosCountLabel(
                                        provider.images.length,
                                      ),
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

                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingScreen),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: l10n.submit,
                        icon: Icons.send_rounded,
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                try {
                                  await provider.submitReport();
                                  if (context.mounted) {
                                    context.go('/report/success');
                                  }
                                } on PostgrestException catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message)),
                                    );
                                  }
                                } catch (_) {
                                  if (context.mounted) {
                                    final l = AppLocalizations.of(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l.failedToSubmit)),
                                    );
                                  }
                                }
                              },
                      ),
                      const SizedBox(height: AppConstants.spacingSm + 4),
                      SecondaryButton(
                        text: l10n.edit,
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
