import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/models/rental_product_model.dart';
import '../../../core/services/search_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Use the interface instead of concrete Firestore service
  final SearchService _searchService;
  
  final List<String> _recentSearches = [
    'Drill Machine',
    'Concrete Mixer',
    'Scaffolding',
  ];

  SearchBloc({SearchService? searchService})
      : _searchService = searchService ?? FirestoreFallbackSearchService(),
        super(SearchInitial(recentSearches: const [
          'Drill Machine',
          'Concrete Mixer',
          'Scaffolding',
        ])) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ApplyFilters>(_onApplyFilters);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial(recentSearches: List.from(_recentSearches)));
      return;
    }

    emit(SearchLoading());

    if (event.query.length > 2 && !_recentSearches.contains(event.query)) {
      _recentSearches.insert(0, event.query);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
      
      // Log Analytics Search
      AnalyticsService.instance.logSearch(event.query);
    }

    // Call the dynamic search service
    final response = await _searchService.search(event.query);

    if (response.success && response.data != null) {
      emit(SearchLoaded(response.data!, originalResults: response.data!));
    } else {
      emit(const SearchLoaded([], originalResults: []));
    }
  }

  void _onApplyFilters(ApplyFilters event, Emitter<SearchState> emit) {
    if (state is! SearchLoaded) return;
    final currentState = state as SearchLoaded;

    List<RentalProductModel> filtered = List.from(currentState.originalResults);

    // Filter by Price
    if (event.minPrice != null) {
      filtered = filtered.where((p) => (p.rentPerDay ?? 0) >= event.minPrice!).toList();
    }
    if (event.maxPrice != null) {
      filtered = filtered.where((p) => (p.rentPerDay ?? 0) <= event.maxPrice!).toList();
    }

    // Sort
    if (event.sortBy == 'price_low_high') {
      filtered.sort((a, b) => (a.rentPerDay ?? 0).compareTo(b.rentPerDay ?? 0));
    } else if (event.sortBy == 'price_high_low') {
      filtered.sort((a, b) => (b.rentPerDay ?? 0).compareTo(a.rentPerDay ?? 0));
    }

    emit(SearchLoaded(
      filtered,
      originalResults: currentState.originalResults,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      sortBy: event.sortBy,
    ));
  }

  void _onRemoveRecentSearch(RemoveRecentSearch event, Emitter<SearchState> emit) {
    _recentSearches.remove(event.query);
    if (state is SearchInitial) {
      emit(SearchInitial(recentSearches: List.from(_recentSearches)));
    }
  }

  void _onClearRecentSearches(
      ClearRecentSearches event, Emitter<SearchState> emit) {
    _recentSearches.clear();
    if (state is SearchInitial) {
      emit(const SearchInitial(recentSearches: []));
    }
  }
}
