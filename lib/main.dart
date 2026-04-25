import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/locale_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/report_accident/presentation/providers/report_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://buyflcxseboygugyemmt.supabase.co',
    anonKey: 'sb_publishable_HcNTHRXTB3BQCPgr9oIarQ_LiR-VMxK',
  );
  final localeProvider = LocaleProvider();
  await localeProvider.loadFromPrefs();
  runApp(JannebApp(localeProvider: localeProvider));
}

class JannebApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  const JannebApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, locale, _) {
          final authProvider = context.read<AuthProvider>();
          return MaterialApp.router(
            title: 'Janneb',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: locale.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.createRouter(authProvider),
          );
        },
      ),
    );
  }
}
