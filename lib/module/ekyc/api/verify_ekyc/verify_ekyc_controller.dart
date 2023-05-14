import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:isolate_image_compress/isolate_image_compress.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/api/verify_ekyc/verify_ekyc_data_source.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/di/singleton_provider.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../utils/pref_keys.dart';
import '../../ekyc_core/ekyc_utils.dart';
import 'model/verify_ekyc_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 13,February,2023.

class VerifyEkycController
    extends StateNotifier<AsyncValue<VerifyEkycResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  VerifyEkycController(this._ref, this._prefs)
      : super(AsyncData(VerifyEkycResponse()));

  Future<void> verifyEkyc() async {
    try {
      state = const AsyncLoading();

      final facePath = _ref.read(globalDataControllerProvider).capturedPhotos.face;
      final ekycInfo = _ref.read(globalDataControllerProvider).ekycInfos;
      final ekycStatus = _ref.read(globalDataControllerProvider).ekycState;
      var faceImageFile = await _processFaceImageFile(facePath!);
      final mobileNo = _prefs.getString(PrefKeys.keyPhoneNo);
      final walletNo = _ref.watch(globalDataControllerProvider).walletData.walletNo ?? '$mobileNo*';

      final nidFrontPath =
          _ref.read(globalDataControllerProvider).capturedPhotos.nidFront;
      final nidBackPath =
          _ref.read(globalDataControllerProvider).capturedPhotos.nidBack;

      var frontImageFile = await _processNidImageFile(nidFrontPath!);
      var backImageFile = await _processNidImageFile(nidBackPath!);

      FormData formData = FormData.fromMap(
        {
          "applicant_photo": await _generateImageMultiPart(faceImageFile!),
          "nid_back": await _generateImageMultiPart(backImageFile!),
          "nid_front": await _generateImageMultiPart(frontImageFile!),
          "applicant_name_ben": ekycInfo.applicantNameBen,
          "applicant_name_eng": ekycInfo.applicantNameEng,
          "blood_group": ekycInfo.blood_group,
          "present_district": ekycInfo.districtPresent,
          "present_division": ekycInfo.divisionPresent,
          "present_thana": ekycInfo.thanaPresent,
          "permanent_division": ekycInfo.divisionPermanent,
          "permanent_district": ekycInfo.districtPermanent,
          "permanent_thana": ekycInfo.thanaPermanent,
          "dob": ekycInfo.dob,
          "father_name": ekycInfo.fatherName,
          "gender": ekycInfo.gender,
          "id_back_name": ekycInfo.idBackName,
          "id_front_name": ekycInfo.idFrontName,
          "income_amount": ekycInfo.income_amount,
          "mobile_number": mobileNo,
          "mother_name": ekycInfo.motherName,
          "nid_address": ekycInfo.address,
          "nid_no": ekycInfo.nidNo,
          "nominee": ekycInfo.nominee,
          "nominee_dob": ekycInfo.nominee_dob,
          "nominee_mobile": ekycInfo.nominee_mobile,
          "nominee_nid": ekycInfo.nominee_nid,
          "nominee_percentage": ekycInfo.nominee_percentage,
          "nominee_relation": ekycInfo.nominee_relation,
          "ocr_request_uuid": ekycInfo.ocrRequestUuid,
          "perm_address": ekycInfo.perm_address,
          "present_post_code": ekycInfo.post_code_present,
          "present_post_office": ekycInfo.post_office_present,
          "permanent_post_code": ekycInfo.post_code_permanent,
          "permanent_post_office": ekycInfo.post_office_permanent,
          "pres_address": ekycInfo.pres_address,
          "profession": ekycInfo.profession,
          "source_of_income": ekycInfo.source_of_income,
          "ekyc_status": ekycStatus,
          "wallet_no ": walletNo,
        },
      );

      final response =
          await _ref.read(verifyEkycDataSourceProvider).verifyEkyc(formData);

      safeApiCall<VerifyEkycResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);
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

  Future<MultipartFile> _generateImageMultiPart(Uint8List imageFile) async {
    var imageMultipart = MultipartFile.fromBytes(
      imageFile,
      filename: "face_image.jpg",
      contentType: MediaType("image", "jpg"),
    );

    return imageMultipart;
  }

  Future<Uint8List?> _processFaceImageFile(String path) async {
    //compress image
    final isolateImage = IsolateImage.path(path);
    log.info(
        'image size before - : ${EKycUtils.getFileSizeString(bytes: isolateImage.data!.length ?? 0)}');
    final compressedImage =
        await isolateImage.compress(maxSize: 1 * 1024 * 1024); // 1 MB
    log.info(
        'image size after - : ${EKycUtils.getFileSizeString(bytes: compressedImage?.length ?? 0)}');

    return compressedImage;
  }

  Future<Uint8List?> _processNidImageFile(String path) async {

    //rotate image
    img.Image? originalImage = img.decodeImage(await File(path).readAsBytes());
    img.Image rotatedImage = img.copyRotate(originalImage!, angle: -90);
    Uint8List imageBytesOrientated = img.encodeJpg(rotatedImage);

    //compress image
    final isolateImage = IsolateImage.data(imageBytesOrientated);
    log.info('image size before - : ${EKycUtils.getFileSizeString(bytes: isolateImage.data!.length ?? 0)}');
    final compressedImage = await isolateImage.compress(maxSize: 1 * 1024 * 1024); // 1 MB
    log.info('image size after - : ${EKycUtils.getFileSizeString(bytes: compressedImage?.length ?? 0)}');

    return compressedImage;
  }


}

final verifyEkycControllerProvider =
    StateNotifierProvider<VerifyEkycController, AsyncValue<VerifyEkycResponse>>(
        (ref) {
  final prefs = ref.watch(localPrefProvider);
  return VerifyEkycController(ref, prefs);
});
