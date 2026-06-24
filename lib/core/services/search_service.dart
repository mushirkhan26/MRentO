import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';
import '../models/rental_product_model.dart';

// ─────────────────────────────────────────
// ABSTRACT INTERFACE
// SearchBloc isi ke saath baat karta hai
// ─────────────────────────────────────────
abstract class SearchService {
  Future<ApiResponse<List<RentalProductModel>>> search(String query);
  Future<void> clearCache();
}

// ─────────────────────────────────────────
// CLIENT-SIDE SEARCH — Main Implementation
// Saare products ek baar Firestore se fetch,
// phir device pe hi search/filter karo
// Small catalog (< 500 items) ke liye best
// ─────────────────────────────────────────
class ClientSideSearchService implements SearchService {
  final FirebaseFirestore _firestore;

  ClientSideSearchService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // In-memory cache
  List<RentalProductModel>? _cachedProducts;
  DateTime? _lastFetchTime;
  static const _cacheDuration = Duration(minutes: 10);

  // ── Hinglish synonym map ───────────────────────────────────────
  // Workers aksar Hindi ya shorthand mein type karte hain
  // Yeh map unhe sahi result dega
  static const Map<String, List<String>> _synonyms = {
    'drill':        ['drill machine', 'drilling', 'borer', 'ड्रिल'],
    'mixer':        ['concrete mixer', 'cement mixer', 'drum mixer', 'मिक्सर'],
    'pump':         ['water pump', 'पंप', 'submersible'],
    'scaffolding':  ['scaffold', 'frame', 'staging', 'scaffolding pipe'],
    'generator':    ['genset', 'jenerator', 'जनरेटर', 'power generator'],
    'cutter':       ['cutting machine', 'tile cutter', 'angle grinder', 'grinder'],
    'welder':       ['welding machine', 'वेल्डिंग', 'arc welder'],
    'compressor':   ['air compressor', 'कंप्रेसर', 'pneumatic'],
    'crane':        ['mini crane', 'lifter', 'chain pulley', 'क्रेन'],
    'ladder':       ['aluminium ladder', 'सीढ़ी', 'step ladder'],
    'vibrator':     ['concrete vibrator', 'needle vibrator', 'vibrator machine'],
    'tamper':       ['plate compactor', 'rammer', 'soil compactor'],
    'breaker':      ['jackhammer', 'demolition', 'concrete breaker', 'ब्रेकर'],
    'saw':          ['circular saw', 'wood cutter', 'आरा'],
    'level':        ['laser level', 'spirit level', 'leveling'],
    'pressure':     ['pressure washer', 'jet washer', 'high pressure'],
    'lift':         ['scissor lift', 'aerial platform', 'cherry picker'],
  };

  // ── Fetch all products from Firestore (with cache) ─────────────
  Future<List<RentalProductModel>> _getProducts() async {
    // Cache valid hai to wahi use karo
    if (_cachedProducts != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedProducts!;
    }

    // Firestore se fetch karo
    final snapshot = await _firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .get();

    _cachedProducts = snapshot.docs
        .map((doc) => RentalProductModel.fromJson({
      ...doc.data(),
      '_id': doc.id,
    }))
        .toList();

    _lastFetchTime = DateTime.now();
    return _cachedProducts!;
  }

  // ── Expand query with synonyms ─────────────────────────────────
  List<String> _expandQuery(String query) {
    final terms = <String>{query}; // original term always included

    for (final entry in _synonyms.entries) {
      // Check if query matches key or any synonym
      if (query.contains(entry.key) ||
          entry.value.any((syn) => syn.toLowerCase().contains(query))) {
        terms.add(entry.key);
        terms.addAll(entry.value.map((s) => s.toLowerCase()));
      }
    }

    return terms.toList();
  }

  // ── Score each product — higher = more relevant ────────────────
  int _scoreProduct(RentalProductModel product, List<String> terms) {
    int score = 0;
    final name = product.name.toLowerCase();
    final category = product.categoryId.toLowerCase();
    final vendor = product.vendorName.toLowerCase();
    final brand = (product.brand ?? '').toLowerCase();
    final desc = product.description.toLowerCase();
    final tags = product.tags.map((t) => t.toLowerCase()).toList();

    for (final term in terms) {
      // Name match — highest priority
      if (name == term) score += 100;          // exact match
      else if (name.startsWith(term)) score += 60;  // prefix match
      else if (name.contains(term)) score += 40;    // substring match

      // Category match
      if (category.contains(term)) score += 30;

      // Tags match
      if (tags.any((t) => t.contains(term))) score += 25;

      // Vendor / Brand match
      if (vendor.contains(term)) score += 15;
      if (brand.contains(term)) score += 15;

      // Description match — lowest priority
      if (desc.contains(term)) score += 5;
    }

    return score;
  }

  // ── Main search ────────────────────────────────────────────────
  @override
  Future<ApiResponse<List<RentalProductModel>>> search(String query) async {
    try {
      final q = query.toLowerCase().trim();
      if (q.isEmpty) return ApiResponse.success([]);

      final products = await _getProducts();
      final terms = _expandQuery(q);

      // Score every product
      final scored = products
          .map((p) => _ScoredProduct(p, _scoreProduct(p, terms)))
          .where((sp) => sp.score > 0) // only products with any match
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score)); // highest score first

      final results = scored.map((sp) => sp.product).toList();
      return ApiResponse.success(results);
    } catch (e) {
      return ApiResponse.error('Search fail hua: $e');
    }
  }

  // ── Clear cache (forced refresh ke liye) ──────────────────────
  @override
  Future<void> clearCache() async {
    _cachedProducts = null;
    _lastFetchTime = null;
  }
}

// ── Helper class ───────────────────────────────────────────────
class _ScoredProduct {
  final RentalProductModel product;
  final int score;
  const _ScoredProduct(this.product, this.score);
}

// ── Backward-compatible alias ──────────────────────────────────
// SearchBloc mein 'FirestoreFallbackSearchService' likha hai
// Yeh class usi naam se same kaam karti hai
class FirestoreFallbackSearchService extends ClientSideSearchService {
  FirestoreFallbackSearchService() : super();
}