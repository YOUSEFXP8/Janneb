import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../common/widgets/primary_button.dart';
import '../providers/report_provider.dart';

class QrSessionScreen extends StatelessWidget {
  const QrSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, provider, _) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) provider.resetSession();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                provider.resetSession();
                context.pop();
              },
            ),
            title: const Text('Accident Session'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create a new session code to share with the other party, or scan their code to join.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  if (provider.sessionId != null) ...[
                    // QR DISPLAY
                    Center(
                      child: QrImageView(
                        data: provider.sessionId!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXl),
                    const Text(
                      'Session Created! Share this QR code with the other driver.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    PrimaryButton(
                      text: 'Continue to Evidence',
                      onPressed: () {
                        context.push('/report/capture-evidence');
                      },
                    ),
                  ] else ...[
                    // DEFAULT STATE
                    if (provider.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      PrimaryButton(
                        text: 'Create Session',
                        onPressed: () async {
                          try {
                            await provider.createSession();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to create session'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMd,
                            ),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.push('/report/qr-scanner');
                        },
                        child: const Text('Scan QR Code'),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
