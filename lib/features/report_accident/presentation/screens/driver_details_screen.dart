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
import '../../../auth/presentation/providers/auth_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillFromProfile();
    });
  }

  void _prefillFromProfile() {
    final auth = context.read<AuthProvider>();
    final report = context.read<ReportProvider>();

    if (report.fullName.isNotEmpty) {
      _nameController.text = report.fullName;
      _phoneController.text = report.phoneNumber;
      _plateController.text = report.vehiclePlateNumber;
      _insuranceController.text = report.insuranceCompany;
      _descriptionController.text = report.accidentDescription;
      setState(() {});
      return;
    }

    final profile = auth.userProfile;
    if (profile != null) {
      _nameController.text = (profile['name'] as String? ?? '');
      _phoneController.text = (profile['phone_number'] as String? ?? '');
    }

    if (auth.cars.isNotEmpty && report.selectedCar == null) {
      report.selectCar(auth.cars.first);
    }

    _applyCarToFields(report.selectedCar);

    if (auth.cars.isEmpty) {
      auth.fetchCars().then((_) {
        if (!mounted) return;
        final updatedReport = context.read<ReportProvider>();
        final updatedAuth = context.read<AuthProvider>();
        if (updatedAuth.cars.isNotEmpty && updatedReport.selectedCar == null) {
          updatedReport.selectCar(updatedAuth.cars.first);
          _applyCarToFields(updatedAuth.cars.first);
          setState(() {});
        }
      });
    }
  }

  void _applyCarToFields(Map<String, dynamic>? car) {
    if (car == null) return;
    _plateController.text = car['plate_number'] as String? ?? '';
    _insuranceController.text = car['insurance_company'] as String? ?? '';
  }

  void _showCarPicker() {
    final auth = context.read<AuthProvider>();
    final report = context.read<ReportProvider>();
    final l10n = AppLocalizations.of(context);

    if (auth.cars.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noVehiclesForAccident)));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectYourVehicle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...auth.cars.map((car) {
                  final isSelected =
                      car['car_registration_id'] ==
                      report.selectedCar?['car_registration_id'];
                  return _CarPickerTile(
                    car: car,
                    isSelected: isSelected,
                    onTap: () {
                      report.selectCar(car);
                      _applyCarToFields(car);
                      setState(() {});
                      Navigator.pop(sheetContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
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
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _plateController.dispose();
    _insuranceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final report = context.watch<ReportProvider>();
    final nationalId = auth.nationalId ?? '—';
    final selectedCar = report.selectedCar;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.driverDetails),
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
                      Text(
                        l10n.confirmInfoDesc,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      _SectionHeader(label: l10n.yourInformation),
                      const SizedBox(height: AppConstants.spacingMd),

                      _InfoRow(
                        icon: Icons.badge_rounded,
                        label: l10n.nationalId,
                        value: nationalId,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      CustomTextField(
                        label: l10n.fullName,
                        hint: l10n.enterFullName,
                        controller: _nameController,
                        prefixIcon: Icons.person_rounded,
                        validator: Validators.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      CustomTextField(
                        label: l10n.phoneNumber,
                        hint: '+962 7XX XXX XXX',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_rounded,
                        validator: Validators.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      _SectionHeader(label: l10n.yourVehicle),
                      const SizedBox(height: AppConstants.spacingMd),

                      GestureDetector(
                        onTap: _showCarPicker,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.directions_car_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  selectedCar != null
                                      ? '${selectedCar['manufacturer'] ?? ''} — ${selectedCar['plate_number'] ?? ''}'
                                      : auth.isLoading
                                      ? l10n.loadingVehicles
                                      : l10n.selectVehicleHint,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: selectedCar != null
                                        ? AppColors.textPrimary
                                        : AppColors.textHint,
                                    fontWeight: selectedCar != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (selectedCar != null) ...[
                        const SizedBox(height: AppConstants.spacingMd),
                        _CarDetailsCard(car: selectedCar, l10n: l10n),
                      ],

                      const SizedBox(height: AppConstants.spacingMd),

                      CustomTextField(
                        label: l10n.plateNumber,
                        hint: l10n.enterPlate,
                        controller: _plateController,
                        prefixIcon: Icons.pin_rounded,
                        validator: (v) =>
                            Validators.required(v, l10n.plateNumber),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      CustomTextField(
                        label: l10n.insuranceCompany,
                        hint: l10n.enterInsuranceCompany,
                        controller: _insuranceController,
                        prefixIcon: Icons.shield_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      CustomTextField(
                        label: l10n.accidentDescription,
                        hint: context.read<LocaleProvider>().isArabic
                            ? 'صِف ما حدث…'
                            : 'Describe what happened…',
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

            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: PrimaryButton(
                text: l10n.continueText,
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.accent),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarDetailsCard extends StatelessWidget {
  const _CarDetailsCard({required this.car, required this.l10n});
  final Map<String, dynamic> car;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = <({String label, String? value})>[
      (label: l10n.make, value: car['manufacturer'] as String?),
      (label: l10n.type, value: car['car_type'] as String?),
      (label: l10n.color, value: car['color'] as String?),
      (label: l10n.year, value: car['year']?.toString()),
      (label: l10n.insuranceId, value: car['insurance_id'] as String?),
    ].where((e) => e.value != null && e.value!.isNotEmpty).toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingCard),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.accent),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 8,
        children: items
            .map(
              (e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e.label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    e.value!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CarPickerTile extends StatelessWidget {
  const _CarPickerTile({
    required this.car,
    required this.isSelected,
    required this.onTap,
  });

  final Map<String, dynamic> car;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.directions_car_rounded,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car['manufacturer'] ?? 'Unknown'} ${car['car_type'] ?? ''}'
                        .trim(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${car['plate_number'] ?? ''} · ${car['color'] ?? ''} · ${car['year'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
