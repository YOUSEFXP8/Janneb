import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SummaryCard extends StatelessWidget {
  final String status;
  final double latitude;
  final double longitude;
  final String date;

  const SummaryCard({
    super.key,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _RowItem(label: 'Status', value: status),
          const SizedBox(height: 8),
          _RowItem(label: 'Latitude', value: latitude.toString()),
          const SizedBox(height: 8),
          _RowItem(label: 'Longitude', value: longitude.toString()),
          const SizedBox(height: 8),
          _RowItem(label: 'Date', value: date),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;

  const _RowItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
