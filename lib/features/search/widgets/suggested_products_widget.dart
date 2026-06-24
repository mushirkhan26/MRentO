import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';

class SuggestedProductsWidget extends StatelessWidget {
  final TextEditingController? controller;
  const SuggestedProductsWidget({super.key, this.controller});

  // ✅ Rental equipment suggestions — fashion items hata diye
  static const List<Map<String, String>> _suggestions = [
    {'id': '1', 'name': 'Rotary Drill Machine 750W', 'category': 'Power Tools', 'price': '₹199/din'},
    {'id': '2', 'name': 'Concrete Mixer 140L',       'category': 'Construction', 'price': '₹599/din'},
    {'id': '3', 'name': 'Pressure Washer 1500PSI',   'category': 'Cleaning',     'price': '₹349/din'},
    {'id': '4', 'name': 'Tile Cutter Machine',       'category': 'Construction', 'price': '₹299/din'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aapke liye suggestions',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 16),
          ..._suggestions.map((item) => _buildItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // Instead of broken navigation, update search text (Worker friendly shortcut)
          final productName = item['name']!;
          if (controller != null) {
            controller!.text = productName;
          }
          context.read<SearchBloc>().add(SearchQueryChanged(productName));
        },
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.categoryPowerBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.construction_rounded,
                  color: AppColors.categoryPowerText, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['category']!,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              item['price']!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primaryBlack),
            ),
          ],
        ),
      ),
    );
  }
}
