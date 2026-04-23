import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/report_accident/presentation/providers/report_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://buyflcxseboygugyemmt.supabase.co',
    anonKey: 'sb_publishable_HcNTHRXTB3BQCPgr9oIarQ_LiR-VMxK',
  );
  runApp(const JannebApp());
}

class JannebApp extends StatelessWidget {
  const JannebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.read<AuthProvider>();
          return MaterialApp.router(
            title: 'Janneb',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.createRouter(authProvider),
          );
        },
      ),
    );
  }
}
