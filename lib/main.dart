import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/ui/configs/colors/core_colors.dart';
import 'package:red_cash_dfs_flutter/ui/configs/colors/first_cash_colors.dart';
import 'package:red_cash_dfs_flutter/ui/configs/colors/red_cash_colors.dart';
import 'app.dart';
import 'core/bootstrap.dart';
import 'core/flavor/flavors.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 07,May,2023.

void mainApp(Flavor flavor) async {

  runApp(UncontrolledProviderScope(
      container: await bootstrap(flavor),
      child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('bn')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const MainWidget())));
}
