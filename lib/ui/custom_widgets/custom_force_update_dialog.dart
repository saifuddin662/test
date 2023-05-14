import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base/base_consumer_state.dart';
import '../../core/env/env_reader.dart';

class CustomForceUpdateDialog extends ConsumerStatefulWidget {

  final String updateUrl;
  const CustomForceUpdateDialog(this.updateUrl, {super.key});

  @override
  ConsumerState<CustomForceUpdateDialog> createState() =>
      _CustomForceUpdateDialogState();
}

class _CustomForceUpdateDialogState
    extends BaseConsumerState<CustomForceUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AlertDialog(
      title: Text('force_update_title'.tr()),
      content: Text('force_update_message'.tr()),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text('disagree'.tr()),
          onPressed: () {
            //Navigator.of(context).pop();
            //Navigator.of(context).popUntil((route) => false);

            exitApp();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text('update_now'.tr()),
          onPressed: () {
            String applicationId =
                ref.read(envReaderProvider).getApplicationId();
            if (Platform.isAndroid) {
              try {
                launchUrl(Uri.parse(widget.updateUrl));
              } catch (error) {
                launchUrl(Uri.parse(
                    "https://play.google.com/store/apps/details?id=$applicationId"));
              }
            } else if (Platform.isIOS) {
              launchUrl(Uri.parse(widget.updateUrl));
            }
          },
        ),
      ],
    ));
  }

  void exitApp() {
    if (Platform.isIOS) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        exit(0);
      });
    } else {
      //SystemNavigator.pop();
      Future.delayed(const Duration(milliseconds: 1000), () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      });
    }
  }
}
