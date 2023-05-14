import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../ekyc_core/common_model/geo_loc_data.dart';
import '../../ekyc_core/enums/nid_details_tag.dart';
import 'geo_loc_data_source.dart';
import 'model/district_list_response.dart';
import 'model/division_list_response.dart';
import 'model/upazila_list_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 16,February,2023.

class GeoLocController extends StateNotifier<AsyncValue<GeoLocData>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  GeoLocController(this._ref, this._prefs) : super(AsyncData(GeoLocData()));

  Future<void> getDivision(NidDetailsTag tag) async {
    try {
      state = const AsyncLoading();

      final response =
          await _ref.read(divisionDataSourceProvider).getDivision();

      safeApiCall<DivisionListResponse>(response, onSuccess: (response) {
        if (tag == NidDetailsTag.divDropPresent) {
          state = AsyncData(GeoLocData(
              divisionList: response,
              districtList: null,
              upazilaList: null,
              tag: NidDetailsTag.divDropPresent));
        } else {
          state = AsyncData(GeoLocData(
              divisionList: response,
              districtList: null,
              upazilaList: null,
              tag: NidDetailsTag.divDropPermanent));
        }
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }

  Future<void> getDistrict(int id, NidDetailsTag tag) async {
    try {
      state = const AsyncLoading();

      final response =
          await _ref.read(districtDataSourceProvider).getDistrict(id);

      safeApiCall<DistrictListResponse>(response, onSuccess: (response) {
        if (tag == NidDetailsTag.divDropPresent) {
          state = AsyncData(GeoLocData(
              divisionList: null,
              districtList: response,
              upazilaList: null,
              tag: NidDetailsTag.divDropPresent));
        } else if (tag == NidDetailsTag.divDropPermanent) {
          state = AsyncData(GeoLocData(
              divisionList: null,
              districtList: response,
              upazilaList: null,
              tag: NidDetailsTag.divDropPermanent));
        }
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }

  Future<void> getThana(int id, NidDetailsTag tag) async {
    try {
      state = const AsyncLoading();

      final response =
          await _ref.read(upazilaDataSourceProvider).getUpazila(id);

      safeApiCall<UpazilaListResponse>(response, onSuccess: (response) {
        if (tag == NidDetailsTag.disDropPresent) {
          state = AsyncData(GeoLocData(
              divisionList: null,
              districtList: null,
              upazilaList: response,
              tag: NidDetailsTag.disDropPresent));
        } else {
          state = AsyncData(GeoLocData(
              divisionList: null,
              districtList: null,
              upazilaList: response,
              tag: NidDetailsTag.disDropPermanent));
        }
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }
}

final geoLocControllerProvider =
    StateNotifierProvider<GeoLocController, AsyncValue<GeoLocData>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return GeoLocController(ref, prefs);
});
