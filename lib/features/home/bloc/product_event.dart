import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsByCategory extends ProductEvent {
  final String category;

  const FetchProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FetchMoreProducts extends ProductEvent {
  final String category;
  final DocumentSnapshot lastDoc;

  const FetchMoreProducts(this.category, this.lastDoc);

  @override
  List<Object?> get props => [category];
}