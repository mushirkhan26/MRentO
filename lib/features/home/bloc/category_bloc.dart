import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/category_model.dart';
import '../../../core/services/firestore_product_service.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoryEvent {}

// States
abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  const CategoryLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirestoreProductService _service;

  CategoryBloc({FirestoreProductService? service})
      : _service = service ?? FirestoreProductService(),
        super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchCategories event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());

    final response = await _service.getCategories();

    if (response.success && response.data != null) {
      emit(CategoryLoaded(response.data!));
    } else {
      emit(CategoryError(response.message ?? 'Categories load nahi hui'));
    }
  }
}