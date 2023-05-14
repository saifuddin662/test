import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';

class CustomCommonAppBarWidget extends StatelessWidget implements PreferredSizeWidget{

  final String appBarTitle;
  final bool automaticallyImplyLeading;

  const CustomCommonAppBarWidget({
    super.key,
    required this.appBarTitle,
    this.automaticallyImplyLeading = true,

  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: automaticallyImplyLeading == true ? IconButton(
        color: BrandingDataController.instance.branding.colors.primaryColor,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ) : null,
      backgroundColor: BrandingDataController.instance.branding.colors.primaryColorLight,
      title: Center(
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.only(right: automaticallyImplyLeading == true ? 50.0 : 0.0),
              child: CustomCommonTextWidget(
                      text:  appBarTitle.tr(),
                      style: CommonTextStyle.bold_16,
                      color: BrandingDataController.instance.branding.colors.primaryColor,
              ),
          ),
        ),
      ),
    );
  }
}
