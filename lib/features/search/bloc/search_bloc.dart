import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/models/rental_product_model.dart';
import '../../../core/services/search_service.dart';
import '../../../core/services/voice_search_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/logger_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Use the interface instead of concrete Firestore service
  final SearchService _searchService;
  final VoiceSearchService _voiceSearchService;
  final LocalStorageService _storageService;
  
  List<String> _recentSearches = [];
  List<RentalProductModel> _recentlyViewed = [];

  SearchBloc({
    SearchService? searchService,
    VoiceSearchService? voiceSearchService,
    LocalStorageService? storageService,
  })  : _searchService = searchService ?? FirestoreFallbackSearchService(),
        _voiceSearchService = voiceSearchService ?? VoiceSearchService(),
        _storageService = storageService ?? LocalStorageService(),
        super(const SearchInitial(recentSearches: [])) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .flatMap(mapper);
      },
    );
    on<ApplyFilters>(_onApplyFilters);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
    on<StartVoiceSearch>(_onStartVoiceSearch);
    on<VoiceSearchStatusChanged>(_onVoiceSearchStatusChanged);
    on<AddToRecentlyViewed>(_onAddToRecentlyViewed);

    // Load history immediately
    add(const LoadSearchHistory());
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    _recentSearches = await _storageService.getRecentSearches();
    _recentlyViewed = await _storageService.getRecentlyViewed();
    
    // If it's the first time and storage is empty, use defaults
    if (_recentSearches.isEmpty) {
      _recentSearches = ['Drill Machine', 'Concrete Mixer', 'Scaffolding'];
      await _storageService.saveRecentSearches(_recentSearches);
    }

    emit(SearchInitial(
      recentSearches: List.from(_recentSearches),
      recentlyViewed: List.from(_recentlyViewed),
      isListening: state.isListening,
      currentQuery: state.currentQuery,
    ));
  }

  Future<void> _onStartVoiceSearch(
    StartVoiceSearch event,
    Emitter<SearchState> emit,
  ) async {
    if (_voiceSearchService.isListening) {
      await _voiceSearchService.stopListening();
      emit(_updateState(state, isListening: false));
    } else {
      // Clear previous errors when starting new search
      emit(_updateState(state, isListening: true, error: null));
      await _voiceSearchService.startListening(
        onResult: (result) {
          add(VoiceSearchStatusChanged(isListening: false, result: result));
        },
        onDone: () {
          add(const VoiceSearchStatusChanged(isListening: false));
        },
        onError: (error) {
          LoggingService.instance.error('SearchBloc', 'Voice search error', error: error);
          add(VoiceSearchStatusChanged(isListening: false, error: error));
        },
      );
    }
  }

  void _onVoiceSearchStatusChanged(
    VoiceSearchStatusChanged event,
    Emitter<SearchState> emit,
  ) {
    String? query = event.result ?? state.currentQuery;
    emit(_updateState(state, 
      isListening: event.isListening, 
      query: query,
      error: event.error,
    ));
    if (event.result != null && event.result!.isNotEmpty) {
      add(SearchQueryChanged(event.result!));
    }
  }

  SearchState _updateState(SearchState state, {bool? isListening, String? query, String? error}) {
    final bool listening = isListening ?? state.isListening;
    final String currentQ = query ?? state.currentQuery;
    final String? currentError = error;

    if (state is SearchInitial) {
      return SearchInitial(
        recentSearches: state.recentSearches,
        isListening: listening,
        currentQuery: currentQ,
        error: currentError,
        recentlyViewed: state.recentlyViewed,
      );
    } else if (state is SearchLoaded) {
      return SearchLoaded(
        state.results,
        originalResults: state.originalResults,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        sortBy: state.sortBy,
        isListening: listening,
        currentQuery: currentQ,
        error: currentError,
        recentlyViewed: state.recentlyViewed,
      );
    } else if (state is SearchLoading) {
      return SearchLoading(
        isListening: listening, 
        currentQuery: currentQ,
        error: currentError,
        recentlyViewed: state.recentlyViewed,
      );
    } else if (state is SearchError) {
      return SearchError(
        state.message, 
        isListening: listening, 
        currentQuery: currentQ,
        error: currentError,
        recentlyViewed: state.recentlyViewed,
      );
    }
    return state;
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial(
        recentSearches: List.from(_recentSearches),
        recentlyViewed: List.from(_recentlyViewed),
        isListening: state.isListening,
        currentQuery: '',
      ));
      return;
    }

    emit(SearchLoading(
      isListening: state.isListening, 
      currentQuery: event.query,
      recentlyViewed: List.from(_recentlyViewed),
    ));

    // Call the dynamic search service
    final response = await _searchService.search(event.query);

    if (response.success && response.data != null) {
      if (event.query.length > 2) {
        if (!_recentSearches.contains(event.query)) {
          _recentSearches.insert(0, event.query);
          if (_recentSearches.length > 8) _recentSearches.removeLast();
          await _storageService.saveRecentSearches(_recentSearches);
        }
        
        // Log Analytics Search
        AnalyticsService.instance.logSearch(event.query);
      }

      emit(SearchLoaded(
        response.data!,
        originalResults: response.data!,
        isListening: state.isListening,
        currentQuery: event.query,
        recentlyViewed: List.from(_recentlyViewed),
      ));
    } else {
      LoggingService.instance.error(
        'SearchBloc',
        'Search failed for query: ${event.query}',
        error: response.message,
      );
      emit(SearchError(
        response.message ?? 'Search failed. Please try again.',
        isListening: state.isListening,
        currentQuery: event.query,
        recentlyViewed: List.from(_recentlyViewed),
      ));
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
      isListening: currentState.isListening,
      currentQuery: currentState.currentQuery,
      recentlyViewed: currentState.recentlyViewed,
    ));
  }

  Future<void> _onRemoveRecentSearch(RemoveRecentSearch event, Emitter<SearchState> emit) async {
    _recentSearches.remove(event.query);
    await _storageService.saveRecentSearches(_recentSearches);
    if (state is SearchInitial) {
      emit(SearchInitial(
        recentSearches: List.from(_recentSearches),
        recentlyViewed: List.from(_recentlyViewed),
        isListening: state.isListening,
        currentQuery: state.currentQuery,
      ));
    }
  }

  Future<void> _onClearRecentSearches(
      ClearRecentSearches event, Emitter<SearchState> emit) async {
    _recentSearches.clear();
    await _storageService.saveRecentSearches(_recentSearches);
    if (state is SearchInitial) {
      emit(SearchInitial(
        recentSearches: const [],
        recentlyViewed: List.from(_recentlyViewed),
        isListening: state.isListening,
        currentQuery: state.currentQuery,
      ));
    }
  }

  Future<void> _onAddToRecentlyViewed(
    AddToRecentlyViewed event,
    Emitter<SearchState> emit,
  ) async {
    // Remove if already exists (to move it to top)
    _recentlyViewed.removeWhere((p) => p.id == event.product.id);
    _recentlyViewed.insert(0, event.product);
    
    // Keep only last 10
    if (_recentlyViewed.length > 10) {
      _recentlyViewed.removeLast();
    }
    
    await _storageService.saveRecentlyViewed(_recentlyViewed);
    
    // Update current state with new recently viewed list
    if (state is SearchInitial) {
      emit(SearchInitial(
        recentSearches: (state as SearchInitial).recentSearches,
        recentlyViewed: List.from(_recentlyViewed),
        isListening: state.isListening,
        currentQuery: state.currentQuery,
        error: state.error,
      ));
    } else if (state is SearchLoaded) {
      final s = state as SearchLoaded;
      emit(SearchLoaded(
        s.results,
        originalResults: s.originalResults,
        minPrice: s.minPrice,
        maxPrice: s.maxPrice,
        sortBy: s.sortBy,
        isListening: s.isListening,
        currentQuery: s.currentQuery,
        error: s.error,
        recentlyViewed: List.from(_recentlyViewed),
      ));
    } else {
      // For Loading or Error states, just update the base recentlyViewed
      emit(_updateState(state));
    }
  }
}
