import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:red_cash_dfs_flutter/core/di/core_providers.dart';
import 'package:red_cash_dfs_flutter/ui/configs/branding_data_controller.dart';
import 'package:red_cash_dfs_flutter/ui/configs/colors/core_colors.dart';
import 'package:red_cash_dfs_flutter/utils/primary_color_helper.dart';
import 'core/context_holder.dart';
import 'module/splash/splash_screen.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 07,May,2023.

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

class MainWidget extends ConsumerWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OverlaySupport.global(
        child: MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            navigatorKey: ContextHolder.navKey,
            scaffoldMessengerKey: snackBarKey,
            theme: ThemeData(
              fontFamily: BrandingDataController.instance.branding.fontFamily,
              primarySwatch: createPrimaryMaterialColor(BrandingDataController.instance.branding.colors.primaryColor),
              bottomAppBarTheme: const BottomAppBarTheme(color: Colors.transparent),
              bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
            ),
            builder: EasyLoading.init(),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false));
  }
}
