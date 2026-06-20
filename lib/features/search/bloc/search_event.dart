import 'package:equatable/equatable.dart';

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
