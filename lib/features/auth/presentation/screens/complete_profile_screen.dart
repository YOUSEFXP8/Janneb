import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _gender;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations(context.read<LocaleProvider>().isArabic);
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectDateOfBirthMsg)),
      );
      return;
    }
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectGenderMsg)),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final dob =
        '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}';

    final success = await auth.saveProfile(
      nationalId: _nationalIdController.text.trim(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      dob: dob,
      gender: _gender!,
    );

    if (!mounted) return;
    if (success) {
      context.go('/cars');
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!), backgroundColor: AppColors.error),
      );
    }
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
                const SizedBox(height: AppConstants.spacingLg),
                Text(
                  l10n.completeProfile,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  l10n.tellUsAboutYourself,
                  style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppConstants.spacingXl),
                CustomTextField(
                  label: l10n.nationalId,
                  hint: l10n.enterNationalId,
                  controller: _nationalIdController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.badge_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.nationalIdRequired;
                    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return l10n.nationalIdNumeric;
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.fullName,
                  hint: l10n.enterFullName,
                  controller: _nameController,
                  prefixIcon: Icons.person_rounded,
                  validator: (v) => v == null || v.trim().isEmpty ? l10n.nationalIdRequired.replaceFirst('ID', l10n.fullName) : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.phoneNumber,
                  hint: '+962 7XX XXX XXX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_rounded,
                  validator: (v) => v == null || v.trim().isEmpty ? l10n.nationalIdRequired.replaceFirst('ID', l10n.phoneNumber) : null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      label: l10n.dateOfBirth,
                      hint: l10n.selectDateOfBirth,
                      controller: TextEditingController(
                        text: _dateOfBirth == null
                            ? ''
                            : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                      ),
                      prefixIcon: Icons.calendar_today_rounded,
                      validator: (v) => _dateOfBirth == null ? l10n.dateOfBirthRequired : null,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: InputDecoration(
                    labelText: l10n.gender,
                    prefixIcon: const Icon(Icons.wc_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'male', child: Text(l10n.male)),
                    DropdownMenuItem(value: 'female', child: Text(l10n.female)),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                  validator: (v) => v == null ? l10n.selectGenderMsg : null,
                ),
                const SizedBox(height: AppConstants.spacingXl),
                PrimaryButton(
                  text: l10n.continueBtn,
                  onPressed: isLoading ? null : _saveProfile,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
