import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../../utils//extensions/extension_text_style.dart';
import '../configs/branding_data_controller.dart';
import 'custom_amount_suggestion_widget.dart';
import 'custom_common_feature_top_item_widget.dart';
import 'custom_common_inputfield_widget.dart';
import 'custom_common_text_widget.dart';


class CustomCommonEnterAmountWidget extends StatelessWidget {
  final List<int> amountList ;
  final String imageUrl;
  final String username;
  final String currentBalance;
  final TextEditingController amountController;
  final bool networkSvgImage;

  const CustomCommonEnterAmountWidget({
    super.key,
    this.amountList = const [50, 100, 200, 500, 1000, 2000],
    required this.imageUrl,
    required this.username,
    required this.currentBalance,
    required this.amountController,
    this.networkSvgImage = true
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimen.appMarginHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomCommonFeatureTopItemWidget(
              networkSvgImage: networkSvgImage,
              iconUrl: imageUrl,
              title: username,
            ),
            const SizedBox(height: DimenSizes.dimen_40),
            Container(
              alignment: Alignment.center,
              child: CustomCommonTextWidget(
                    text: "${"firstCash_balance:".tr()}৳$currentBalance",
                    style: CommonTextStyle.regular_14,
                    color: eclipse ,
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_20),
            IntrinsicWidth(
              child: CustomCommonInputFieldWidget(
                obscureText: false,
                scrollPadding: const EdgeInsets.all(0.0),
                controller: amountController,
                keyboardType: TextInputType.number,
                cursorColor: BrandingDataController.instance.branding.colors.primaryColor,
                textAlign: TextAlign.center,
                style: FontStyle.l_48_regular(color: BrandingDataController.instance.branding.colors.primaryColor),
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Container(
                    padding: (Platform.isIOS) ? const EdgeInsets.only(left: DimenSizes.dimen_10, top : DimenSizes.dimen_0)
                        : const EdgeInsets.only(left: DimenSizes.dimen_10, top: DimenSizes.dimen_10),
                    child: CustomCommonTextWidget(
                            text: '৳',
                            style: CommonTextStyle.regular_48,
                            color: BrandingDataController.instance.branding.colors.primaryColor ,
                          ),

                  ),
                  hintStyle: TextStyle(color: BrandingDataController.instance.branding.colors.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_50),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 11/5
              ),
              shrinkWrap: true,
              itemCount: amountList.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomAmountSuggestionWidget(
                  amount: amountList[index],
                  suggestionAmount: amountList[index],
                  actionChipFunction: () {
                    amountController.text = amountList[index].toString();
                    amountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: amountController.text.length)
                    );
                    // _selectedAmount(amountList[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}