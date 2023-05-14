import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/model/common_list_bottom_sheet_model.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/extensions/extension_rounded_rectangle_border.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/styles.dart';
import 'add_money_amount_screen.dart';
import 'add_money_card_screen.dart';

/// Created by Md. Awon-Uz-Zaman on 25/February/2023

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({
    Key? key
  }) : super(key: key);

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  List<CommonListBottomSheetModel> items = [
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_add_money_from_card.svg", name: "Card to FirstCash"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_add_money_from_bank.svg", name: "Bank to FirstCash"),
  ];

  late CommonListBottomSheetModel item;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar:  CustomCommonAppBarWidget(appBarTitle: featureDetailsSingleton.feature[FeatureDetailsKeys.addMoney]?.featureTitle ?? ""),
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppDimen.toolbarBottomGap),
              Padding(
                padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_20, DimenSizes.dimen_0, DimenSizes.dimen_20, DimenSizes.dimen_20),
                  child: CustomCommonTextWidget(
                    text:  "add_money_source".tr(),
                    style: CommonTextStyle.bold_16,
                    color: dashBoardTitle,
                  ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.only(left: DimenSizes.dimen_20, right: DimenSizes.dimen_20, bottom: DimenSizes.dimen_15),
                        shape: ShapeStyle.listItemShape(),
                        child: ListTile(
                            contentPadding: const EdgeInsets.only(left: DimenSizes.dimen_10, right: DimenSizes.dimen_10, bottom: DimenSizes.dimen_5, top: DimenSizes.dimen_5),
                            leading: SvgPicture.asset(items[index].icon ?? ""),
                            title: CustomCommonTextWidget(
                              text:   "${items[index].name}",
                              style: CommonTextStyle.regular_16,
                              color: dashBoardTitle,
                            ),
                            onTap: () {
                              if (items[index].name == "Card to FirstCash"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyCardScreen()));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyAmountScreen(type: "internetbank", featureIcon: items[index].icon ?? "")));
                              }
                            }),
                      );
                    },
                  )
              )
            ]
        )
    );
  }
}