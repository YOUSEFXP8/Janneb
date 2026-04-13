import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double dotSize;
  final double spacing;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.dotSize = 10,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? dotSize * 2.5 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.accent,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      }),
    );
  }
}
