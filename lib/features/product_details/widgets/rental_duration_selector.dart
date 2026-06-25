import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

/// Duration option model
class RentalDurationOption {
  final String label;     // "1 Din", "3 Din", "1 Hafta"
  final int days;         // 1, 3, 7
  final double price;     // total price for this duration
  final int savings;      // percentage savings

  const RentalDurationOption({
    required this.label,
    required this.days,
    required this.price,
    this.savings = 0,
  });
}

class RentalDurationSelector extends StatelessWidget {
  final List<RentalDurationOption> options;
  final RentalDurationOption? selected;
  final ValueChanged<RentalDurationOption> onSelected;

  const RentalDurationSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Duration',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (selected != null && selected!.savings > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Save ${selected!.savings}%',
                  style: const TextStyle(
                    color: AppColors.successColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: options.map((option) {
            final bool isSelected = selected?.label == option.label;
            final double perDayPrice = option.price / option.days;

            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryYellow.withValues(alpha: 0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryYellow
                          : AppColors.grey200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isSelected
                              ? AppColors.primaryBlack
                              : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${option.price.toInt()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: isSelected
                              ? AppColors.primaryBlack
                              : AppColors.primaryBlack,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${perDayPrice.toInt()}/day',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
