import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/enum/user_type.dart';
import '../../core/di/core_providers.dart';
import '../../core/flavor/flavor_provider.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';


class CustomRedDashboardAppBarWidget extends ConsumerStatefulWidget {
  const CustomRedDashboardAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CustomRedDashboardAppBarWidget> createState() => _CustomRedDashboardAppBarWidgetState();

}

class _CustomRedDashboardAppBarWidgetState extends BaseConsumerState<CustomRedDashboardAppBarWidget> {

  bool isAnimation = false;
  bool isBalanceShown = false;
  bool isBalance = true;

  @override
  Widget build(BuildContext context) {
    ref.watch(localeStateProvider);
    final userName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName);
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);
    final userType = ref.read(flavorProvider).name;
    var userTitle = "$userName";

    if (userType != UserType.CUSTOMER.name) {
      userTitle = "$userName ($userType)";
    } else {
      userTitle = "$userName";
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: BrandingDataController.instance.branding.colors.primaryColor,
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            // Image.asset('assets/images/bg_dashboard_app_bar.png',
            //     fit: BoxFit.cover,
            //     color: BrandingDataController.instance.branding.colors.primaryColor,
            //     width: MediaQuery.of(context).size.width
            // ),

            Padding(
                padding: const EdgeInsets.all(DimenSizes.dimen_15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(DimenSizes.dimen_5),
                                child: SvgPicture.asset('assets/svg_files/ic_drawer.svg'),
                              ),
                            ),
                            const SizedBox(width: DimenSizes.dimen_10),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: DimenSizes.dimen_20,
                              width: DimenSizes.dimen_200,
                              child: CustomCommonTextWidget(
                                text: "Hi, $userTitle",
                                style: CommonTextStyle.regular_16,
                                color: bottomNavBarBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset('assets/svg_files/ic_first_cash_logo_white.svg',
                            height: DimenSizes.dimen_25,
                            width: DimenSizes.dimen_60
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: isBalance ?  () {
                              ref.read(checkBalanceControllerProvider.notifier).checkBalance();
                              animate();
                            } : null,
                            child: Container(
                                width: DimenSizes.dimen_160,
                                height: DimenSizes.dimen_25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(DimenSizes.dimen_50)
                                ),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedOpacity(
                                          opacity: isBalanceShown ? 1 : 0,
                                          duration: const Duration(milliseconds: 500),
                                          child: CustomCommonTextWidget(
                                            text: '৳ $currentBalance',
                                            style: CommonTextStyle.bold_14,
                                            color: BrandingDataController.instance.branding.colors.primaryColor,
                                          )
                                      ),
                                      AnimatedOpacity(
                                        opacity: isBalance ? 1 : 0,
                                        duration: const Duration(milliseconds: 300),
                                        child: CustomCommonTextWidget(
                                          text: "check_balance".tr(),
                                          style: CommonTextStyle.bold_14,
                                          color: BrandingDataController.instance.branding.colors.primaryColor,
                                        ),
                                      ),
                                      AnimatedPositioned(
                                          duration: const Duration(milliseconds: 1100),
                                          left: isAnimation == false ? 5 : 135,
                                          curve: Curves.fastOutSlowIn,
                                          child: Container(
                                              height: DimenSizes.dimen_20,
                                              width: DimenSizes.dimen_20,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: BrandingDataController.instance.branding.colors.primaryColor,
                                                  shape: BoxShape.circle
                                              ),
                                              child: FittedBox(
                                                child: CustomCommonTextWidget(
                                                  text: '৳',
                                                  style: CommonTextStyle.regular_14,
                                                  color: bottomNavBarBackgroundColor ,
                                                ),
                                              )
                                          )
                                      )
                                    ]
                                )
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.only(right: DimenSizes.dimen_5),
                            alignment: Alignment.bottomRight,
                            child: SvgPicture.asset('assets/svg_files/ic_notification.svg')
                        ),
                      ],
                    )
                  ],
                )
            )
          ],
        ) ,
      ),
    );
  }

  void animate() async {
    isAnimation = true;
    isBalance = false;
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 800),
            () => setState(() => isBalanceShown = true));
    await Future.delayed(
        const Duration(seconds: 3), () => setState(() => isBalanceShown = false));
    await Future.delayed(const Duration(milliseconds: 200),
            () => setState(() => isAnimation = false));
    await Future.delayed(
        const Duration(milliseconds: 800), () => setState(() => isBalance = true));
  }

}
