import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/step_progress_indicator.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _markSeenAndGoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) context.go('/login');
  }

  void _nextPage(int pagesLength) {
    if (_currentPage < pagesLength - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationNormal,
        curve: Curves.easeInOut,
      );
    } else {
      _markSeenAndGoLogin();
    }
  }

  void _skip() => _markSeenAndGoLogin();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      {
        'icon': Icons.description_rounded,
        'title': l10n.onboardingTitle1,
        'description': l10n.onboardingDesc1,
      },
      {
        'icon': Icons.camera_alt_rounded,
        'title': l10n.onboardingTitle2,
        'description': l10n.onboardingDesc2,
      },
      {
        'icon': Icons.support_agent_rounded,
        'title': l10n.onboardingTitle3,
        'description': l10n.onboardingDesc3,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: AppConstants.paddingScreen,
                  top: AppConstants.spacingMd,
                ),
                child: _currentPage < pages.length - 1
                    ? TextButton(
                        onPressed: _skip,
                        child: Text(
                          l10n.skip,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const SizedBox(height: 48),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    icon: pages[index]['icon'] as IconData,
                    title: pages[index]['title'] as String,
                    description: pages[index]['description'] as String,
                  );
                },
              ),
            ),
            StepProgressIndicator(
              totalSteps: pages.length,
              currentStep: _currentPage,
            ),
            const SizedBox(height: AppConstants.spacingXl),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingScreen,
              ),
              child: PrimaryButton(
                text: _currentPage == pages.length - 1 ? l10n.getStarted : l10n.next,
                onPressed: () => _nextPage(pages.length),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }
}
