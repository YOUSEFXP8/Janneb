import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/card_tile.dart';
import '../providers/report_provider.dart';

class AccidentTypeScreen extends StatelessWidget {
  const AccidentTypeScreen({super.key});

  static const List<Map<String, dynamic>> _accidentTypes = [
    {
      'title': AppStrings.minorCollision,
      'subtitle': 'Small bumps and scratches',
      'icon': Icons.minor_crash_rounded,
    },
    {
      'title': AppStrings.rearEndAccident,
      'subtitle': 'Vehicle hit from behind',
      'icon': Icons.car_crash_rounded,
    },
    {
      'title': AppStrings.sideCollision,
      'subtitle': 'Impact on the side of vehicle',
      'icon': Icons.swap_horiz_rounded,
    },
    {
      'title': AppStrings.parkingAccident,
      'subtitle': 'Accident while parking',
      'icon': Icons.local_parking_rounded,
    },
    {
      'title': AppStrings.other,
      'subtitle': 'Other type of accident',
      'icon': Icons.more_horiz_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.selectAccidentType),
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
                      AppStrings.accidentTypeSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Consumer<ReportProvider>(
                      builder: (context, provider, _) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _accidentTypes.length,
                          separatorBuilder: (a1, a2) =>
                              const SizedBox(height: AppConstants.spacingSm + 4),
                          itemBuilder: (context, index) {
                            final type = _accidentTypes[index];
                            return CardTile(
                              title: type['title'] as String,
                              subtitle: type['subtitle'] as String,
                              icon: type['icon'] as IconData,
                              isSelected: provider.selectedAccidentType ==
                                  type['title'],
                              onTap: () {
                                provider.setAccidentType(
                                    type['title'] as String);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Consumer<ReportProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingScreen),
                  child: PrimaryButton(
                    text: AppStrings.continueText,
                    onPressed: provider.isAccidentTypeSelected
                        ? () => context.push('/report/capture-evidence')
                        : null,
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
