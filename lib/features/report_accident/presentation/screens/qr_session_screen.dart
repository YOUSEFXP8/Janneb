import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
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

  bool _isCreatingSession = false;

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  Future<void> _createSession(
    BuildContext context,
    AuthProvider auth,
    ReportProvider provider,
  ) async {
    setState(() {
      _isCreatingSession = true;
    });

    try {
      final isAr = context.read<LocaleProvider>().isArabic;
      final l10n = AppLocalizations(isAr);

      if (auth.cars.isEmpty) {
        await auth.fetchCars();
        if (auth.cars.isEmpty) {
          if (!context.mounted) return;
          final errorMsg = auth.error != null 
              ? 'Error loading vehicles: ${auth.error}'
              : l10n.noVehiclesForAccident;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
          return;
        }
      }

      double lat = 0.0;
      double lng = 0.0;
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 10),
            ),
          );
          lat = pos.latitude;
          lng = pos.longitude;
        }
      } catch (_) {
        // Fall back to 0,0 if GPS is unavailable.
      }

      if (!context.mounted) return;

      try {
        await provider.createSession(
          nationalId: auth.nationalId ?? '',
          carRegistrationId:
              auth.cars.first['car_registration_id'] as String? ?? '',
          lat: lat,
          lng: lng,
        );
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations(isAr).failedToCreate)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingSession = false;
        });
      }
    }
  }

  void _submitManualJoin(BuildContext context, ReportProvider provider) {
    if (!(_joinFormKey.currentState?.validate() ?? false)) return;
    provider.joinAccident(joinCode: _joinCodeController.text.trim());
    context.push('/report/capture-evidence');
  }

  Widget _buildOrDivider(AppLocalizations l10n) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
          child: Text(
            l10n.or,
            style: const TextStyle(
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
    final l10n = AppLocalizations.of(context);
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
            title: Text(l10n.accidentSession),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.createSessionDesc,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  // ── Creator path ──────────────────────────────────────────
                  if (provider.sessionId != null && !provider.isJoiningSession) ...[
                    Center(
                      child: QrImageView(
                        data: provider.sessionId!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
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
                              Text(
                                l10n.joinCode,
                                style: const TextStyle(
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
                            tooltip: l10n.copyCode,
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: provider.sessionId!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.codeCopied),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      l10n.shareQrDesc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    PrimaryButton(
                      text: l10n.continueToEvidence,
                      onPressed: () => context.push('/report/capture-evidence'),
                    ),
                  ] else ...[
                    if (provider.isLoading || _isCreatingSession)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      PrimaryButton(
                        text: l10n.createSession,
                        onPressed: () =>
                            _createSession(context, auth, provider),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      _buildOrDivider(l10n),
                      const SizedBox(height: AppConstants.spacingLg),

                      // ── Joiner path ────────────────────────────────────────
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
                              Text(
                                l10n.joinAccidentSession,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingMd),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () =>
                                    context.push('/report/qr-scanner'),
                                icon: const Icon(Icons.qr_code_scanner_rounded),
                                label: Text(l10n.scanQrCode),
                              ),
                              const SizedBox(height: AppConstants.spacingMd),
                              _buildOrDivider(l10n),
                              const SizedBox(height: AppConstants.spacingMd),
                              TextFormField(
                                controller: _joinCodeController,
                                decoration: InputDecoration(
                                  labelText: l10n.enterJoinCode,
                                  hintText: l10n.joinCodeHint,
                                  prefixIcon: const Icon(Icons.pin_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? l10n.enterJoinCodeValidation
                                        : null,
                              ),
                              const SizedBox(height: AppConstants.spacingLg),
                              PrimaryButton(
                                text: l10n.joinSession,
                                onPressed: () =>
                                    _submitManualJoin(context, provider),
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
