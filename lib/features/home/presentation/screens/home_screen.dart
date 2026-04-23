import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../common/widgets/report_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/widgets/notification_menu.dart';
import '../../../report_accident/presentation/providers/report_provider.dart';
import '../widgets/action_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final nationalId = auth.nationalId ?? '';
      if (nationalId.isNotEmpty) {
        context.read<ReportProvider>().fetchReports(nationalId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingSm),

              // User Greeting
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.person_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                      onPressed: () => context.push('/profile'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.hello}, ${auth.displayName}! 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              AppStrings.locationPlaceholder,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showNotificationMenu(context),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                unreadCount > 9 ? '9+' : '$unreadCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Emergency Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusLg,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Need to report an accident?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quickly file a report with photos, location, and details.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.push('/report/qr-session'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              AppStrings.reportAccident,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  ActionCard(
                    title: AppStrings.myReports,
                    icon: Icons.description_rounded,
                    iconColor: AppColors.primary,
                    onTap: () => context.push('/my-reports'),
                  ),
                  ActionCard(
                    title: AppStrings.emergencyCall,
                    icon: Icons.phone_in_talk_rounded,
                    iconColor: AppColors.error,
                    onTap: () => context.push('/emergency'),
                  ),
                  ActionCard(
                    title: AppStrings.help,
                    icon: Icons.help_outline_rounded,
                    iconColor: AppColors.warning,
                    onTap: () => context.push('/help'),
                  ),
                  ActionCard(
                    title: 'Insurance',
                    icon: Icons.shield_rounded,
                    iconColor: AppColors.primary,
                    onTap: () => context.push('/insurance'),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Recent Reports Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Reports',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                 
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),

              Consumer<ReportProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final recent = provider.reports.take(3).toList();

                  if (recent.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 48,
                            color: AppColors.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No reports yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your accident reports will appear here',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: recent
                        .map(
                          (report) => ReportCard(
                            report: report,
                            onTap: () => context.push(
                              '/report-details/${report.accidentId}',
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
