import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_consumer_state.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../core/flavor/flavors.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../register_input/register_input_screen.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends BaseConsumerState<GetStartedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final isAndroidHiddenFeatureEnabled = ref.read(localPrefProvider).getBool(PrefKeys.keyHiddenFeatureAndroid) ?? false;

      if (isAndroidHiddenFeatureEnabled) {
        DialogUtils.showCustomDialog(context,
            title: 'Permission Needed',
            okBtnFunction: () => requestContactPermission());
      } else {
        FlutterContacts.requestPermission();
      }
    });
  }

  requestContactPermission() {
    Navigator.pop(context);
    FlutterContacts.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final getStartedButton = SafeNextButtonWidget(
        text: "get_started",
        onPressedFunction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegisterInputScreen()),
          );
        });

    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Container(child: getStartedButton),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: DimenSizes.dimen_120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(BrandingDataController.instance.branding.logoBigBrand),
                    Container(
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 4.0),
                      margin:  const EdgeInsets.fromLTRB(
                          AppDimen.appMarginHorizontal,
                          DimenSizes.dimen_100,
                          AppDimen.appMarginHorizontal,
                          DimenSizes.dimen_0),
                      child: CustomCommonTextWidget(
                        text: "welcome_to_firstCash".tr(),
                        style: CommonTextStyle.regular_28,
                        color: BrandingDataController.instance.branding.colors.primaryColor,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(
                          AppDimen.appMarginHorizontal,
                          DimenSizes.dimen_16,
                          AppDimen.appMarginHorizontal,
                          DimenSizes.dimen_0),
                      child: CustomCommonTextWidget(
                          text: "get_started_text".tr(),
                          style: CommonTextStyle.regular_16,
                          color: colorPrimaryText,
                          textAlign: TextAlign.center,
                          shouldShowMultipleLine: true),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }


}
