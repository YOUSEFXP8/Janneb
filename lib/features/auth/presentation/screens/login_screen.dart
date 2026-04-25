import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../../data/services/biometric_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _biometricService = BiometricService();
  bool _obscurePassword = true;
  bool _canUseBiometrics = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final isEnabled = await _biometricService.isBiometricEnabled();
    final isAvailable = await _biometricService.isAvailable();
    final credentials = await _biometricService.getCredentials();
    if (mounted) {
      setState(() {
        _canUseBiometrics = isEnabled && isAvailable && credentials != null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setError(String? error, bool isAr) {
    if (error == null) return;
    final l10n = AppLocalizations(isAr);
    final lower = error.toLowerCase();
    final msg = lower.contains('invalid') || lower.contains('credentials')
        ? l10n.incorrectCredentials
        : lower.contains('not found') || lower.contains('no user')
            ? l10n.noAccountFound
            : lower.contains('network') || lower.contains('connection')
                ? l10n.connectionError
                : error;
    setState(() => _errorMessage = msg);
  }

  Future<void> _login() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    final isAr = context.read<LocaleProvider>().isArabic;
    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    if (!success && auth.error != null) _setError(auth.error, isAr);
  }

  Future<void> _biometricLogin() async {
    setState(() => _errorMessage = null);
    final isAr = context.read<LocaleProvider>().isArabic;
    final authenticated = await _biometricService.authenticate();
    if (!mounted || !authenticated) return;

    final credentials = await _biometricService.getCredentials();
    if (credentials == null) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(
      credentials['email']!,
      credentials['password']!,
    );
    if (!mounted) return;
    if (!success && auth.error != null) _setError(auth.error, isAr);
  }

  Widget _buildErrorBanner() {
    return AnimatedSize(
      duration: AppConstants.animationFast,
      child: _errorMessage == null
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _errorMessage = null),
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.error, size: 18),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = context.select<AuthProvider, bool>((a) => a.isLoading);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingXl),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Center(
                  child: Text(
                    l10n.welcomeBack,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Center(
                  child: Text(
                    l10n.signInToAccount,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl + 8),
                _buildErrorBanner(),
                CustomTextField(
                  label: l10n.email,
                  hint: l10n.enterEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_rounded,
                  validator: Validators.email,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.password,
                  hint: l10n.enterPassword,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_rounded,
                  validator: Validators.password,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                PrimaryButton(
                  text: l10n.login,
                  onPressed: isLoading ? null : _login,
                  isLoading: isLoading,
                ),
                if (_canUseBiometrics) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.fingerprint_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      onPressed: isLoading ? null : _biometricLogin,
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.spacingMd),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/signup'),
                        child: Text(
                          l10n.signUp,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
