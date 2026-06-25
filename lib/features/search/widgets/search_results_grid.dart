import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../config/theme/app_colors.dart';
import '../../../features/home/widgets/product_card.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import 'search_category_list.dart';
import 'trending_now_widget.dart';

class SearchResultsGrid extends StatelessWidget {
  final SearchLoaded state;
  final TextEditingController controller;

  const SearchResultsGrid({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (state.results.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Lottie.asset(
              'assets/lottie/notFound.json',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              'Koi machine nahi mili',
              style: TextStyle(
                color: AppColors.primaryBlack,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kripya kuch aur search karein',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                controller.clear();
                context
                    .read<SearchBloc>()
                    .add(const SearchQueryChanged(''));
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryYellow.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Search clear karo',
                style: TextStyle(
                    color: AppColors.primaryDarkYellow,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 48),
            const Divider(thickness: 1, color: Color(0xFFF5F5F5)),
            const SizedBox(height: 24),
            SearchCategoryList(controller: controller),
            const SizedBox(height: 32),
            TrendingNowWidget(controller: controller),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final product = state.results[index]; // ← RentalProductModel
        return ProductCard(product: product);
      },
    );
  }
}
