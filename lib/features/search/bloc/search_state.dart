import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  final List<String> recentSearches;
  const SearchInitial({this.recentSearches = const []});
  @override
  List<Object?> get props => [recentSearches];
}

class SearchLoading extends SearchState {}

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
  });

  @override
  List<Object?> get props => [results, originalResults, minPrice, maxPrice, sortBy];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}
