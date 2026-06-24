import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoaded) return const SizedBox.shrink();

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _filterChip(
                context,
                'Sort',
                isSelected: state.sortBy != null,
                onTap: () => _showSortBottomSheet(context, state),
              ),
              _filterChip(
                context,
                'Price Range',
                isSelected: state.minPrice != null || state.maxPrice != null,
                onTap: () => _showPriceBottomSheet(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(BuildContext context, String label,
      {bool isSelected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap?.call(),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryYellow.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primaryYellow : Colors.grey.shade300,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 12,
          color: isSelected ? AppColors.primaryBlack : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, SearchLoaded state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text('Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Price: Low to High'),
            onTap: () {
              context.read<SearchBloc>().add(ApplyFilters(
                    sortBy: 'price_low_high',
                    minPrice: state.minPrice,
                    maxPrice: state.maxPrice,
                  ));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Price: High to Low'),
            onTap: () {
              context.read<SearchBloc>().add(ApplyFilters(
                    sortBy: 'price_high_low',
                    minPrice: state.minPrice,
                    maxPrice: state.maxPrice,
                  ));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showPriceBottomSheet(BuildContext context, SearchLoaded state) {
    double min = state.minPrice ?? 0;
    double max = state.maxPrice ?? 5000;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Price Range (per day)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              RangeSlider(
                values: RangeValues(min, max),
                min: 0,
                max: 5000,
                divisions: 50,
                activeColor: AppColors.primaryYellow,
                labels: RangeLabels('₹${min.toInt()}', '₹${max.toInt()}'),
                onChanged: (values) {
                  setModalState(() {
                    min = values.start;
                    max = values.end;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SearchBloc>().add(ApplyFilters(
                          minPrice: min,
                          maxPrice: max,
                          sortBy: state.sortBy,
                        ));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Apply Filter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
