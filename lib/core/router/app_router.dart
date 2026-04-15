import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
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

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
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
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          },
        ),
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
