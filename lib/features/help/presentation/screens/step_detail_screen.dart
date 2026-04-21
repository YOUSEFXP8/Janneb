import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/photo_item_card.dart';

class _InstructionItem {
  const _InstructionItem(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}

class _StepDetail {
  const _StepDetail({
    required this.title,
    required this.description,
    required this.highlightWord,
    required this.stepIcon,
    required this.chipLabel,
    required this.sectionLabel,
    required this.instructions,
    required this.warningText,
    required this.warningSubtitle,
    required this.nextButtonLabel,
  });

  final String title;
  final String description;
  final String highlightWord;
  final IconData stepIcon;
  final String chipLabel;
  final String sectionLabel;
  final List<_InstructionItem> instructions;
  final String warningText;
  final String warningSubtitle;
  final String nextButtonLabel;
}

const Map<int, _StepDetail> _stepDetails = {
  1: _StepDetail(
    title: 'Ensure safety first',
    description:
        'Move to a safe position and turn on hazard lights immediately after the accident.',
    highlightWord: 'safe',
    stepIcon: Icons.warning_rounded,
    chipLabel: 'Safety',
    sectionLabel: 'SAFETY CHECKLIST',
    instructions: [
      _InstructionItem(Icons.warning_rounded, 'Turn on hazard lights',
          'Alert other drivers to the hazard immediately'),
      _InstructionItem(Icons.directions_car_rounded, 'Move to roadside',
          'If safe, move vehicles out of traffic flow'),
      _InstructionItem(
          Icons.phone_rounded, 'Check for injuries', 'Call 999 if anyone is injured'),
      _InstructionItem(Icons.security_rounded, 'Stay visible',
          'Use warning triangles or reflective vests if available'),
    ],
    warningText: 'Never leave the scene of an accident',
    warningSubtitle: 'Leaving the scene is a criminal offence in most regions',
    nextButtonLabel: 'Next step: Document accident →',
  ),
  2: _StepDetail(
    title: 'Document the accident',
    description:
        'Take clear photos of both vehicles and any visible damage.',
    highlightWord: 'photos',
    stepIcon: Icons.camera_alt_rounded,
    chipLabel: 'Photos',
    sectionLabel: 'WHAT TO PHOTOGRAPH',
    instructions: [
      _InstructionItem(Icons.camera_alt_rounded, 'Both vehicles from multiple angles',
          'Front, rear, sides — at least 4 photos per car'),
      _InstructionItem(Icons.warning_amber_rounded, 'All visible damage close-up',
          'Zoom in on scratches, dents, and paint transfer'),
      _InstructionItem(Icons.credit_card_rounded, 'License plates of both cars',
          'Must be legible — no blur or glare'),
      _InstructionItem(Icons.location_on_rounded, 'The surrounding road scene',
          'Street signs, lane markings, road conditions'),
    ],
    warningText: 'Do NOT move vehicles before taking photos',
    warningSubtitle:
        'Evidence photos are required for your insurance claim',
    nextButtonLabel: 'Next step: Confirm location →',
  ),
  3: _StepDetail(
    title: 'Confirm your location',
    description:
        'Verify GPS accuracy or adjust the pin manually on the map.',
    highlightWord: 'GPS',
    stepIcon: Icons.location_on_rounded,
    chipLabel: 'Location',
    sectionLabel: 'LOCATION DETAILS',
    instructions: [
      _InstructionItem(Icons.gps_fixed_rounded, 'Enable GPS on your device',
          'High accuracy mode gives the best results'),
      _InstructionItem(Icons.map_rounded, 'Review the map pin',
          'Drag the pin if it does not match your exact position'),
      _InstructionItem(Icons.edit_location_rounded, 'Add address details',
          'Street name, landmark, or junction reference'),
      _InstructionItem(Icons.check_circle_rounded, 'Confirm the location',
          'Tap confirm once the pin is accurately placed'),
    ],
    warningText: 'Inaccurate location can delay your report',
    warningSubtitle:
        'Officers are dispatched based on the location you provide',
    nextButtonLabel: 'Next step: Vehicle details →',
  ),
  4: _StepDetail(
    title: 'Enter vehicle details',
    description:
        'Add plate number, insurance, and description for both vehicles.',
    highlightWord: 'insurance',
    stepIcon: Icons.directions_car_rounded,
    chipLabel: 'Details',
    sectionLabel: 'REQUIRED INFORMATION',
    instructions: [
      _InstructionItem(Icons.confirmation_number_rounded, 'License plate numbers',
          'Record both your plate and the other driver\'s plate'),
      _InstructionItem(Icons.shield_rounded, 'Insurance details',
          'Policy number and insurance company name'),
      _InstructionItem(Icons.person_rounded, 'Driver information',
          'Full name, phone number, and driving licence number'),
      _InstructionItem(Icons.description_rounded, 'Vehicle description',
          'Make, model, colour, and year of manufacture'),
    ],
    warningText: 'Exchange details with the other driver',
    warningSubtitle: 'You are legally required to provide your details',
    nextButtonLabel: 'Next step: Review report →',
  ),
  5: _StepDetail(
    title: 'Review your report',
    description:
        'Check all information before submitting your report.',
    highlightWord: 'before',
    stepIcon: Icons.description_rounded,
    chipLabel: 'Review',
    sectionLabel: 'REVIEW CHECKLIST',
    instructions: [
      _InstructionItem(Icons.camera_alt_rounded, 'Photos attached',
          'At least 4 clear photos of the accident scene'),
      _InstructionItem(Icons.location_on_rounded, 'Location confirmed',
          'Map pin placed accurately at the accident site'),
      _InstructionItem(Icons.person_rounded, 'Driver details complete',
          'Both drivers\' information entered correctly'),
      _InstructionItem(Icons.check_rounded, 'Report summary reviewed',
          'All details are accurate before final submission'),
    ],
    warningText: 'Reports cannot be edited after submission',
    warningSubtitle:
        'Double-check all information before tapping Submit',
    nextButtonLabel: 'Next step: Submit report →',
  ),
  6: _StepDetail(
    title: 'Submit and move vehicle',
    description:
        'Submit your report, then move safely to the roadside.',
    highlightWord: 'safely',
    stepIcon: Icons.check_circle_rounded,
    chipLabel: 'Submit',
    sectionLabel: 'AFTER SUBMISSION',
    instructions: [
      _InstructionItem(Icons.send_rounded, 'Submit your report',
          'Tap the submit button to send your report'),
      _InstructionItem(Icons.receipt_rounded, 'Save your reference number',
          'You will receive a tracking reference via SMS'),
      _InstructionItem(Icons.directions_car_rounded, 'Move vehicle safely',
          'Clear the road only after the report is submitted'),
      _InstructionItem(Icons.track_changes_rounded, 'Track your case',
          'Monitor report progress in My Reports'),
    ],
    warningText: 'Keep a copy of your reference number',
    warningSubtitle:
        'You will need it to track your report status and for insurance',
    nextButtonLabel: 'Start reporting now',
  ),
};

class StepDetailScreen extends StatelessWidget {
  const StepDetailScreen({super.key, required this.stepId});

