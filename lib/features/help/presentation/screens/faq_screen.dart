import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const List<Map<String, String>> _generalFaqs = [
    {
      'q': 'What is CrashAssist?',
      'a':
          'CrashAssist helps you quickly file accident reports with photos, location, and driver details. Reports are sent directly to relevant traffic authorities.',
    },
    {
      'q': 'Is my data secure?',
      'a':
          'All data is encrypted in transit and at rest. Your information is only shared with relevant traffic authorities and your insurance provider.',
    },
    {
      'q': 'Do I need an internet connection?',
      'a':
          'An active internet connection is required to submit reports and track their status. You can draft a report offline, but submission requires connectivity.',
    },
    {
      'q': 'Which types of accidents can I report?',
      'a':
          'CrashAssist supports minor and moderate vehicle accidents. For serious accidents with injuries, always call emergency services first.',
    },
  ];

  static const List<Map<String, String>> _reportingFaqs = [
    {
      'q': 'How many photos should I take?',
      'a':
          'Take at least 4 photos per vehicle — front, rear, and both sides. Also capture license plates, visible damage close-up, and the surrounding road scene.',
    },
    {
      'q': 'What if I can\'t confirm my location?',
      'a':
          'You can manually adjust the map pin or type a location description in the details field. Make sure GPS is enabled for best accuracy.',
    },
    {
      'q': 'Can I edit a report after submitting?',
      'a':
          'Reports cannot be edited after submission. If corrections are needed, contact support through the app or call the helpline.',
    },
    {
      'q': 'How long does report review take?',
      'a':
          'Most reports are reviewed within 45 minutes during business hours. You will receive a notification when the status changes.',
    },
  ];

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
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel(label: 'GENERAL'),
              const SizedBox(height: AppConstants.spacingMd),
              ..._generalFaqs.map((faq) => _FaqTile(
                    question: faq['q']!,
                    answer: faq['a']!,
                  )),
              const SizedBox(height: AppConstants.spacingLg),
              _SectionLabel(label: 'REPORTING'),
              const SizedBox(height: AppConstants.spacingMd),
              ..._reportingFaqs.map((faq) => _FaqTile(
                    question: faq['q']!,
                    answer: faq['a']!,
                  )),
              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingCard,
            vertical: 4,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppConstants.paddingCard,
            0,
            AppConstants.paddingCard,
            AppConstants.paddingCard,
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecondary,
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
