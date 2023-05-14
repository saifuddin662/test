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

/// Created by Md. Awon-Uz-Zaman on 25/February/2023

class AddMoneyCardScreen extends StatefulWidget {

  const AddMoneyCardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMoneyCardScreen> createState() => _AddMoneyCardScreenState();
}

class _AddMoneyCardScreenState extends State<AddMoneyCardScreen> {
  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  List<CommonListBottomSheetModel> items = [
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_visa.svg", name: "Visa"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_mastercard.svg", name: "MasterCard"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_amex.svg", name: "Amex"),
  ];

  late CommonListBottomSheetModel item;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featureTitle = featureDetailsSingleton.feature[FeatureDetailsKeys.addMoney]?.featureTitle;

    return Scaffold(
        appBar: CustomCommonAppBarWidget(appBarTitle: featureTitle ?? ""),
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppDimen.toolbarBottomGap),
              Padding(
                padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_20, DimenSizes.dimen_0, DimenSizes.dimen_20, DimenSizes.dimen_20),
                child: CustomCommonTextWidget(
                  text:  "card_source".tr(),
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
                            leading: SvgPicture.asset(items[index].icon ?? "", height: DimenSizes.dimen_30, width: DimenSizes.dimen_30),
                            title: CustomCommonTextWidget(
                              text:   "${items[index].name}",
                              style: CommonTextStyle.regular_16,
                              color: dashBoardTitle,
                            ),
                            onTap: () {
                              if(items[index].name == "MasterCard"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyAmountScreen(type: "mastercard", featureIcon: items[index].icon ?? "")));
                              } else if(items[index].name == "Visa"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyAmountScreen(type: "visacard", featureIcon: items[index].icon ?? "")));
                              }else if(items[index].name == "Amex"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyAmountScreen(type: "amexcard", featureIcon: items[index].icon ?? "")));
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