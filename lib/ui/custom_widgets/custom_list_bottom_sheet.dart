import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/model/common_list_bottom_sheet_model.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';


class CustomListBottomSheet extends StatelessWidget {
  final String title;
  final List<CommonListBottomSheetModel> models;
  final bool showImage;
  final Function(int) blockFunction;

  const CustomListBottomSheet({super.key,
    required this.title,
    required this.models,
    required this.showImage,
    required this.blockFunction
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: BrandingDataController.instance.branding.colors.primaryColorLight,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DimenSizes.dimen_10),
            topRight: Radius.circular(DimenSizes.dimen_10)
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: DimenSizes.dimen_20,
                left: DimenSizes.dimen_20,
                right: DimenSizes.dimen_20,
                bottom: DimenSizes.dimen_12),
            child: CustomCommonTextWidget(
              text:  title,
              style: CommonTextStyle.bold_16,
              color: greyColor ,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: DimenSizes.dimen_20,
                right: DimenSizes.dimen_20,
                bottom: DimenSizes.dimen_20
            ),
            child: Divider(
              color: greyColor,
              height: 1.0,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(models.length, (index) =>
                Container(
                    height: DimenSizes.dimen_60,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: DimenSizes.dimen_20,
                        right: DimenSizes.dimen_20,
                        bottom: DimenSizes.dimen_12
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      border: Border.all(
                        color: Colors.black54,
                        width: 1.0
                      )
                    ),
                    child: (showImage == true) ?
                    showItemWithLeading(index, context) :
                    showItem(index, context)
                ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(DimenSizes.dimen_5),
          )
        ],
      )
    );
  }

  RoundedRectangleBorder itemShape(){
    return RoundedRectangleBorder(
      side: BorderSide(
          color: greyColor,
          width: DimenSizes.dimen_half
      ),
      borderRadius: BorderRadius.circular(DimenSizes.dimen_0),
    );
  }

  IconButton trailingIcon(int index, BuildContext context){
    return IconButton(
      onPressed: (){
        Navigator.pop(context);
        blockFunction(index);
      },
      color: BrandingDataController.instance.branding.colors.primaryColor,
      icon: const Icon(Icons.arrow_forward),
    );
  }

  void onTapAction(int index, BuildContext context){
    Navigator.pop(context);
    blockFunction(index);
  }

  Text itemTitle(int index){
    return Text(
        "${models[index].name}",
        style: TextStyle(color: greyColor)
    );


  }

  ListTile showItemWithLeading(int index, BuildContext context){
    return ListTile(
      contentPadding: const EdgeInsets.only(left: DimenSizes.dimen_10),
      shape: itemShape(),
      leading: (models[index].icon == null)
          ? const CircleAvatar(child: Icon(Icons.person)) :
      SvgPicture.asset(models[index].icon!,
          height: DimenSizes.dimen_40,
          width: DimenSizes.dimen_40
      ),
      trailing: trailingIcon(index, context),
      title: itemTitle(index),
      onTap: () {
        onTapAction(index, context);
      },
    );
  }

  ListTile showItem(int index, BuildContext context){
    return ListTile(
      contentPadding: const EdgeInsets.only(left: DimenSizes.dimen_10),
      shape: itemShape(),
      trailing: trailingIcon(index, context),
      title: itemTitle(index),
      onTap: () {
        onTapAction(index, context);
      },
    );
  }
}