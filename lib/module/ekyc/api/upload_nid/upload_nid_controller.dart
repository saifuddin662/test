import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:isolate_image_compress/isolate_image_compress.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/api/upload_nid/upload_nid_data_source.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/di/singleton_provider.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../utils/pref_keys.dart';
import '../../ekyc_core/ekyc_utils.dart';
import 'model/upload_nid_reponse.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 12,February,2023.

class UploadNidController extends StateNotifier<AsyncValue<UploadNidResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  UploadNidController(this._ref, this._prefs)
      : super(AsyncData(UploadNidResponse()));

  Future<void> uploadNid() async {
    try {
      state = const AsyncLoading();

      final nidFrontPath =
          _ref.read(globalDataControllerProvider).capturedPhotos.nidFront;
      final nidBackPath =
          _ref.read(globalDataControllerProvider).capturedPhotos.nidBack;

      final msisdn = _prefs.getString(PrefKeys.keyMsisdn);

      var frontImageFile = await _processNidImageFile(nidFrontPath!);
      var backImageFile = await _processNidImageFile(nidBackPath!);

      FormData formData = FormData.fromMap(
        {
          "id_front": await _generateImageMultiPart(frontImageFile!),
          "id_back": await _generateImageMultiPart(backImageFile!),
          "isNewRegistration": true,
          "msisdn": msisdn,
        },
      );

      final response =
          await _ref.read(uploadNidDataSourceProvider).uploadNid(formData);

      safeApiCall<UploadNidResponse>(response, onSuccess: (response) {
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
      filename: "nid_image.jpg",
      contentType: MediaType("image", "jpg"),
    );

    return imageMultipart;
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

final uploadNidControllerProvider =
    StateNotifierProvider<UploadNidController, AsyncValue<UploadNidResponse>>(
        (ref) {
  final prefs = ref.watch(localPrefProvider);
  return UploadNidController(ref, prefs);
});
