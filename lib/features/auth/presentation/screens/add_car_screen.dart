import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();
  final _plateController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _colorController = TextEditingController();
  final _regTypeController = TextEditingController();
  final _carTypeController = TextEditingController();
  final _yearController = TextEditingController();
  final _insuranceCompanyController = TextEditingController();
  final _insuranceIdController = TextEditingController();

  @override
  void dispose() {
    _vinController.dispose();
    _plateController.dispose();
    _manufacturerController.dispose();
    _colorController.dispose();
    _regTypeController.dispose();
    _carTypeController.dispose();
    _yearController.dispose();
    _insuranceCompanyController.dispose();
    _insuranceIdController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final nationalId = auth.nationalId;
    if (nationalId == null) return;

    final data = {
      'car_registration_id': const Uuid().v4(),
      'national_id': nationalId,
      'vin_number': _vinController.text.trim(),
      'plate_number': _plateController.text.trim(),
      'manufacturer': _manufacturerController.text.trim(),
      'color': _colorController.text.trim(),
      'registration_type': _regTypeController.text.trim(),
      'car_type': _carTypeController.text.trim(),
      'year': int.tryParse(_yearController.text.trim()),
      'insurance_company': _insuranceCompanyController.text.trim(),
      'insurance_id': _insuranceIdController.text.trim(),
    };

    final success = await auth.addCar(data);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.addVehicle,
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: l10n.vinNumber,
                  hint: l10n.enterVin,
                  controller: _vinController,
                  prefixIcon: Icons.numbers_rounded,
                  validator: (v) => Validators.required(v, l10n.vinNumber),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.plateNumber,
                  hint: l10n.enterPlate,
                  controller: _plateController,
                  prefixIcon: Icons.credit_card_rounded,
                  validator: (v) => Validators.required(v, l10n.plateNumber),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.manufacturer,
                  hint: l10n.manufacturerHint,
                  controller: _manufacturerController,
                  prefixIcon: Icons.factory_rounded,
                  validator: (v) => Validators.required(v, l10n.manufacturer),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.color,
                  hint: l10n.colorHint,
                  controller: _colorController,
                  prefixIcon: Icons.color_lens_rounded,
                  validator: (v) => Validators.required(v, l10n.color),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.registrationType,
                  hint: l10n.registrationTypeHint,
                  controller: _regTypeController,
                  prefixIcon: Icons.description_rounded,
                  validator: (v) => Validators.required(v, l10n.registrationType),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.carType,
                  hint: l10n.carTypeHint,
                  controller: _carTypeController,
                  prefixIcon: Icons.directions_car_rounded,
                  validator: (v) => Validators.required(v, l10n.carType),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.year,
                  hint: l10n.yearHint,
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.calendar_month_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return Validators.required(v, l10n.year);
                    final yr = int.tryParse(v.trim());
                    if (yr == null || yr < 1900 || yr > DateTime.now().year + 1) {
                      return l10n.nationalIdNumeric;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.insuranceCompany,
                  hint: l10n.enterInsuranceCompany,
                  controller: _insuranceCompanyController,
                  prefixIcon: Icons.security_rounded,
                  validator: (v) => Validators.required(v, l10n.insuranceCompany),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: l10n.insuranceId,
                  hint: l10n.enterInsuranceId,
                  controller: _insuranceIdController,
                  prefixIcon: Icons.policy_rounded,
                  validator: (v) => Validators.required(v, l10n.insuranceId),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppConstants.spacingXl),
                PrimaryButton(
                  text: l10n.saveCar,
                  onPressed: isLoading ? null : _saveCar,
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
