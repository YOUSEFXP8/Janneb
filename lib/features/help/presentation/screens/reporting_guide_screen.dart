import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../report_accident/presentation/providers/report_provider.dart';
import '../widgets/guide_step_item.dart';

class _StepData {
  const _StepData({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
}

class ReportingGuideScreen extends StatelessWidget {
  const ReportingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<ReportProvider>();
    final currentStep = provider.guideStep;

    final steps = [
      _StepData(number: 1, title: l10n.stepTitle1, subtitle: l10n.stepDesc1, icon: Icons.warning_rounded),
      _StepData(number: 2, title: l10n.stepTitle2, subtitle: l10n.stepDesc2, icon: Icons.camera_alt_rounded),
      _StepData(number: 3, title: l10n.stepTitle3, subtitle: l10n.stepDesc3, icon: Icons.location_on_rounded),
      _StepData(number: 4, title: l10n.stepTitle4, subtitle: l10n.stepDesc4, icon: Icons.directions_car_rounded),
      _StepData(number: 5, title: l10n.stepTitle5, subtitle: l10n.stepDesc5, icon: Icons.description_rounded),
      _StepData(number: 6, title: l10n.stepTitle6, subtitle: l10n.stepDesc6, icon: Icons.check_circle_rounded),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.reportingGuideTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppConstants.spacingMd),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.sixSteps,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: currentStep / 6,
              backgroundColor: AppColors.border,
              color: AppColors.primary,
              minHeight: 3,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingScreen,
                AppConstants.spacingLg,
                AppConstants.paddingScreen,
                AppConstants.spacingMd,
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: l10n.followSteps),
                    TextSpan(
                      text: l10n.minorAccident,
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingMd,
                ),
                itemCount: steps.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: AppColors.divider,
                  indent: AppConstants.paddingScreen + 36 + AppConstants.spacingMd,
                ),
                itemBuilder: (context, i) {
                  final step = steps[i];
                  final StepStatus status;
                  if (i < currentStep) {
                    status = StepStatus.completed;
                  } else if (i == currentStep) {
                    status = StepStatus.active;
                  } else {
                    status = StepStatus.pending;
                  }
                  return GuideStepItem(
                    stepNumber: step.number,
                    title: step.title,
                    subtitle: step.subtitle,
                    icon: step.icon,
                    status: status,
                    onTap: () {
                      context.read<ReportProvider>().setGuideStep(i);
                      context.push('/help/guide/${step.number}');
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: SizedBox(
                width: double.infinity,
                height: AppConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => context.push('/report/qr-session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.startReportingNow,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
