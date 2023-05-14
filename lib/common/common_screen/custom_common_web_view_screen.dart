import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';

class CustomCommonWebViewScreen extends StatefulWidget {
  final String appBarTitle;
  final String webViewLink;

  const CustomCommonWebViewScreen(
      {super.key, required this.webViewLink, required this.appBarTitle});

  @override
  State<CustomCommonWebViewScreen> createState() =>
      _CustomCommonWebViewScreenState();
}

class _CustomCommonWebViewScreenState extends State<CustomCommonWebViewScreen> {

  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    loadWebView();
  }

  loadWebView() {
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }))
      ..loadRequest(
        Uri.parse(widget.webViewLink),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomCommonAppBarWidget(appBarTitle: widget.appBarTitle),
        body: Stack(
            children: [
              WebViewWidget(
                  controller: controller
              ),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                    value: loadingPercentage / 100.0
                ),
            ]
        ),
    );
  }
}
