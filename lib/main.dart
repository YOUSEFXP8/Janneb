import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/report_accident/presentation/providers/report_provider.dart';

void main() {
  runApp(const CrashAssistApp());
}

class CrashAssistApp extends StatelessWidget {
  const CrashAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportProvider(),
      child: MaterialApp.router(
        title: 'CrashAssist',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
