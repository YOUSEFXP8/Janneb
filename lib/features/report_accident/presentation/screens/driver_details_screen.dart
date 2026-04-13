import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../providers/report_provider.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _plateController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Restore saved data if available
    final provider = context.read<ReportProvider>();
    if (provider.fullName.isNotEmpty) {
      _nameController.text = provider.fullName;
      _phoneController.text = provider.phoneNumber;
      _plateController.text = provider.vehiclePlateNumber;
      _insuranceController.text = provider.insuranceCompany;
      _descriptionController.text = provider.accidentDescription;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _plateController.dispose();
    _insuranceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      context.read<ReportProvider>().setDriverDetails(
            fullName: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            vehiclePlateNumber: _plateController.text.trim(),
            insuranceCompany: _insuranceController.text.trim(),
            accidentDescription: _descriptionController.text.trim(),
          );
      context.push('/report/review');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.driverDetails),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingScreen),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.driverDetailsSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Full Name
                      CustomTextField(
                        label: AppStrings.fullName,
                        hint: 'Enter full name',
                        controller: _nameController,
                        prefixIcon: Icons.person_rounded,
                        validator: Validators.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Phone Number
                      CustomTextField(
                        label: AppStrings.phoneNumber,
                        hint: '+962 7XX XXX XXX',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_rounded,
                        validator: Validators.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Vehicle Plate Number
                      CustomTextField(
                        label: AppStrings.vehiclePlateNumber,
                        hint: 'Enter plate number',
                        controller: _plateController,
                        prefixIcon: Icons.directions_car_rounded,
                        validator: (value) =>
                            Validators.required(value, 'Plate number'),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Insurance Company
                      CustomTextField(
                        label: AppStrings.insuranceCompany,
                        hint: 'Enter insurance company',
                        controller: _insuranceController,
                        prefixIcon: Icons.shield_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Accident Description
                      CustomTextField(
                        label: AppStrings.accidentDescription,
                        hint: 'Describe what happened...',
                        controller: _descriptionController,
                        maxLines: 4,
                        prefixIcon: Icons.edit_note_rounded,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: PrimaryButton(
                text: AppStrings.continueText,
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
