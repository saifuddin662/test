import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/ui/configs/branding_data_controller.dart';
import 'package:red_cash_dfs_flutter/ui/configs/colors/core_colors.dart';
import 'package:red_cash_dfs_flutter/ui/configs/core_branding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/core_providers.dart' as providers;
import '../common/loading.dart';
import '../common/logger/logger_provider.dart';
import '../ui/configs/colors/first_cash_colors.dart';
import '../ui/configs/colors/red_cash_colors.dart';
import 'di/core_providers.dart';
import 'env/env_reader.dart';
import 'firebase/crashlytics/crashlytics.dart';
import 'firebase/firebase_options_provider.dart';
import 'firebase/notification/firebase_push_notification.dart';
import 'flavor/flavor_provider.dart';
import 'flavor/flavors.dart';
/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 10,January,2023.

/// Initializes services and controllers before the start of the application
Future<ProviderContainer> bootstrap(Flavor flavor) async {

  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    observers: [if (kDebugMode) _Logger()],
  );

  container.read(flavorProvider.notifier).state = flavor;
  setBrandingData(flavor);


  // todo need to enable firebase

/*  final firebaseOptions = container.read(firebaseOptionsProvider(flavor));
  await Firebase.initializeApp(
    options: firebaseOptions,
  );*/

/*  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;*/

/*  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };*/

/*  container.read(firebasePushNotificationProvider);
  container.read(crashlyticsProvider);*/

  final envReader = container.read(envReaderProvider);
  final envFile = envReader.getEnvFileName();
  await dotenv.load(fileName: envFile);
  container.read(setupLoggingProvider);

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Loading();


  await providers.initializeProviders(container);
  return container;
}

void setBrandingData(Flavor flavor) {
  BrandingDataController.instance.branding = CoreBranding(flavor);
  BrandingDataController.instance.branding.setBrandData();
}

class _Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '''
      {
      "provider": "${provider.name ?? provider.runtimeType}",
      "newValue": "$newValue"
      }''',
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (provider.name != null) {
      debugPrint(
      '''
      {
      "didAddProvider": "${provider.name}",
      "value": "$value"
      }''',
      );
    }
  }

  @override
  void providerDidFail(
      ProviderBase<Object?> provider,
      Object error,
      StackTrace stackTrace,
      ProviderContainer container,
      ) {
    if (provider.name != null) {
      debugPrint(
      '''
      {
      "providerDidFail": "${provider.name}"
      }''',
      );
    }
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    if (provider.name != null) {
      debugPrint(
      '''
      {
      "didDisposeProvider": "${provider.name}"
      }''',
      );
    }
  }
}