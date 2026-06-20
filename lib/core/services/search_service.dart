import '../../../core/models/rental_product_model.dart';
import '../api/base_api/api_response.dart';
import 'firestore_product_service.dart';

/// Abstract interface for search to support easy swap between 
/// Firestore basic search and Algolia/Typesense.
abstract class SearchService {
  Future<ApiResponse<List<RentalProductModel>>> search(String query);
}

class AlgoliaSearchService implements SearchService {
  // Logic to call Algolia REST API
  @override
  Future<ApiResponse<List<RentalProductModel>>> search(String query) async {
    // TODO: Implement Algolia API call using 'dio' or 'http'
    // This is where you would send the query to Algolia and parse results.
    return ApiResponse.error('Algolia integration pending API key configuration');
  }
}

class FirestoreFallbackSearchService implements SearchService {
  final FirestoreProductService _firestoreService = FirestoreProductService();

  @override
  Future<ApiResponse<List<RentalProductModel>>> search(String query) async {
    return _firestoreService.searchProducts(query);
  }
}
