import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';

class SearchCategoryList extends StatelessWidget {
  final TextEditingController? controller;
  const SearchCategoryList({super.key, this.controller});

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
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () {
                    final categoryName = cat['name'] as String;
                    if (controller != null) {
                      controller!.text = categoryName;
                    }
                    context.read<SearchBloc>().add(SearchQueryChanged(categoryName));
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: cat['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(cat['icon'] as IconData,
                              color: cat['textColor'] as Color, size: 28),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['name'] as String,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
