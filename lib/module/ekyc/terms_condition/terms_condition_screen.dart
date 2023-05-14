import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../base/base_consumer_state.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimens/dimensions.dart';
import '../ekyc_home/ekyc_home_screen.dart';

class TermsConditionScreen extends ConsumerStatefulWidget {
  //final String appBarTitle;
  //final String webViewLink;
  const TermsConditionScreen({Key? key}) : super(key: key);
  // const TermsConditionScreen( {super.key, required this.webViewLink, required this.appBarTitle});


  @override
  ConsumerState<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends BaseConsumerState<TermsConditionScreen> {

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
        Uri.parse(AppConstants.appTermsAndConditionUrlEn),
      );
  }


  @override
  Widget build(BuildContext context) {
    final nextButton = SafeNextButtonWidget(
        text: "next".tr(),
        onPressedFunction: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EkycHomeScreen()),
          );
        }
    );

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'terms_Of_use'),
      backgroundColor: Colors.white,
      bottomSheet: Container(
          child: nextButton
      ),
      body:  Padding(
          padding: DimenEdgeInset.marginLTRB_terms_of_use ,
            child: Stack(
                  children: [
                    WebViewWidget(
                        controller: controller
                    ),
                    if (loadingPercentage < 100)
                      LinearProgressIndicator(
                          value: loadingPercentage / 100.0,

                      ),
                  ]
              ),
          ),
    );
  }
}
