import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/di/feature_details_singleton.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/feature_details_keys.dart';
import 'api/feature_list_data_source.dart';
import 'api/model/feature_list_request.dart';
import 'api/model/feature_list_response.dart';

class FeatureController extends StateNotifier<AsyncValue<FeatureListResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  FeatureController(this._ref) : super(AsyncData(FeatureListResponse(features: [])));

  Future<void> getFeatureList(FeatureListRequest featureListRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(featureListDataSourceProvider).getFeatureList(featureListRequest);

      safeApiCall<FeatureListResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);

        if (response.features?.first.featureList != null) {
          response.features?.first.featureList?.forEach((object) {
            if(_ref.read(flavorProvider).name == AppConstants.userTypeCustomer) {
              switch(object.featureCode) {
                case FeatureDetailsKeys.sendMoney:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney] = object;
                  break;
                case FeatureDetailsKeys.cashOutCustomer:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.cashOutCustomer] = object;
                  break;
                case FeatureDetailsKeys.merchantPayment:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.merchantPayment] = object;
                  break;
                case FeatureDetailsKeys.educationFees:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.educationFees] = object;
                  break;
                case FeatureDetailsKeys.mobileRecharge:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.mobileRecharge] = object;
                  break;
                case FeatureDetailsKeys.addMoney:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.addMoney] = object;
                  break;
                case FeatureDetailsKeys.requestMoney:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.requestMoney] = object;
                  break;
                case FeatureDetailsKeys.agentLocator:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.agentLocator] = object;
                  break;
              }
            }
            else if(_ref.read(flavorProvider).name == AppConstants.userTypeAgent) {
              switch(object.featureCode) {
                case FeatureDetailsKeys.agentCashOut:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.agentCashOut] = object;
                  break;
                case FeatureDetailsKeys.cashInFromMfsAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.cashInFromMfsAgent] = object;
                  break;
                case FeatureDetailsKeys.merchantPaymentAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.merchantPaymentAgent] = object;
                  break;
                case FeatureDetailsKeys.educationFeesAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.educationFeesAgent] = object;
                  break;
                case FeatureDetailsKeys.addMoneyAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.addMoneyAgent] = object;
                  break;
                case FeatureDetailsKeys.billPaymentAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.billPaymentAgent] = object;
                  break;
                case FeatureDetailsKeys.customerRegistrationByAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.customerRegistrationByAgent] = object;
                  break;
              }
            }
            else if(_ref.read(flavorProvider).name == AppConstants.userTypeDsr) {
              switch(object.featureCode) {
                case FeatureDetailsKeys.dsrTopUpAgent:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.dsrTopUpAgent] = object;
                  break;
                case FeatureDetailsKeys.limitDsr:
                  featureDetailsSingleton.feature[FeatureDetailsKeys.limitDsr] = object;
                  break;
              }
            }
          });
        }

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

final featureListControllerProvider = StateNotifierProvider<FeatureController, AsyncValue<FeatureListResponse>>((ref) {
  return FeatureController(ref);
});

