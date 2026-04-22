import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/complete_profile_screen.dart';
import '../../features/auth/presentation/screens/car_list_screen.dart';
import '../../features/auth/presentation/screens/add_car_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/emergency_screen.dart';
import '../../features/report_accident/presentation/screens/qr_session_screen.dart';
import '../../features/report_accident/presentation/screens/qr_scanner_screen.dart';
import '../../features/report_accident/presentation/screens/my_reports_screen.dart';
import '../../features/report_accident/presentation/screens/report_details_screen.dart';
import '../../features/report_accident/presentation/screens/capture_evidence_screen.dart';
import '../../features/report_accident/presentation/screens/location_screen.dart';
import '../../features/report_accident/presentation/screens/driver_details_screen.dart';
import '../../features/report_accident/presentation/screens/review_screen.dart';
import '../../features/report_accident/presentation/screens/success_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/help/presentation/screens/reporting_guide_screen.dart';
import '../../features/help/presentation/screens/step_detail_screen.dart';
import '../../features/help/presentation/screens/faq_screen.dart';
import '../../features/help/presentation/screens/topic_detail_screen.dart';
import '../../features/insurance/presentation/screens/insurance_screen.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final auth = context.read<AuthProvider>();
        final isAuth = auth.isAuthenticated;
        final hasProfile = auth.nationalId != null;
        final path = state.uri.path;

        final publicPaths = ['/splash', '/onboarding', '/login', '/signup'];
        final onboardingPaths = ['/complete-profile', '/cars', '/cars/add'];

        if (!isAuth && !publicPaths.contains(path)) return '/login';
        if (isAuth && (path == '/login' || path == '/signup')) {
          return hasProfile ? '/home' : '/complete-profile';
        }
        if (isAuth && !hasProfile && !onboardingPaths.contains(path)) {
          return '/complete-profile';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const SignUpScreen()),
        ),
        GoRoute(
          path: '/complete-profile',
          name: 'complete-profile',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const CompleteProfileScreen()),
        ),
        GoRoute(
          path: '/cars',
          name: 'cars',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const CarListScreen()),
        ),
        GoRoute(
          path: '/cars/add',
          name: 'add-car',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const AddCarScreen()),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const ProfileScreen()),
        ),
        GoRoute(
          path: '/profile/edit',
          name: 'profile-edit',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const EditProfileScreen()),
        ),
        GoRoute(
          path: '/emergency',
          name: 'emergency',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const EmergencyScreen()),
        ),
        GoRoute(
          path: '/report/qr-session',
          name: 'qr-session',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const QrSessionScreen()),
        ),
        GoRoute(
          path: '/report/qr-scanner',
          name: 'qr-scanner',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const QrScannerScreen()),
        ),
        GoRoute(
          path: '/my-reports',
          name: 'my-reports',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const MyReportsScreen()),
        ),
        GoRoute(
          path: '/report-details/:id',
          name: 'report-details',
          pageBuilder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return _buildSlideTransition(
              state,
              ReportDetailsScreen(accidentId: id),
            );
          },
        ),
        GoRoute(
          path: '/report/capture-evidence',
          name: 'capture-evidence',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const CaptureEvidenceScreen()),
        ),
        GoRoute(
          path: '/report/location',
          name: 'location',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const LocationScreen()),
        ),
        GoRoute(
          path: '/report/driver-details',
          name: 'driver-details',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const DriverDetailsScreen()),
        ),
        GoRoute(
          path: '/report/review',
          name: 'review',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const ReviewScreen()),
        ),
        GoRoute(
          path: '/help',
          name: 'help',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const HelpScreen()),
        ),
        GoRoute(
          path: '/help/guide',
          name: 'help-guide',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const ReportingGuideScreen()),
        ),
        GoRoute(
          path: '/help/guide/:stepId',
          name: 'help-guide-step',
          pageBuilder: (context, state) {
            final stepId =
                (int.tryParse(state.pathParameters['stepId'] ?? '') ?? 2)
                    .clamp(1, 6)
                    .toInt();
            return _buildSlideTransition(
              state,
              StepDetailScreen(stepId: stepId),
            );
          },
        ),
        GoRoute(
          path: '/help/faq',
          name: 'help-faq',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const FaqScreen()),
        ),
        GoRoute(
          path: '/help/topic/:topicId',
          name: 'help-topic',
          pageBuilder: (context, state) {
            final topicId = state.pathParameters['topicId'] ?? '';
            return _buildSlideTransition(
              state,
              TopicDetailScreen(topicId: topicId),
            );
          },
        ),
        GoRoute(
          path: '/insurance',
          name: 'insurance',
          pageBuilder: (context, state) =>
              _buildSlideTransition(state, const InsuranceScreen()),
        ),
        GoRoute(
          path: '/report/success',
          name: 'success',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SuccessScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          ),
        ),
      ],
    );
  }

  static CustomTransitionPage _buildSlideTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }
}
