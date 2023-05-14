import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../env/env_reader.dart';
import '../flavor/flavor_provider.dart';
import '../networking/interceptors/header_interceptor.dart';
import '../networking/interceptors/network_interceptor.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 10,January,2023.

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: ref.read(envReaderProvider).getBaseUrl(),
    receiveDataWhenStatusError: true,
    validateStatus: (_) => true,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      //'userType': ref.read(flavorProvider).name, // todo shaj userType XXX
      'userType': 'CUSTOMER',
    },
  );

  final dio = Dio(options);

  dio.interceptors.addAll([HeaderInterceptor(), NetworkInterceptors()]);

  if (kDebugMode) {
    dio.interceptors.addAll([
      ref.read(prettyDioLoggerProvider),
    ]);
  }

  return dio;
});

final prettyDioLoggerProvider = Provider<PrettyDioLogger>(
  (ref) => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ),
);
