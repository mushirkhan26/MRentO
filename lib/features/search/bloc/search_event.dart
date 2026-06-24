import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class RemoveRecentSearch extends SearchEvent {
  final String query;

  const RemoveRecentSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearRecentSearches extends SearchEvent {
  const ClearRecentSearches();
}

class ApplyFilters extends SearchEvent {
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy; // 'price_low_high', 'price_high_low', 'rating'

  const ApplyFilters({this.minPrice, this.maxPrice, this.sortBy});

  @override
  List<Object?> get props => [minPrice, maxPrice, sortBy];
}

class StartVoiceSearch extends SearchEvent {
  const StartVoiceSearch();
}

class VoiceSearchStatusChanged extends SearchEvent {
  final bool isListening;
  final String? result;
  final String? error;

  const VoiceSearchStatusChanged({
    required this.isListening,
    this.result,
    this.error,
  });

  @override
  List<Object?> get props => [isListening, result, error];
}

class LoadSearchHistory extends SearchEvent {
  const LoadSearchHistory();
}

class AddToRecentlyViewed extends SearchEvent {
  final RentalProductModel product;

  const AddToRecentlyViewed(this.product);

  @override
  List<Object?> get props => [product];
}
