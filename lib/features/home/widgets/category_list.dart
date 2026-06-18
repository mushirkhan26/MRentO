import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _selectedIndex = 0;

  // Fallback icons — category name se match karo
  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'women': return Icons.woman;
      case 'men': return Icons.man;
      case 'kids': return Icons.child_care;
      case 'beauty': return Icons.brush_outlined;
      case 'electronics': return Icons.laptop_mac_outlined;
      case 'home': return Icons.light_outlined;
      default: return Icons.shopping_bag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const SizedBox(
            height: 90,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (state is CategoryError) {
          return SizedBox(
            height: 90,
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          );
        }

        if (state is CategoryLoaded) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return const SizedBox(height: 90);
          }

          return Column(
            children: [
              SizedBox(
                height: 90,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedIndex = index);

                        // Firestore se products load karo
                        context.read<ProductBloc>().add(
                          FetchProductsByCategory(category.name),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white24
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getIcon(category.name),
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isSelected)
                              Container(
                                height: 3,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )
                            else
                              const SizedBox(height: 3),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.white12),
            ],
          );
        }

        return const SizedBox(height: 90);
      },
    );
  }
}