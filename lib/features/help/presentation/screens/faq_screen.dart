import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _selectedFilter = 'all';

  static const List<Map<String, String>> _generalFaqs = [
    {
      'q': 'What is Janneb?',
      'a':
          'Janneb helps you quickly file accident reports with photos, location, and driver details. Reports are sent directly to relevant traffic authorities.',
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
          'Janneb supports minor and moderate vehicle accidents. For serious accidents with injuries, always call emergency services first.',
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

  List<Map<String, String>> get _displayedFaqs {
    switch (_selectedFilter) {
      case 'general':
        return _generalFaqs;
      case 'reporting':
        return _reportingFaqs;
      default:
        return [..._generalFaqs, ..._reportingFaqs];
    }
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter pills
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingScreen,
                AppConstants.spacingMd,
                AppConstants.paddingScreen,
                0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterPill(
                      label: 'All',
                      isActive: _selectedFilter == 'all',
                      onTap: () => setState(() => _selectedFilter = 'all'),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    _FilterPill(
                      label: 'General',
                      isActive: _selectedFilter == 'general',
                      onTap: () => setState(() => _selectedFilter = 'general'),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    _FilterPill(
                      label: 'Reporting',
                      isActive: _selectedFilter == 'reporting',
                      onTap: () =>
                          setState(() => _selectedFilter = 'reporting'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            // FAQ list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingScreen,
                  0,
                  AppConstants.paddingScreen,
                  AppConstants.spacingXl,
                ),
                children: _displayedFaqs
                    .map((faq) => _FaqTile(
                          question: faq['q']!,
                          answer: faq['a']!,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(99),
          border: isActive
              ? null
              : Border.all(color: AppColors.border, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
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
