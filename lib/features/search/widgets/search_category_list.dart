import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class SearchCategoryList extends StatelessWidget {
  const SearchCategoryList({super.key});

  // ✅ Hardware categories — fashion categories hata di
  static const List<Map<String, dynamic>> _categories = [
    {'name': 'Power Tools',  'icon': Icons.construction_rounded,  'color': AppColors.categoryPowerBg,       'textColor': AppColors.categoryPowerText},
    {'name': 'Construction', 'icon': Icons.foundation_outlined,    'color': AppColors.categoryConstructionBg, 'textColor': AppColors.categoryConstructionText},
    {'name': 'Lifting',      'icon': Icons.forklift,               'color': AppColors.categoryLiftingBg,     'textColor': AppColors.categoryLiftingText},
    {'name': 'Cleaning',     'icon': Icons.cleaning_services_outlined, 'color': AppColors.categoryCleaningBg,'textColor': AppColors.categoryCleaningText},
    {'name': 'Measurement',  'icon': Icons.straighten_outlined,    'color': AppColors.categoryMeasurementBg, 'textColor': AppColors.categoryMeasurementText},
    {'name': 'Gardening',    'icon': Icons.yard_outlined,          'color': Color(0xFFE8F5E9),               'textColor': Color(0xFF2E7D32)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            'Category se dhundho',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87),
          ),
        ),
        SizedBox(
          height: 92,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: cat['color'] as Color,
                      child: Icon(cat['icon'] as IconData,
                          color: cat['textColor'] as Color, size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['name'] as String,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}