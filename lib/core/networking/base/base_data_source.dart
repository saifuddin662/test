import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../enum/network_status.dart';
import 'base_result.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 15,January,2023.

typedef ResponseConverter<T> = T Function(dynamic response);

class BaseDataSource {

  final Dio dio;

  BaseDataSource(this.dio);

  Future<BaseResult<T>> getResult<T>(
      Future<Response<dynamic>> call, ResponseConverter<T> converter) async {
    try {
      var response = await call;
      if (response.statusCode == HttpsStatus.success.code) {
        var transform = converter(response.data);
        return BaseResult.success(transform);
      } else {
        if (response.data != "" && response.data != null) {
          return BaseResult.error(
            response.data['code'] ?? response.data['status'] ?? response.statusCode ?? 000, response.data['message'] ?? response.data['error'] ?? 'unknown_error'.tr());
        } else {
          return BaseResult.error(
            response.statusCode ?? 000, response.statusMessage ?? 'unknown_error'.tr());
        }
      }
    } on DioError catch (e) {
      debugPrint(e.error.toString());
      return BaseResult.error(000, 'unknown_error'.tr());
    }
  }

  Future<BaseResult<T>> getResultWithEmptyResponse<T>(
      Future<Response<dynamic>> call) async {
    try {
      var response = await call;
      if (response.statusCode == HttpsStatus.success.code) {
        return BaseResult.success(null);
      } else {
        return BaseResult.error(0, '');
      }
    } on DioError catch (e) {
      return BaseResult.error(0, 'Error');
    }
  }

  Future<Response<dynamic>> get<T>(String url,
      {Map<String, dynamic>? params}) async {
    final Response response;

    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response;
  }

  Future<Response<dynamic>> post<T>(
      String url, Map<String, dynamic>? body) async {
    final Response response = await dio.post(url, data: body);
    return response;
  }

  Future<Response<dynamic>> postFormData<T>(String url, FormData body) async {
    final Response response = await dio.post(url, data: body);
    return response;
  }

  Future<Response<dynamic>> put<T>(
      String url, Map<String, dynamic> body) async {
    final Response response = await dio.put(url, data: body);
    return response;
  }

  Future<Response<dynamic>> putFormData<T>(String url, FormData body) async {
    final Response response = await dio.put(url, data: body);
    return response;
  }

  Future<Response<dynamic>> delete<T>(
      String url, Map<String, dynamic> body) async {
    final Response response = await dio.delete(url, data: body);
    return response;
  }

  Future<Response<dynamic>> update<T>(
      String url, Map<String, dynamic> body) async {
    final Response response = await dio.patch(url, data: body);
    return response;
  }
}