import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../base/base_consumer_state.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/di/feature_details_singleton.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_feature_bill_block_widget.dart';
import '../../../ui/custom_widgets/custom_feature_block_widget.dart';
import '../../../ui/shimmer_widgets/shimmer_home_grid_widget.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/feature_details_keys.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../dynamic_utility/du_core/api/du_detail/du_detail_controller.dart';
import '../../dynamic_utility/du_service_list/du_service_controller.dart';
import '../navigation/navigation_controller.dart';
import 'banner_list_controller.dart';
import 'feature_list_controller.dart';


class RedHomeScreen extends ConsumerStatefulWidget {
  const RedHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RedHomeScreen> createState() => _RedHomeScreenState();
}

class _RedHomeScreenState extends BaseConsumerState<RedHomeScreen> {

  List featureList = [];
  List updatedFeatureList = [];
  List bannerList = [];
  List serviceList = [];

  double latitude = 0.0;
  double longitude = 0.0;

  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(navigationControllerProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.watch(featureListControllerProvider).whenData((value) {
      featureList = value.features ?? [];
    });

    ref.watch(bannerListControllerProvider).whenData((value) {
      bannerList = value.bannerList ?? [];
    });

    if(ref.read(flavorProvider).name != AppConstants.userTypeDsr) {
      ref.watch(duServiceControllerProvider).whenData((value) {
        serviceList = value.services?? [];
      });
    }

    final isIosHiddenFeatureEnabled = ref.read(localPrefProvider).getBool(PrefKeys.keyHiddenFeatureIos) ?? false;
    processFeatureList(isIosHiddenFeatureEnabled);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: DimenSizes.dimen_200),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: DimenSizes.dimen_10),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_20, DimenSizes.dimen_10, DimenSizes.dimen_0, DimenSizes.dimen_0),
                      alignment: Alignment.topLeft,
                      child: CustomCommonTextWidget(
                        text: "main_services".tr(),
                        style: CommonTextStyle.regular_18,
                        color: dashBoardTitle ,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: featureList.isEmpty ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Column(
                          children: const [
                            ShimmerHomeGridWidget(),
                            ShimmerHomeGridWidget(),
                          ],
                        ),
                      ) :
                      GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(DimenSizes.dimen_5),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: .80,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10
                        ),
                        itemCount: featureList[0].featureList?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final featureCode = featureList[0].featureList?[index].featureCode;
                          return CustomFeatureBlockWidget(
                            iconUrl: "${featureList.first.featureList?[index].imageUrl}",
                            text: "${featureList.first.featureList?[index].featureTitle}",
                            isActive: featureList.first.featureList?[index].isActive ?? true,
                            networkSvgImage: true,
                            onPressed: () {
                              ref.read(navigationControllerProvider.notifier).navigateTo(featureCode);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              (ref.read(flavorProvider).name != AppConstants.userTypeDsr &&
                  ref.read(flavorProvider).name != AppConstants.userTypeMerchant) ?
              Column(
                children: [
                  Divider(
                    color: commonBackgroundColor,
                    height: DimenSizes.dimen_14,
                    thickness: DimenSizes.dimen_6,
                    indent: DimenSizes.dimen_0,
                    endIndent: DimenSizes.dimen_0,
                  ),
                  const SizedBox(height: DimenSizes.dimen_10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_20, DimenSizes.dimen_10, DimenSizes.dimen_0, DimenSizes.dimen_0),
                    alignment: Alignment.topLeft,
                    child: CustomCommonTextWidget(
                      text: "bill_payments".tr(),
                      style: CommonTextStyle.regular_18,
                      color: dashBoardTitle ,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: serviceList.isEmpty ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child:const ShimmerHomeGridWidget(),
                    ) :
                    GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(DimenSizes.dimen_5),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: .70,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10
                      ),
                      itemCount: serviceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final featureCode = serviceList[index].featureCode;
                        return CustomFeatureBillBlockWidget(
                          iconUrl: "${serviceList[index].iconUrl}",
                          text: "${serviceList[index].featureTitle}",
                          isActive: serviceList[index].isEnabled ?? true,
                          networkSvgImage: false,
                          onPressed: () {

                            ref.read(duDetailControllerProvider.notifier).utilityDetail(featureCode);

                          },
                        );
                      },
                    ),
                  ),
                ],
              ) : const SizedBox.shrink(),
              Divider(
                color: commonBackgroundColor ,
                height: DimenSizes.dimen_14,
                thickness: DimenSizes.dimen_6,
                indent: DimenSizes.dimen_0,
                endIndent: DimenSizes.dimen_0,
              ),
              bannerList.isEmpty ? const SizedBox.shrink() :
              CarouselSlider(
                options: CarouselOptions(
                  initialPage: 0,
                  height: 200.0,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  onPageChanged: (index, reason) {

                  },
                ),
                items: bannerList.map((imageUrl) {
                  return Container(
                      padding: const EdgeInsets.all(DimenSizes.dimen_20),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: FadeInImage.assetNetwork(
                        width: MediaQuery.of(context).size.width,
                        placeholder: 'assets/images/placeholder_waiting.png',
                        image: imageUrl.imageSource,
                        placeholderFit: BoxFit.none,
                        fit: BoxFit.fill,
                      )
                  );
                }).toList(),
              ),
            ],
          ),
        )
    );
  }

  void processFeatureList(bool isHiddenFeatureEnabled) {
    if (isHiddenFeatureEnabled && featureList.isNotEmpty) {
      featureList.first.featureList.removeWhere(
              (element) => element.featureCode == FeatureDetailsKeys.addMoney);
    }
  }
}