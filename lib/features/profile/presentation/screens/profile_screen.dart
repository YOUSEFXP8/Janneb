import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/auth/data/services/biometric_service.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  final _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.userProfile == null) auth.fetchProfile();
      if (auth.cars.isEmpty) auth.fetchCars();
    });
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      });
    }
  }

  Future<void> _saveNotificationPref(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _toggleBiometric(bool value) async {
    if (!value) {
      await _biometricService.setBiometricEnabled(false);
      setState(() => _biometricEnabled = false);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final available = await _biometricService.isAvailable();
    if (!available) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication not available on this device'),
        ),
      );
      return;
    }

    final authenticated = await _biometricService.authenticate();
    if (!mounted) return;
    if (authenticated) {
      await _biometricService.setBiometricEnabled(true);
      setState(() => _biometricEnabled = true);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Biometric login enabled'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Authentication failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _confirmDeleteCar(
      BuildContext context, AuthProvider auth, Map<String, dynamic> car) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Vehicle'),
        content: Text(
          'Remove ${car['manufacturer'] ?? ''} ${car['plate_number'] ?? ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final success =
          await auth.deleteCar(car['car_registration_id'] as String);
      if (!success && mounted && auth.error != null) {
        messenger.showSnackBar(
          SnackBar(
              content: Text(auth.error!), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context, AuthProvider auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading && auth.userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingScreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(auth),
                const SizedBox(height: AppConstants.spacingLg),
                _buildPersonalInfoSection(auth),
                const SizedBox(height: AppConstants.spacingLg),
                _buildVehiclesSection(context, auth),
                const SizedBox(height: AppConstants.spacingLg),
                _buildPreferencesSection(),
                const SizedBox(height: AppConstants.spacingLg),
                _buildSecuritySection(),
                const SizedBox(height: AppConstants.spacingLg),
                _buildAccountSection(context, auth),
                const SizedBox(height: AppConstants.spacingXl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AuthProvider auth) {
    final name = auth.userProfile?['name'] as String? ?? '';
    final email = auth.userEmail ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase()
        : (email.isNotEmpty ? email[0].toUpperCase() : 'U');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'No name set',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/profile/edit'),
            icon: const Icon(Icons.edit_rounded,
                color: AppColors.primary, size: 22),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(AuthProvider auth) {
    final profile = auth.userProfile;
    return _SectionCard(
      title: 'Personal Information',
      trailing: GestureDetector(
        onTap: () => context.push('/profile/edit'),
        child: const Text(
          'Edit',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
        ),
      ),
      children: [
        _InfoRow(
          icon: Icons.badge_rounded,
          label: 'National ID',
          value: profile?['national_id'] as String? ?? '—',
        ),
        _InfoRow(
          icon: Icons.phone_rounded,
          label: 'Phone Number',
          value: profile?['phone_number'] as String? ?? '—',
        ),
        _InfoRow(
          icon: Icons.calendar_today_rounded,
          label: 'Date of Birth',
          value: _formatDate(profile?['date_of_birth'] as String?),
        ),
        _InfoRow(
          icon: Icons.wc_rounded,
          label: 'Gender',
          value: profile?['gender'] as String? ?? '—',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildVehiclesSection(BuildContext context, AuthProvider auth) {
    return _SectionCard(
      title: 'My Vehicles',
      trailing: GestureDetector(
        onTap: () => context.push('/cars/add'),
        child: Row(
          children: const [
            Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
            SizedBox(width: 4),
            Text(
              'Add',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
      children: auth.cars.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.directions_car_rounded,
                          size: 36, color: AppColors.textHint),
                      const SizedBox(height: 8),
                      const Text(
                        'No vehicles registered',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          : List.generate(auth.cars.length, (i) {
              final car = auth.cars[i];
              return _CarRow(
                car: car,
                isLast: i == auth.cars.length - 1,
                onDelete: () => _confirmDeleteCar(context, auth, car),
              );
            }),
    );
  }

  Widget _buildPreferencesSection() {
    return _SectionCard(
      title: 'App Preferences',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingSm),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.notifications_rounded,
                    size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Push Notifications',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary),
                    ),
                    Text(
                      'Receive accident report updates',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _notificationsEnabled,
                onChanged: _saveNotificationPref,
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _SectionCard(
      title: 'SECURITY',
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingCard,
            vertical: AppConstants.spacingSm,
          ),
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fingerprint_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          title: const Text(
            'Enable Biometric Login',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: const Text(
            'Use fingerprint or face recognition to sign in faster',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          value: _biometricEnabled,
          onChanged: _toggleBiometric,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context, AuthProvider auth) {
    return _SectionCard(
      title: 'Account',
      children: [
        _ActionRow(
          icon: Icons.logout_rounded,
          label: 'Sign Out',
          iconColor: AppColors.error,
          textColor: AppColors.error,
          isLast: true,
          onTap: () => _confirmSignOut(context, auth),
        ),
      ],
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              ?trailing,
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 6,
                  offset: const Offset(0, 1)),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingCard,
              vertical: AppConstants.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 56, color: AppColors.divider),
      ],
    );
  }
}

class _CarRow extends StatelessWidget {
  final Map<String, dynamic> car;
  final bool isLast;
  final VoidCallback onDelete;

  const _CarRow({
    required this.car,
    required this.onDelete,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingCard,
              vertical: AppConstants.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_car_rounded,
                    size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car['plate_number'] as String? ?? '—',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${car['manufacturer'] ?? ''} · ${car['year'] ?? ''}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded,
                    size: 20, color: AppColors.error),
                tooltip: 'Remove vehicle',
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 56, color: AppColors.divider),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;
  final bool isLast;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingCard,
                vertical: AppConstants.spacingMd),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.textHint),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 56, color: AppColors.divider),
      ],
    );
  }
}
