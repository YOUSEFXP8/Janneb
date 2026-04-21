import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
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

const List<_StepData> _steps = [
  _StepData(
    number: 1,
    title: 'Ensure safety first',
    subtitle: 'Move to a safe position, turn on hazard lights',
    icon: Icons.warning_rounded,
  ),
  _StepData(
    number: 2,
    title: 'Document the accident',
    subtitle: 'Take clear photos of both vehicles and damage',
    icon: Icons.camera_alt_rounded,
  ),
  _StepData(
    number: 3,
    title: 'Confirm your location',
    subtitle: 'Verify GPS accuracy or adjust pin manually',
    icon: Icons.location_on_rounded,
  ),
  _StepData(
    number: 4,
    title: 'Enter vehicle details',
    subtitle: 'Add plate number, insurance, and description',
    icon: Icons.directions_car_rounded,
  ),
  _StepData(
    number: 5,
    title: 'Review your report',
    subtitle: 'Check all information before submitting',
    icon: Icons.description_rounded,
  ),
  _StepData(
    number: 6,
    title: 'Submit and move vehicle',
    subtitle: 'Submit report, then move safely to roadside',
    icon: Icons.check_circle_rounded,
  ),
];

class ReportingGuideScreen extends StatefulWidget {
  const ReportingGuideScreen({super.key});

  @override
  State<ReportingGuideScreen> createState() => _ReportingGuideScreenState();
}

class _ReportingGuideScreenState extends State<ReportingGuideScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Reporting guide',
          style: TextStyle(
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
            child: const Text(
              '6 steps',
              style: TextStyle(
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
              value: (_currentStep + 1) / 6,
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
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'Follow these steps after a '),
                    TextSpan(
                      text: 'minor accident',
                      style: TextStyle(
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
                itemCount: _steps.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: AppColors.divider,
                  indent: AppConstants.paddingScreen + 36 + AppConstants.spacingMd,
                ),
                itemBuilder: (context, i) {
                  final step = _steps[i];
                  final StepStatus status;
                  if (i < _currentStep) {
                    status = StepStatus.completed;
                  } else if (i == _currentStep) {
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
                      setState(() => _currentStep = i);
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
                  child: const Text(
                    'Start reporting now',
                    style: TextStyle(
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
