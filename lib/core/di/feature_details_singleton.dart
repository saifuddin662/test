import '../../module/dashboard/home/api/model/feature_list_response.dart';

class FeatureDetailsSingleton {
  static final FeatureDetailsSingleton _singleton = FeatureDetailsSingleton._internal();

  factory FeatureDetailsSingleton() {
    return _singleton;
  }

  FeatureDetailsSingleton._internal();

  Map<String, Feature?> feature = {};

  static FeatureDetailsSingleton getInstance() {
    return _singleton;
  }

}
