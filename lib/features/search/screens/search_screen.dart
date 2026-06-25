import 'package:MRentO/features/search/bloc/search_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';
import '../widgets/search_header.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/search_category_list.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/trending_now_widget.dart';
import '../widgets/recently_viewed_widget.dart';
import '../widgets/suggested_products_widget.dart';
import '../widgets/search_results_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primaryDarkGreen,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<SearchBloc, SearchState>(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Column(
            children: [
              SearchHeader(controller: _searchController),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    final bool showFilter = (state is SearchLoaded && state.results.isNotEmpty);
                    return Column(
                      children: [
                        if (showFilter) const SearchFilterBar(),
                        Expanded(
                          child: _buildBodyContent(state),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(SearchState state) {
    if (state is SearchLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryDarkGreen));
    }
    if (state is SearchLoaded) {
      return SearchResultsGrid(state: state, controller: _searchController);
    }
    if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<SearchBloc>().add(SearchQueryChanged(state.currentQuery));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.primaryBlack,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final List<String> recentSearches = state is SearchInitial ? state.recentSearches : [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecentSearchesWidget(searches: recentSearches, controller: _searchController),
          SearchCategoryList(controller: _searchController),
          const SizedBox(height: 24),
          TrendingNowWidget(controller: _searchController),
          const SizedBox(height: 24),
          const RecentlyViewedWidget(),
          const SizedBox(height: 24),
          const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
          SuggestedProductsWidget(controller: _searchController),
        ],
      ),
    );
  }
}