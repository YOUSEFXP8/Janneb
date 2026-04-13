import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
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

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.description_rounded,
      'title': AppStrings.onboardingTitle1,
      'description': AppStrings.onboardingDesc1,
    },
    {
      'icon': Icons.camera_alt_rounded,
      'title': AppStrings.onboardingTitle2,
      'description': AppStrings.onboardingDesc2,
    },
    {
      'icon': Icons.support_agent_rounded,
      'title': AppStrings.onboardingTitle3,
      'description': AppStrings.onboardingDesc3,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationNormal,
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void _skip() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: AppConstants.paddingScreen,
                  top: AppConstants.spacingMd,
                ),
                child: _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: _skip,
                        child: const Text(
                          AppStrings.skip,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const SizedBox(height: 48),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    icon: _pages[index]['icon'] as IconData,
                    title: _pages[index]['title'] as String,
                    description: _pages[index]['description'] as String,
                  );
                },
              ),
            ),

            // Progress Indicators
            StepProgressIndicator(
              totalSteps: _pages.length,
              currentStep: _currentPage,
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingScreen,
              ),
              child: PrimaryButton(
                text: _currentPage == _pages.length - 1
                    ? AppStrings.getStarted
                    : AppStrings.next,
                onPressed: _nextPage,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }
}
