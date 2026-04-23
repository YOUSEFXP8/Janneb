import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/report_provider.dart';

class QrSessionScreen extends StatefulWidget {
  const QrSessionScreen({super.key});

  @override
  State<QrSessionScreen> createState() => _QrSessionScreenState();
}

class _QrSessionScreenState extends State<QrSessionScreen> {
  final _joinCodeController = TextEditingController();
  final _joinFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitManualJoin(
    BuildContext context,
    AuthProvider auth,
    ReportProvider provider,
  ) async {
    if (!(_joinFormKey.currentState?.validate() ?? false)) return;

    // Use the first registered car, or empty string if none.
    final carId = auth.cars.isNotEmpty
        ? (auth.cars.first['car_registration_id'] as String? ?? '')
        : '';

    try {
      await provider.joinAccident(
        joinCode: _joinCodeController.text.trim(),
        nationalId: auth.nationalId ?? '',
        carRegistrationId: carId,
      );
      if (context.mounted) context.push('/report/capture-evidence');
    } on PostgrestException catch (e) {
      if (!context.mounted) return;
      final lower = e.message.toLowerCase();
      final msg = lower.contains('invalid')
          ? 'Invalid join code'
          : lower.contains('already')
              ? 'You are already linked to this accident'
              : 'Failed to join session';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join session')),
        );
      }
    }
  }

  Widget _buildOrDivider() {
    return Row(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
                    'Create a new session code to share with the other party, or scan/enter their code to join.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  if (provider.sessionId != null) ...[
                    // ── SESSION CREATED VIEW ──────────────────────────────
                    Center(
                      child: QrImageView(
                        data: provider.sessionId!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Plain-text code for manual sharing
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Join Code',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                provider.sessionId!,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                  letterSpacing: 6,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded,
                                color: AppColors.primary),
                            tooltip: 'Copy code',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: provider.sessionId!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Code copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    const Text(
                      'Share this QR code or the join code with the other driver.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
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
                    // ── DEFAULT STATE ─────────────────────────────────────
                    if (provider.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      PrimaryButton(
                        text: 'Create Session',
                        onPressed: () async {
                          try {
                            await provider.createSession();
                          } catch (_) {
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
                      _buildOrDivider(),
                      const SizedBox(height: AppConstants.spacingLg),

                      // ── JOIN SECTION ──────────────────────────────────
                      Container(
                        padding:
                            const EdgeInsets.all(AppConstants.paddingCard),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Form(
                          key: _joinFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Join an Accident Session',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingMd),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize:
                                      const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () =>
                                    context.push('/report/qr-scanner'),
                                icon: const Icon(
                                    Icons.qr_code_scanner_rounded),
                                label: const Text('Scan QR Code'),
                              ),
                              const SizedBox(height: AppConstants.spacingMd),
                              _buildOrDivider(),
                              const SizedBox(height: AppConstants.spacingMd),
                              TextFormField(
                                controller: _joinCodeController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Enter join code',
                                  hintText: 'e.g. 847291',
                                  prefixIcon:
                                      const Icon(Icons.pin_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Please enter a join code'
                                        : null,
                              ),
                              const SizedBox(height: AppConstants.spacingLg),
                              PrimaryButton(
                                text: 'Join Session',
                                onPressed: provider.isLoading
                                    ? null
                                    : () => _submitManualJoin(
                                          context,
                                          auth,
                                          provider,
                                        ),
                              ),
                            ],
                          ),
                        ),
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
