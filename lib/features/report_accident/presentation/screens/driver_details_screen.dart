import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
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

  String? _selectedAccidentType;
  String? _selectedWeather;
  bool _injuriesReported = false;

  static const _accidentTypes = [
    'Minor Collision',
    'Rear-end Accident',
    'Side Collision',
    'Parking Accident',
    'Other',
  ];

  static const _weatherConditions = [
    'Clear',
    'Rainy',
    'Foggy',
    'Icy',
    'Other',
  ];

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

    // Auto-fill from saved report state first (user already submitted form once)
    if (report.fullName.isNotEmpty) {
      _nameController.text = report.fullName;
      _phoneController.text = report.phoneNumber;
      _plateController.text = report.vehiclePlateNumber;
      _insuranceController.text = report.insuranceCompany;
      _descriptionController.text = report.accidentDescription;
      setState(() {
        _selectedAccidentType =
            report.accidentType.isEmpty ? null : report.accidentType;
        _selectedWeather =
            report.weatherCondition.isEmpty ? null : report.weatherCondition;
        _injuriesReported = report.injuriesReported;
      });
      return;
    }

    // Otherwise auto-fill from user profile
    final profile = auth.userProfile;
    if (profile != null) {
      _nameController.text = (profile['name'] as String? ?? '');
      _phoneController.text = (profile['phone_number'] as String? ?? '');
    }

    // If user has cars and none selected yet, pre-select the first one
    if (auth.cars.isNotEmpty && report.selectedCar == null) {
      report.selectCar(auth.cars.first);
    }

    // Auto-fill from selected car
    _applyCarToFields(report.selectedCar);

    // Fetch cars if not loaded yet
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

    if (auth.cars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No vehicles registered. Add a vehicle in your profile.'),
        ),
      );
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
                const Text(
                  'Select Your Vehicle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      if (_selectedAccidentType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an accident type')),
        );
        return;
      }
      context.read<ReportProvider>().setDriverDetails(
            fullName: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            vehiclePlateNumber: _plateController.text.trim(),
            insuranceCompany: _insuranceController.text.trim(),
            accidentDescription: _descriptionController.text.trim(),
            accidentType: _selectedAccidentType!,
            weatherCondition: _selectedWeather ?? 'Not specified',
            injuriesReported: _injuriesReported,
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
                        'Confirm your information and vehicle details',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // ── YOUR INFORMATION ─────────────────────────────
                      _SectionHeader(label: 'Your Information'),
                      const SizedBox(height: AppConstants.spacingMd),

                      // National ID (read-only info chip)
                      _InfoRow(
                        icon: Icons.badge_rounded,
                        label: 'National ID',
                        value: nationalId,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      CustomTextField(
                        label: AppStrings.fullName,
                        hint: 'Enter full name',
                        controller: _nameController,
                        prefixIcon: Icons.person_rounded,
                        validator: Validators.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      CustomTextField(
                        label: AppStrings.phoneNumber,
                        hint: '+962 7XX XXX XXX',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_rounded,
                        validator: Validators.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // ── YOUR VEHICLE ──────────────────────────────────
                      _SectionHeader(label: 'Your Vehicle'),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Car selector button
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
                                          ? 'Loading vehicles…'
                                          : 'Select your vehicle',
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

                      // Selected car details card
                      if (selectedCar != null) ...[
                        const SizedBox(height: AppConstants.spacingMd),
                        _CarDetailsCard(car: selectedCar),
                      ],

                      const SizedBox(height: AppConstants.spacingMd),

                      // Plate number (auto-filled but editable)
                      CustomTextField(
                        label: AppStrings.vehiclePlateNumber,
                        hint: 'Enter plate number',
                        controller: _plateController,
                        prefixIcon: Icons.pin_rounded,
                        validator: (v) => Validators.required(v, 'Plate number'),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Insurance (auto-filled but editable)
                      CustomTextField(
                        label: AppStrings.insuranceCompany,
                        hint: 'Enter insurance company',
                        controller: _insuranceController,
                        prefixIcon: Icons.shield_rounded,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // ── ACCIDENT DETAILS ──────────────────────────────
                      _SectionHeader(label: 'Accident Details'),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Accident Type dropdown
                      _DropdownField(
                        label: 'Accident Type',
                        hint: 'Select accident type',
                        icon: Icons.car_crash_rounded,
                        value: _selectedAccidentType,
                        items: _accidentTypes,
                        onChanged: (v) =>
                            setState(() => _selectedAccidentType = v),
                        required: true,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Weather Conditions dropdown
                      _DropdownField(
                        label: 'Weather Conditions',
                        hint: 'Select weather at time of accident',
                        icon: Icons.wb_sunny_rounded,
                        value: _selectedWeather,
                        items: _weatherConditions,
                        onChanged: (v) => setState(() => _selectedWeather = v),
                        required: false,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Injuries Reported toggle
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
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
                              Icons.personal_injury_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Injuries Reported',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Switch(
                              value: _injuriesReported,
                              activeThumbColor: AppColors.primary,
                              onChanged: (v) =>
                                  setState(() => _injuriesReported = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Accident Description
                      CustomTextField(
                        label: AppStrings.accidentDescription,
                        hint: 'Describe what happened…',
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

// ── Section header ────────────────────────────────────────────────────────────

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

// ── Read-only info row ────────────────────────────────────────────────────────

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

// ── Car details card (auto-filled info) ──────────────────────────────────────

class _CarDetailsCard extends StatelessWidget {
  const _CarDetailsCard({required this.car});
  final Map<String, dynamic> car;

  @override
  Widget build(BuildContext context) {
    final items = <({String label, String? value})>[
      (label: 'Make', value: car['manufacturer'] as String?),
      (label: 'Type', value: car['car_type'] as String?),
      (label: 'Color', value: car['color'] as String?),
      (label: 'Year', value: car['year']?.toString()),
      (label: 'Insurance ID', value: car['insurance_id'] as String?),
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

// ── Dropdown field ─────────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.required,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          key: ValueKey(value),
          initialValue: value,
          hint: Text(hint, style: const TextStyle(color: AppColors.textHint)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadius),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          validator: required
              ? (v) => v == null ? '$label is required' : null
              : null,
        ),
      ],
    );
  }
}

// ── Car picker tile (bottom sheet) ────────────────────────────────────────────

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
