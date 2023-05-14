import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/toasts.dart';
import '../../core/context_holder.dart';
import '../../module/login_registration/registration/get_started_screen.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import '../custom_widgets/custom_common_text_widget.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BrandingDataController.instance.branding.colors.primaryColorLight,
        body: Center(
          child: SizedBox(
            height: 300.0,

            child: AlertDialog(

              title: CustomCommonTextWidget(
                text: "Delete Account",
                style: CommonTextStyle.bold_16,
                color: colorPrimaryText,
                textAlign: TextAlign.center,
              ),

              content: Column(
                children: [
                  const SizedBox(height: DimenSizes.dimen_15),
                  const CustomCommonTextWidget(
                    text: "Are you sure you want to delete your account?",
                    style: CommonTextStyle.regular_14,
                    color: Colors.redAccent,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DimenSizes.dimen_15),
                  Container(
                    child: CustomCommonTextWidget(
                      text: "If yes, then our agent will contact you",
                      textAlign: TextAlign.center,
                      style: CommonTextStyle.regular_14,
                      color: suvaGray,
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: CustomCommonTextWidget(
                    text: "Cancel",
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context).popUntil((route) => false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: CustomCommonTextWidget(
                    text: "Proceed",
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                  ),
                  onPressed: () async {
                    Toasts.showSuccessToast('Delete Request Submitted!');
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushReplacement(
                      ContextHolder.navKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) => const GetStartedScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
