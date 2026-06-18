import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel

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
  final List<RentalProductModel> results; // ← updated
  const SearchLoaded(this.results);
  @override
  List<Object?> get props => [results];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}