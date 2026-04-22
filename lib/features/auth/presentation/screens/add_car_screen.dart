import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
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
      context.pop();
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthProvider, bool>((a) => a.isLoading);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add Vehicle',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
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
                  label: 'VIN Number',
                  hint: 'Enter vehicle identification number',
                  controller: _vinController,
                  prefixIcon: Icons.numbers_rounded,
                  validator: (v) => Validators.required(v, 'VIN number'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Plate Number',
                  hint: 'Enter plate number',
                  controller: _plateController,
                  prefixIcon: Icons.credit_card_rounded,
                  validator: (v) => Validators.required(v, 'Plate number'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Manufacturer',
                  hint: 'e.g. Toyota, Honda',
                  controller: _manufacturerController,
                  prefixIcon: Icons.factory_rounded,
                  validator: (v) => Validators.required(v, 'Manufacturer'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Color',
                  hint: 'e.g. White, Black',
                  controller: _colorController,
                  prefixIcon: Icons.color_lens_rounded,
                  validator: (v) => Validators.required(v, 'Color'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Registration Type',
                  hint: 'e.g. Private, Commercial',
                  controller: _regTypeController,
                  prefixIcon: Icons.description_rounded,
                  validator: (v) => Validators.required(v, 'Registration type'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Car Type',
                  hint: 'e.g. Sedan, SUV, Truck',
                  controller: _carTypeController,
                  prefixIcon: Icons.directions_car_rounded,
                  validator: (v) => Validators.required(v, 'Car type'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Year',
                  hint: 'e.g. 2022',
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.calendar_month_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Year is required';
                    final year = int.tryParse(v.trim());
                    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Insurance Company',
                  hint: 'Enter insurance company name',
                  controller: _insuranceCompanyController,
                  prefixIcon: Icons.security_rounded,
                  validator: (v) => Validators.required(v, 'Insurance company'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                CustomTextField(
                  label: 'Insurance ID',
                  hint: 'Enter insurance policy number',
                  controller: _insuranceIdController,
                  prefixIcon: Icons.policy_rounded,
                  validator: (v) => Validators.required(v, 'Insurance ID'),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppConstants.spacingXl),
                PrimaryButton(
                  text: 'Save Car',
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
