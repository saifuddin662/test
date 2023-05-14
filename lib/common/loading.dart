import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets_provider.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 17,January,2023.

class Loading {
  Loading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 35.0
      ..lineWidth = 1.0
      ..radius = 10.0
      ..progressColor = Colors.transparent
      ..backgroundColor = Colors.transparent
      ..textColor = Colors.black.withOpacity(0.7)
      ..maskColor = Colors.black.withOpacity(0.6)
      ..indicatorColor = Colors.transparent
      ..userInteractions = false
      ..dismissOnTap = false
      ..contentPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16)
      ..maskType = EasyLoadingMaskType.custom
      ..boxShadow = <BoxShadow>[]
      ..indicatorWidget = const CustomLoadingWidget();
  }

  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.indicatorWidget = const CustomLoadingWidget();
    EasyLoading.show(status: text ?? 'loading...');
  }

  static void showMaintenanceDialog([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.indicatorWidget = const CustomMaintenanceWidget();
    EasyLoading.show(status: text ?? 'Under Maintenance...');
  }

  static void showSecurityDialog([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.indicatorWidget = const CustomSecurityWidget();
    EasyLoading.show(status: text ?? 'Phone is not Secured...');
  }

  static void toast(String text) {
    EasyLoading.showToast(text);
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();

    // Image.asset(AssetsProvider.gifPath('fc_loader'), gaplessPlayback: true, fit: BoxFit.fill)

    /*
    return Container(
      color: Colors.white,
      width: 100.0,
      height: 100.0,
      child: Lottie.asset(AssetsProvider.lottiePath('fc')),
    );
     */
  }
}

class CustomMaintenanceWidget extends StatelessWidget {
  const CustomMaintenanceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 150.0,
      height: 200.0,
      child: Lottie.asset(AssetsProvider.lottiePath('maintenance')),
    );
  }
}

class CustomSecurityWidget extends StatelessWidget {
  const CustomSecurityWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 150.0,
      height: 150.0,
      child: Lottie.asset(AssetsProvider.lottiePath('security')),
    );
  }
}