  final int stepId;

  @override
  Widget build(BuildContext context) {
    final detail = _stepDetails[stepId] ?? _stepDetails[2]!;

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
          'Step $stepId of 6',
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
              detail.chipLabel,
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
          children: [
            LinearProgressIndicator(
              value: stepId / 6,
              backgroundColor: AppColors.border,
              color: AppColors.primary,
              minHeight: 3,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingScreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.spacingLg),
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          detail.stepIcon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Center(
                      child: Text(
                        detail.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    Center(
                      child: _buildDescription(detail),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Text(
                      detail.sectionLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    ...detail.instructions.map(
                      (item) => PhotoItemCard(
                        icon: item.icon,
                        title: item.title,
                        subtitle: item.subtitle,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _WarningCard(
                      text: detail.warningText,
                      subtitle: detail.warningSubtitle,
                    ),
                    const SizedBox(height: AppConstants.spacingXxl),
                  ],
                ),
              ),
            ),
            _StickyBottom(stepId: stepId, detail: detail),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(_StepDetail detail) {
    final text = detail.description;
    final word = detail.highlightWord;
    final idx = text.toLowerCase().indexOf(word.toLowerCase());

    if (idx == -1) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + word.length),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(idx + word.length)),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text, required this.subtitle});
  final String text;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingCard),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '!',
                style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyBottom extends StatelessWidget {
  const _StickyBottom({required this.stepId, required this.detail});
  final int stepId;
  final _StepDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBackground,
      padding: const EdgeInsets.all(AppConstants.paddingScreen),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                if (stepId < 6) {
                  context.pushReplacement('/help/guide/${stepId + 1}');
                } else {
                  context.push('/report/qr-session');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                elevation: 0,
              ),
              child: Text(
                detail.nextButtonLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          GestureDetector(
            onTap: () => context.pop(),
            child: const Center(
              child: Text(
                '← Back to step list',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
