import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel
import '../../../core/services/firestore_product_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FirestoreProductService _productService;

  // Recent searches — rental-context terms
  final List<String> _recentSearches = [
    'Drill Machine',
    'Concrete Mixer',
    'Scaffolding',
  ];

  SearchBloc({FirestoreProductService? productService})
      : _productService = productService ?? FirestoreProductService(),
        super(SearchInitial(
        recentSearches: const [
          'Drill Machine',
          'Concrete Mixer',
          'Scaffolding',
        ],
      )) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
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

    // Add to recent history
    if (event.query.length > 2 && !_recentSearches.contains(event.query)) {
      _recentSearches.insert(0, event.query);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
    }

    // Firestore se search karo
    final response = await _productService.searchProducts(event.query);

    if (response.success && response.data != null) {
      emit(SearchLoaded(response.data!));
    } else {
      // Fallback: mock rental products for dev/testing
      final List<RentalProductModel> mockResults = [
        RentalProductModel(
          id: 's1',
          name: 'Rotary Drill Machine',
          description: 'Heavy duty 750W rotary drill for construction use.',
          categoryId: 'power-tools',
          vendorId: 'v1',
          vendorName: 'Sharma Tools',
          vendorAddress: 'Sardarpura, Jodhpur',
          images: [
            'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500'
          ],
          stock: 3,
          rentPerDay: 199,
          rentFor3Days: 499,
          rentPerWeek: 999,
          securityDeposit: 500,
          specifications: {'Power': '750W', 'Weight': '2.5kg'},
          includes: ['Drill bits set', 'Carry case'],
          condition: 'Good',
        ),
        RentalProductModel(
          id: 's2',
          name: 'Concrete Mixer 140L',
          description: '140-litre drum concrete mixer for heavy construction.',
          categoryId: 'construction',
          vendorId: 'v2',
          vendorName: 'Rajput Machinery',
          vendorAddress: 'Paota, Jodhpur',
          images: [
            'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=500'
          ],
          stock: 2,
          rentPerDay: 599,
          rentFor3Days: 1499,
          rentPerWeek: 2999,
          securityDeposit: 2000,
          specifications: {'Capacity': '140L', 'Motor': '1HP'},
          includes: ['Safety gloves'],
          condition: 'Good',
        ),
      ]
          .where((p) =>
      p.name.toLowerCase().contains(event.query.toLowerCase()) ||
          p.categoryId.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(SearchLoaded(mockResults));
    }
  }

  void _onRemoveRecentSearch(
      RemoveRecentSearch event,
      Emitter<SearchState> emit,
      ) {
    _recentSearches.remove(event.query);
    if (state is SearchInitial) {
      emit(SearchInitial(recentSearches: List.from(_recentSearches)));
    }
  }

  void _onClearRecentSearches(
      ClearRecentSearches event,
      Emitter<SearchState> emit,
      ) {
    _recentSearches.clear();
    if (state is SearchInitial) {
      emit(const SearchInitial(recentSearches: []));
    }
  }
}