import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart';

abstract class SearchState extends Equatable {
  final bool isListening;
  final String currentQuery;
  final String? error;
  final List<RentalProductModel> recentlyViewed;

  const SearchState({
    this.isListening = false,
    this.currentQuery = '',
    this.error,
    this.recentlyViewed = const [],
  });

  @override
  List<Object?> get props => [isListening, currentQuery, error, recentlyViewed];
}

class SearchInitial extends SearchState {
  final List<String> recentSearches;
  const SearchInitial({
    this.recentSearches = const [],
    super.isListening,
    super.currentQuery,
    super.error,
    super.recentlyViewed,
  });
  @override
  List<Object?> get props => [recentSearches, isListening, currentQuery, error, recentlyViewed];
}

class SearchLoading extends SearchState {
  const SearchLoading({
    super.isListening,
    super.currentQuery,
    super.error,
    super.recentlyViewed,
  });
}

class SearchLoaded extends SearchState {
  final List<RentalProductModel> results;
  final List<RentalProductModel> originalResults; // Store unfiltered for logic
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;

  const SearchLoaded(
    this.results, {
    this.originalResults = const [],
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    super.isListening,
    super.currentQuery,
    super.error,
    super.recentlyViewed,
  });

  @override
  List<Object?> get props => [
        results,
        originalResults,
        minPrice,
        maxPrice,
        sortBy,
        isListening,
        currentQuery,
        error,
        recentlyViewed,
      ];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(
    this.message, {
    super.isListening,
    super.currentQuery,
    super.error,
    super.recentlyViewed,
  });
  @override
  List<Object?> get props => [message, isListening, currentQuery, error, recentlyViewed];
}
