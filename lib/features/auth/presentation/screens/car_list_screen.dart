import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../common/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingLg),
              const Text(
                'Your Vehicles',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              const Text(
                'Register at least one vehicle to continue',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.spacingXl),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    if (auth.isLoading && auth.cars.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (auth.cars.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_car_rounded,
                                size: 64, color: AppColors.textHint),
                            const SizedBox(height: AppConstants.spacingMd),
                            const Text(
                              'No vehicles added yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: auth.cars.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppConstants.spacingMd),
                      itemBuilder: (context, index) {
                        final car = auth.cars[index];
                        return Container(
                          padding: const EdgeInsets.all(AppConstants.paddingCard),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusLg),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.accentLight,
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius),
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car['plate_number'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${car['manufacturer'] ?? ''} · ${car['year'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              OutlinedButton.icon(
                onPressed: () => context.push('/cars/add'),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Car'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => PrimaryButton(
                  text: 'Finish Setup',
                  onPressed: auth.cars.isEmpty ? null : () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
