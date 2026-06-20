import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_home_service.dart';
import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final FirestoreHomeService _homeService;

  BannerBloc({FirestoreHomeService? homeService})
      : _homeService = homeService ?? FirestoreHomeService(),
        super(BannerInitial()) {
    on<FetchBanners>(_onFetchBanners);
  }

  Future<void> _onFetchBanners(
      FetchBanners event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    final response = await _homeService.getBanners();
    if (response.success && response.data != null) {
      emit(BannerLoaded(response.data!));
    } else {
      emit(BannerError(response.message ?? 'Banners load nahi hue'));
    }
  }
}
