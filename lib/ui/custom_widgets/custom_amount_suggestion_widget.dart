import 'package:flutter/material.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';

class CustomAmountSuggestionWidget extends StatelessWidget {
  final int amount;
  final int? suggestionAmount;
  final VoidCallback actionChipFunction;

  const CustomAmountSuggestionWidget({super.key,
    required this.amount,
    required this.suggestionAmount,
    required this.actionChipFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(DimenSizes.dimen_10),
      decoration: BoxDecoration(
        color: BrandingDataController.instance.branding.colors.primaryColorLight,
        borderRadius: const BorderRadius.all(Radius.circular(DimenSizes.dimen_20)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(1.1, 1.1),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(DimenSizes.dimen_20)),
          splashColor: Colors.blueGrey.withOpacity(0.2),
          onTap: actionChipFunction,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .20,
            width: MediaQuery.of(context).size.height * .20,
            child: Center(
              child: CustomCommonTextWidget(
                text:  "৳ $amount",
                style: CommonTextStyle.regular_14,
                color: BrandingDataController.instance.branding.colors.primaryColor,
                textAlign :  TextAlign.center,
          ),
            ),
          ),
        ),
      ),
    );
  }
}