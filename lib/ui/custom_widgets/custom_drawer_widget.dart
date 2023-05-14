import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/base_consumer_state.dart';
import '../../common/common_screen/custom_common_web_view_screen.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/singleton_provider.dart';
import '../../core/flavor/flavor_provider.dart';
import '../../module/dashboard/change_pin/change_pin_screen.dart';
import '../../module/dashboard/home/api/model/feature_list_request.dart';
import '../../module/dashboard/home/feature_list_controller.dart';
import '../../module/dashboard/my_qr_code/my_qr_code_screen.dart';
import '../../module/login_registration/login/login_screen.dart';
import '../../utils/Colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import '../custom_dialogs/delete_account_dialog.dart';
import 'custom_common_text_widget.dart';
import 'custom_localization_toggle_widget.dart';


class CustomDrawerWidget extends ConsumerStatefulWidget {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends BaseConsumerState<CustomDrawerWidget> {
  @override
  Widget build(BuildContext context) {

    //FeatureListRequest featureListRequest = FeatureListRequest(ref.read(flavorProvider).name); // todo shaj userType XXX
    FeatureListRequest featureListRequest = FeatureListRequest('CUSTOMER');
    final userName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName);
    final userWalletNo = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);
    final isDeleteAccountEnabled = ref.read(localPrefProvider).getBool(PrefKeys.keyHiddenFeatureIos) ?? false;

    ref.watch(localeStateProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(DimenSizes.dimen_20)),
      child: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: BrandingDataController.instance.branding.colors.primaryColor),
                  accountName: CustomCommonTextWidget(
                    text:   userName.toString(),
                    style: CommonTextStyle.bold_14,
                    color: Colors.white,
                  ),
                  accountEmail: Row(
                    children: [
                      CustomCommonTextWidget(
                        text:  userWalletNo.toString(),
                        style: CommonTextStyle.bold_14,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 5.0),

                      CustomCommonTextWidget(
                        text:  'wallet'.tr(),
                        style: CommonTextStyle.regular_14,
                        color: Colors.white,
                        textAlign: TextAlign.right,
                      ),

                    ],
                  ),
                  currentAccountPicture: SvgPicture.asset(
                      'assets/svg_files/ic_first_cash_logo_white.svg'),
                  currentAccountPictureSize: const Size.square(94),

                ),

                const SizedBox(height: 8.0),

                CustomLocalizationToggle(
                  textColor: Colors.white,
                  values: const ['English', 'বাংলা'],
                  buttonColor: BrandingDataController.instance.branding.colors.primaryColor,
                  callbackAction: () {
                    ref.read(featureListControllerProvider.notifier).getFeatureList(featureListRequest);
                    ref.watch(localeStateProvider.notifier).state++;
                  },
                ),
                ref.read(flavorProvider).name != AppConstants.userTypeDsr ?
                ListTile(
                  dense: true,
                  title: CustomCommonTextWidget(
                    text:  'my_qr_code'.tr(),
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                  ),

                  leading:  Icon(
                    Icons.qr_code,
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                    size: AppDimen.drawerIconSize,
                  ),
                  minLeadingWidth: 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyQrCodeScreen()),
                    );
                  },
                ) : const SizedBox.shrink(),
                ListTile(
                  dense: true,
                  title: CustomCommonTextWidget(
                    text:  'change_pin'.tr(),
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                  ),
                  leading: Icon(
                    Icons.change_circle_outlined,
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                    size: AppDimen.drawerIconSize,
                  ),
                  minLeadingWidth: 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePinScreen()),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  title: CustomCommonTextWidget(
                    text:  'about_firstCash'.tr(),
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                  ),
                  leading:  Icon(
                    Icons.account_balance_outlined,
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                    size: AppDimen.drawerIconSize,
                  ),
                  minLeadingWidth: 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomCommonWebViewScreen(
                                appBarTitle: "about_firstCash",
                                webViewLink: AppConstants.appAboutUsUrl,
                              )),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  title: CustomCommonTextWidget(
                    text:  'sign_out'.tr(),
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                    size: AppDimen.drawerIconSize,
                  ),
                  minLeadingWidth: 2,
                  onTap: () {
                    ref.read(localPrefProvider).setString(PrefKeys.keyJwt, "");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                isDeleteAccountEnabled
                    ? ListTile(
                        dense: true,
                        title: CustomCommonTextWidget(
                          text: 'Delete Account',
                          style: CommonTextStyle.regular_14,
                          color: colorPrimaryText,
                        ),
                        leading: SvgPicture.asset(
                          'assets/svg_files/ic_trash.svg',
                          width: AppDimen.drawerIconSize,
                          height: AppDimen.drawerIconSize,
                        ),
                        minLeadingWidth: 2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DeleteAccountDialog()),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(DimenSizes.dimen_20),
                margin: const EdgeInsets.all(DimenSizes.dimen_5),
                child: Text(ref.read(globalDataControllerProvider).appInfo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
