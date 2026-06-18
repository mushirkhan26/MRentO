import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

/// Duration option model
class RentalDurationOption {
  final String label;     // "1 Din", "3 Din", "1 Hafta"
  final int days;         // 1, 3, 7
  final double price;     // total price for this duration

  const RentalDurationOption({
    required this.label,
    required this.days,
    required this.price,
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
        const Text(
          'Rental Duration',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((option) {
            final bool isSelected = selected?.label == option.label;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(option),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryYellow.withValues(alpha: 0.15)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryYellow
                          : AppColors.greyOutline,
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
                              : AppColors.grey707070,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${option.price.toInt()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.primaryBlack
                              : AppColors.grey707070,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selected != null) ...[
          const SizedBox(height: 10),
          Text(
            'Selected: ${selected!.label} @ ₹${selected!.price.toInt()}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey707070,
            ),
          ),
        ],
      ],
    );
  }
}