import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:red_cash_dfs_flutter/module/dashboard/qr_code_scanner/qr_code_scanner_screen.dart';
import 'package:red_cash_dfs_flutter/module/dashboard/transaction_list/transaction_list_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../core/di/core_providers.dart';
import '../../core/firebase/crashlytics/crashlytics.dart';
import '../../core/flavor/flavor_provider.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_dashboard_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_drawer_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/pref_keys.dart';
import '../dynamic_utility/du_service_list/du_service_controller.dart';
import 'home/api/model/banner_list_request.dart';
import 'home/api/model/feature_list_request.dart';
import 'home/banner_list_controller.dart';
import 'home/feature_list_controller.dart';
import 'home/home_screen.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardState();
}

final indexProvider = StateProvider<int>((ref) {
  return 0;
});

class _DashboardState extends BaseConsumerState<DashboardScreen> {
  double latitude = 0.0;
  double longitude = 0.0;

  final screens = [
    const HomeScreen(),
    const SizedBox(),
    const TransactionListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //FeatureListRequest featureListRequest = FeatureListRequest(ref.read(flavorProvider).name); // todo shaj userType XXX
      FeatureListRequest featureListRequest = FeatureListRequest('CUSTOMER');
      //BannerListRequest bannerListRequest = BannerListRequest(ref.read(flavorProvider).name); // todo shaj userType XXX
      BannerListRequest bannerListRequest = BannerListRequest('CUSTOMER');
      ref.read(featureListControllerProvider.notifier).getFeatureList(featureListRequest);
      ref.read(bannerListControllerProvider.notifier).getBanners(bannerListRequest);
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
      if(ref.read(flavorProvider).name != AppConstants.userTypeDsr &&
          ref.read(flavorProvider).name != AppConstants.userTypeMerchant) {
        ref.read(duServiceControllerProvider.notifier).duService();
      }
      _setCrashlyticsUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);
    ref.watch(localeStateProvider);
    return Scaffold(
        appBar: ref.watch(indexProvider) == 0 ? PreferredSize(
            preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height * 0.12
            ),
            child: const CustomDashboardAppBarWidget()
        ) : null,
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawerWidget(),
        body: Stack(
          children: [
            screens[ref.watch(indexProvider)]
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: BrandingDataController.instance.branding.colors.primaryColor,
          onPressed: () {
            if(ref.read(flavorProvider).name != AppConstants.userTypeDsr) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QrCodeScannerScreen()),
              );
            }
          },
          child: SvgPicture.asset(
            'assets/svg_files/ic_qr_code.svg',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Theme(
          data: ThemeData(
              splashColor: transparentColor,
              highlightColor: transparentColor
          ),
          child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 8.0,
              clipBehavior: Clip.antiAlias,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: BottomNavigationBar(
                  backgroundColor: bottomNavBarBackgroundColor,
                  currentIndex: ref.watch(indexProvider),
                  selectedItemColor: BrandingDataController.instance.branding.colors.primaryColor,
                  unselectedFontSize: 12,

                  selectedIconTheme: IconThemeData(color: BrandingDataController.instance.branding.colors.primaryColor, opacity: 1.0, size: 30.0),
                  unselectedIconTheme: IconThemeData(color: unselectedFontColor, opacity: 1.0, size: 30.0),
                  onTap: (index) {
                    (index != 1) ? ref.read(indexProvider.notifier).update((_) => index) : null;
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/svg_files/ic_home.svg',
                          colorFilter: ref.watch(indexProvider) == 0 ?
                          ColorFilter.mode(BrandingDataController.instance.branding.colors.primaryColor, BlendMode.srcIn) : null,
                        ),
                        label: 'home'.tr()
                    ),
                    BottomNavigationBarItem(icon: const Icon(null), label: 'scan_qr'.tr()),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/svg_files/ic_transaction.svg',
                          colorFilter: ref.watch(indexProvider) == 2 ?
                          ColorFilter.mode(BrandingDataController.instance.branding.colors.primaryColor, BlendMode.srcIn) : null,
                        ),
                        label: 'transaction'.tr()
                    )
                  ],
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              )
          ),
        )
    );
  }

  void _setCrashlyticsUser() async {

    final isSet = ref.read(localPrefProvider).getBool(PrefKeys.keyIsCrashlyticsSet) ?? false;

    if (!isSet) {
      final walletNo = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);
      final userName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName);
      final fUser = '$walletNo-$userName';
      final crashlytics = ref.read(crashlyticsProvider);
      await crashlytics.setUser(fUser);
      ref.read(localPrefProvider).setBool(PrefKeys.keyIsCrashlyticsSet, true);
      log.info('SET CrashlyticsUser ----> $fUser');
    }
  }

}