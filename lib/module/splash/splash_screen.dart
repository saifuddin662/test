import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../base/base_consumer_state.dart';
import '../../common/loading.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/singleton_provider.dart';
import '../../core/env/env_reader.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_force_update_dialog.dart';
import '../../utils/pref_keys.dart';
import '../boot/config/api/model/config_response.dart';
import '../boot/config/config_controller.dart';
import '../login_registration/login/login_screen.dart';
import '../login_registration/registration/get_started_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseConsumerState<SplashScreen> {
  bool? _jailbroken;
  //final String splashLogo = 'assets/svg_files/first_cash_logo.svg';
  static const bool isHuawei = false;
  var appVersion = '';

  @override
  void initState() {
    super.initState();
    initSecurityCheck();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(configControllerProvider.notifier).getConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener(context);

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      ref.read(globalDataControllerProvider).appInfo =
          'App Version $appVersion Build $buildNumber';
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(BrandingDataController.instance.branding.logoBigBrand),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initAsyncListener(BuildContext context) {
    ref.listen<AsyncValue>(
      configControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          //EasyLoading.show();
        } else if (currentState.hasError) {
          //EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          //EasyLoading.dismiss();
          log.info(
              'Rooted? : ${_jailbroken == null ? "Unknown" : _jailbroken! ? "YES" : "NO"}');

          if (kReleaseMode && (_jailbroken ?? false)) {
            Loading.showSecurityDialog();
          } else {
            try {

              if (currentState.value != null) {
                final data = currentState.value as ConfigResponse;
                final serviceInfo = data.serverConfig?.serviceInfo;
                final clientConfig = data.clientConfig;

                if (!serviceInfo!.isServiceAvailable! ?? false) {
                  final notificationMessage = serviceInfo
                      ?.notificationMessageEn ??
                      'Under Maintenance'; // TODO: handle the message by app localization
                  Loading.showMaintenanceDialog(notificationMessage);
                  return;
                }

                if (clientConfig?.blackListed ?? false) {
                  startForceUpdateFlow(clientConfig,context);
                  return;
                }

                if (clientConfig?.forceUpdateEnabled ?? false) {
                  startForceUpdateFlow(clientConfig, context);
                  return;
                }

                startNormalFlow(context);
              }
            }catch(e){
            }
          }
        }
      },
    );
  }

  void startForceUpdateFlow(ClientConfig? clientConfig, BuildContext context) {

    final applicationId = ref.read(envReaderProvider).getApplicationId();

    final huaweiUrl = 'https://play.google.com/store/apps/details?id=$applicationId';
    final androidUrl = 'market://details?id=$applicationId';
    final appleUrl = 'https://apps.apple.com/app/id$applicationId';

    final updateUrl = Platform.isAndroid
        ? isHuawei
            ? huaweiUrl
            : androidUrl
        : appleUrl;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomForceUpdateDialog(updateUrl),
        ),
      );

  }

  void startNormalFlow(BuildContext context) {

    Timer(const Duration(seconds: 3), () async {
      final isLoggedIn =
          ref.read(localPrefProvider).getBool(PrefKeys.keyIsUserLoggedIn);
      if (isLoggedIn != null && isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetStartedScreen()),
        );
      }
    });

  }

  Future<void> initSecurityCheck() async {
    bool jailbroken;
    bool developerMode;
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      //_developerMode = developerMode;
    });
  }
}
