import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'api/banner_list_data_source.dart';
import 'api/model/banner_list_request.dart';
import 'api/model/banners_list_response.dart';


class BannerListController extends StateNotifier<AsyncValue<BannersListResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  BannerListController(this._ref) : super(AsyncData(BannersListResponse(bannerList: [])));

  Future<void> getBanners(BannerListRequest bannerListRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(bannerListDataSourceProvider).getBanners(bannerListRequest);

      safeApiCall<BannersListResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);

      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error",StackTrace.current);
    }
  }

}

final bannerListControllerProvider = StateNotifierProvider<BannerListController, AsyncValue<BannersListResponse>>((ref) {
  return BannerListController(ref);
});

