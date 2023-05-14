import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/toasts.dart';
import '../../module/login_registration/login/login_screen.dart';
import '../../module/login_registration/registration/get_started_screen.dart';
import '../context_holder.dart';
import 'base/base_result.dart';
import 'enum/network_status.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 15,January,2023.

void safeApiCall<T>(BaseResult<T> result,
    {Function(bool isLoad)? onLoad,
    required Function(T? data) onSuccess,
    required Function(dynamic code, String message) onError}) async {
  onLoad != null ? onLoad(true) : doNothing();
  if (result.status == Status.SUCCESS) {
    onSuccess(result.data);
  } else {

    late var code;
    try {
      code = NetworkStatus.toCode(result.code);
    } catch(e) {
      code = result.code;
    }

    switch(code)
    {
      case NetworkStatus.success:
        debugPrint("--------------------------------> SUCCESS");
        break;
      case NetworkStatus.error:
        debugPrint("--------------------------------> ERROR");
        break;
      case NetworkStatus.loading:
        debugPrint("--------------------------------> LOADING");
        break;
      case NetworkStatus.noInternet:
        debugPrint("--------------------------------> NO_INTERNET");
        break;
      case NetworkStatus.sessionTimeout:
        Toasts.showErrorToast("session_timeout".tr());
        Navigator.pushAndRemoveUntil(ContextHolder.navKey.currentContext!,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false
        );
        debugPrint("--------------------------------> SESSION_TIMEOUT");
        break;
      case NetworkStatus.clearWallet:
        debugPrint("--------------------------------> CLEAR_WALLET");
        break;
      case NetworkStatus.otpExpired:
        debugPrint("--------------------------------> OTP_EXPIRED");
        break;
      case NetworkStatus.clearAndGotoStart:
        Toasts.showErrorToast("authorization_failed".tr());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.pushAndRemoveUntil(ContextHolder.navKey.currentContext!,
            MaterialPageRoute(builder: (context) => const GetStartedScreen()),
                (route) => false
        );
        debugPrint("--------------------------------> CLEAR_AND_GOTO_START");
        break;
      case NetworkStatus.nidAlreadyExist:
        debugPrint("--------------------------------> NID_ALREADY_EXIST");
        break;
      case NetworkStatus.networkError:
        debugPrint("--------------------------------> NETWORK_ERROR");
        break;
      case NetworkStatus.warning:
        debugPrint("--------------------------------> WARNING");
        break;
      case NetworkStatus.incorrectPin:
        debugPrint("--------------------------------> INCORRECT_PIN");
        break;
      default: {
        debugPrint("--------------------------------> UNKNOWN REASON, code -> $code");
      }
      break;
    }
    onError(result.code, result.message);
  }
  onLoad != null ? onLoad(false) : doNothing();
}

doNothing() {}
