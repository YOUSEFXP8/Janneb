import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../common/widgets/status_timeline_item.dart';
import '../../../../common/widgets/summary_card.dart';
import '../../../../common/widgets/primary_button.dart';
import '../providers/report_provider.dart';

class ReportDetailsScreen extends StatelessWidget {
  final int accidentId;

  const ReportDetailsScreen({super.key, required this.accidentId});

  String _formatStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'REPORTED':
        return l10n.statusReported;
      case 'UNDER_REVIEW':
        return l10n.statusUnderReview;
      case 'COMPLETED':
        return l10n.statusCompleted;
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  int _getStatusStep(String status) {
    const steps = ['REPORTED', 'UNDER_REVIEW', 'COMPLETED'];
    final index = steps.indexOf(status);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportStatus),
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
                    status: _formatStatus(report.status, l10n),
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
                            title: l10n.timelineReportSubmitted,
                            subtitle: l10n.timelineReportReceived,
                            isCompleted: currentStepIndex > 0,
                            isCurrent: currentStepIndex == 0,
                          ),
                          StatusTimelineItem(
                            title: l10n.timelineUnderReview,
                            subtitle: l10n.timelineTrafficReviewing,
                            isCompleted: currentStepIndex > 1,
                            isCurrent: currentStepIndex == 1,
                          ),
                          StatusTimelineItem(
                            title: l10n.timelineCaseCompleted,
                            subtitle: l10n.timelineFinalReport,
                            isCompleted: currentStepIndex >= 2,
                            isCurrent: currentStepIndex == 2,
                            isLast: true,
                          ),
                          const SizedBox(height: AppConstants.spacingXl),
                          Text(
                            l10n.expectedCompletion,
                            style: const TextStyle(
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
                    text: l10n.downloadReport,
                    onPressed: report.officerReportUrl != null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.pdfComingSoon),
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
