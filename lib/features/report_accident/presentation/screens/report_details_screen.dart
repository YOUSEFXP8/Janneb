import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../common/widgets/status_timeline_item.dart';
import '../../../../common/widgets/summary_card.dart';
import '../../../../common/widgets/primary_button.dart';
import '../providers/report_provider.dart';

class ReportDetailsScreen extends StatelessWidget {
  final int accidentId;

  const ReportDetailsScreen({super.key, required this.accidentId});

  String _formatStatus(String status) {
    switch (status) {
      case 'REPORTED':
        return 'Reported';
      case 'UNDER_REVIEW':
        return 'Under Review';
      case 'OFFICER_ASSIGNED':
        return 'Officer Assigned';
      case 'COMPLETED':
        return 'Completed';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Helper inside to compute timeline logic mapping
  int _getStatusStep(String status) {
    const steps = ['REPORTED', 'UNDER_REVIEW', 'OFFICER_ASSIGNED', 'COMPLETED'];
    final index = steps.indexOf(status);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Consumer<ReportProvider>(
          builder: (context, provider, child) {
            final report = provider.getReportById(accidentId);
            final currentStepIndex = _getStatusStep(report.status);

            return Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '#CR-2025-${report.accidentId.toString().padLeft(6, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  SummaryCard(
                    status: _formatStatus(report.status),
                    latitude: report.latitude,
                    longitude: report.longitude,
                    date: _formatDate(report.date),
                  ),
                  const SizedBox(height: AppConstants.spacingXl),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusTimelineItem(
                            title: 'Report Submitted',
                            subtitle: 'Report details received',
                            isCompleted: currentStepIndex > 0,
                            isCurrent: currentStepIndex == 0,
                          ),
                          StatusTimelineItem(
                            title: 'Under Review',
                            subtitle: 'Traffic authority reviewing',
                            isCompleted: currentStepIndex > 1,
                            isCurrent: currentStepIndex == 1,
                          ),
                          StatusTimelineItem(
                            title: 'Officer Assigned',
                            subtitle: 'An officer is handling the case',
                            isCompleted: currentStepIndex > 2,
                            isCurrent: currentStepIndex == 2,
                          ),
                          StatusTimelineItem(
                            title: 'Case Completed',
                            subtitle: 'Final report has been issued',
                            isCompleted: currentStepIndex >= 3,
                            isCurrent: currentStepIndex == 3,
                            isLast: true,
                          ),
                          const SizedBox(height: AppConstants.spacingXl),
                          const Text(
                            'Expected completion: 45 minutes',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  PrimaryButton(
                    text: 'Download Final Report (PDF)',
                    onPressed: report.officerReportUrl != null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PDF download coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
