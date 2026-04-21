import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/photo_item_card.dart';

class _InfoItem {
  const _InfoItem(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}

class _TopicSection {
  const _TopicSection({required this.label, required this.items});
  final String label;
  final List<_InfoItem> items;
}

class _TopicContent {
  const _TopicContent({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<_TopicSection> sections;
}

const Map<String, _TopicContent> _topics = {
  'accident-reporting': _TopicContent(
    title: 'Accident Reporting',
    subtitle: 'Full reporting guide',
    icon: Icons.directions_car_rounded,
    description:
        'Reporting an accident correctly protects you legally and helps '
        'speed up your insurance claim. Follow these steps to file a complete '
        'and accurate report through CrashAssist.',
    sections: [
      _TopicSection(
        label: 'WHAT TO DO IMMEDIATELY',
        items: [
          _InfoItem(Icons.warning_rounded, 'Stop and stay at the scene',
              'Never leave — it is a legal requirement in most regions'),
          _InfoItem(Icons.shield_rounded, 'Check for injuries',
              'Call 999 immediately if anyone is hurt'),
          _InfoItem(Icons.warning_amber_rounded, 'Turn on hazard lights',
              'Warn other drivers and prevent a second accident'),
          _InfoItem(Icons.camera_alt_rounded, 'Start documenting',
              'Open CrashAssist and begin the reporting flow'),
        ],
      ),
      _TopicSection(
        label: 'INFORMATION YOU WILL NEED',
        items: [
          _InfoItem(Icons.person_rounded, 'Other driver\'s details',
              'Full name, phone number, licence number'),
          _InfoItem(Icons.credit_card_rounded, 'Both licence plates',
              'Photograph both plates for accuracy'),
          _InfoItem(Icons.shield_rounded, 'Insurance details',
              'Policy number and insurer name for both vehicles'),
          _InfoItem(Icons.location_on_rounded, 'Exact accident location',
              'Road name, junction, or nearby landmark'),
        ],
      ),
      _TopicSection(
        label: 'TIPS FOR A STRONG REPORT',
        items: [
          _InfoItem(Icons.access_time_rounded, 'Report within 24 hours',
              'The sooner you report, the stronger your case'),
          _InfoItem(Icons.people_rounded, 'Collect witness details',
              'Names and phone numbers of any witnesses'),
          _InfoItem(Icons.description_rounded, 'Write a clear description',
              'Describe how the accident happened in your own words'),
          _InfoItem(Icons.check_circle_rounded, 'Review before submitting',
              'Double-check all details — reports cannot be edited after submission'),
        ],
      ),
    ],
  ),

  'photos-evidence': _TopicContent(
    title: 'Photos & Evidence',
    subtitle: 'What to capture',
    icon: Icons.camera_alt_rounded,
    description:
        'Photos are the single most important evidence in any accident claim. '
        'Good photos can resolve disputes and speed up your insurance payout. '
        'Take them before moving any vehicles.',
    sections: [
      _TopicSection(
        label: 'WHAT TO PHOTOGRAPH',
        items: [
          _InfoItem(Icons.directions_car_rounded, 'Both vehicles, all angles',
              'Front, rear, left, and right sides — minimum 4 shots per car'),
          _InfoItem(Icons.warning_amber_rounded, 'All visible damage close-up',
              'Zoom in on dents, scratches, and paint transfer'),
          _InfoItem(Icons.credit_card_rounded, 'Licence plates',
              'Photograph both plates clearly — no blur or glare'),
          _InfoItem(Icons.location_on_rounded, 'The road scene',
              'Street signs, lane markings, traffic lights, skid marks'),
          _InfoItem(Icons.person_rounded, 'Driver documents',
              'Driving licence and insurance certificate of the other driver'),
          _InfoItem(Icons.wb_cloudy_rounded, 'Weather and lighting',
              'A wide shot showing road conditions at the time'),
        ],
      ),
      _TopicSection(
        label: 'PHOTO TIPS',
        items: [
          _InfoItem(Icons.flash_on_rounded, 'Use flash in low light',
              'Evening and night accidents need flash for clear shots'),
          _InfoItem(Icons.crop_rounded, 'Do not crop in-app',
              'Upload full-resolution originals for best evidence quality'),
          _InfoItem(Icons.rotate_left_rounded, 'Take landscape shots',
              'Wide shots show the full scene and vehicle positions'),
          _InfoItem(Icons.check_circle_rounded, 'Review each photo',
              'Make sure every image is in focus before moving on'),
        ],
      ),
      _TopicSection(
        label: 'COMMON MISTAKES TO AVOID',
        items: [
          _InfoItem(Icons.pan_tool_rounded, 'Moving vehicles first',
              'Always photograph before moving — positions are legal evidence'),
          _InfoItem(Icons.visibility_off_rounded, 'Blurry or dark images',
              'Retake any photo that is unclear — quality matters more than speed'),
          _InfoItem(Icons.close_rounded, 'Forgetting the road scene',
              'The surrounding area gives crucial context for fault assessment'),
        ],
      ),
    ],
  ),

  'location-maps': _TopicContent(
    title: 'Location & Maps',
    subtitle: 'GPS and manual input',
    icon: Icons.location_on_rounded,
    description:
        'Your exact accident location helps officers respond faster and '
        'ensures your report is linked to the correct jurisdiction. '
        'CrashAssist detects your location automatically, but you can '
        'adjust it manually if needed.',
    sections: [
      _TopicSection(
        label: 'HOW LOCATION WORKS',
        items: [
          _InfoItem(Icons.gps_fixed_rounded, 'Automatic GPS detection',
              'The app reads your device location when you start a report'),
          _InfoItem(Icons.map_rounded, 'Interactive map pin',
              'A draggable pin lets you correct the position if GPS drifts'),
          _InfoItem(Icons.search_rounded, 'Address search',
              'Type a street name or postcode to place the pin precisely'),
          _InfoItem(Icons.share_location_rounded, 'Location is saved with your report',
              'Coordinates are attached to every photo and submission'),
        ],
      ),
      _TopicSection(
        label: 'IMPROVING GPS ACCURACY',
        items: [
          _InfoItem(Icons.settings_rounded, 'Enable high-accuracy mode',
              'Go to device Settings → Location → High accuracy for best results'),
          _InfoItem(Icons.signal_wifi_4_bar_rounded, 'Stay connected',
              'Wi-Fi and mobile data improve GPS fix speed'),
          _InfoItem(Icons.open_with_rounded, 'Move away from buildings',
              'Tall structures can cause GPS signal to reflect and drift'),
          _InfoItem(Icons.timer_rounded, 'Wait for a stable fix',
              'Give the GPS a few seconds to settle before confirming'),
        ],
      ),
      _TopicSection(
        label: 'MANUAL PIN ADJUSTMENT',
        items: [
          _InfoItem(Icons.touch_app_rounded, 'Drag the pin on the map',
              'Press and hold the pin, then drag it to the exact spot'),
          _InfoItem(Icons.edit_rounded, 'Type a description',
              'Add a text note such as "junction of High Street and Park Lane"'),
          _InfoItem(Icons.check_rounded, 'Tap Confirm Location',
              'Always confirm before proceeding to the next step'),
        ],
      ),
    ],
  ),

  'after-submission': _TopicContent(
    title: 'After Submission',
    subtitle: 'Tracking your report',
    icon: Icons.schedule_rounded,
    description:
        'Once your report is submitted, CrashAssist tracks it through '
        'every stage of review. You will receive notifications as the '
        'status changes, and you can check progress any time in My Reports.',
    sections: [
      _TopicSection(
        label: 'REPORT STATUSES',
        items: [
          _InfoItem(Icons.send_rounded, 'Submitted',
              'Your report has been received and is in the queue'),
          _InfoItem(Icons.manage_search_rounded, 'Under Review',
              'A traffic officer is reviewing the details and photos'),
          _InfoItem(Icons.person_pin_rounded, 'Officer Assigned',
              'An officer has been assigned and will follow up'),
          _InfoItem(Icons.check_circle_rounded, 'Completed',
              'The report has been processed and an official record created'),
        ],
      ),
      _TopicSection(
        label: 'WHAT HAPPENS NEXT',
        items: [
          _InfoItem(Icons.sms_rounded, 'SMS confirmation',
              'You will receive a reference number by text after submission'),
          _InfoItem(Icons.notifications_rounded, 'Push notifications',
              'CrashAssist notifies you each time your report status changes'),
          _InfoItem(Icons.article_rounded, 'Official report download',
              'Once completed, download the official report from My Reports'),
          _InfoItem(Icons.business_rounded, 'Insurance forwarding',
              'Share your reference number with your insurer to start your claim'),
        ],
      ),
      _TopicSection(
        label: 'IF YOU NEED HELP',
        items: [
          _InfoItem(Icons.phone_rounded, 'Call our helpline',
              'Available 24/7 — tap the emergency card on the Help screen'),
          _InfoItem(Icons.help_outline_rounded, 'Browse the FAQ',
              'Common questions answered in the FAQ section'),
          _InfoItem(Icons.history_rounded, 'Check My Reports',
              'View full report history, photos, and status updates'),
        ],
      ),
    ],
  ),
};

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({super.key, required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context) {
    final content = _topics[topicId];
    if (content == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Topic not found')),
      );
    }

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
          content.title,
          style: const TextStyle(
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
              // Hero card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(content.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            content.subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Description
              Text(
                content.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),

              // Sections
              ...content.sections.map(
                (section) => _SectionBlock(section: section),
              ),

              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section});
  final _TopicSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.spacingLg),
        Text(
          section.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...section.items.map(
          (item) => PhotoItemCard(
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
          ),
        ),
      ],
    );
  }
}
