import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:red_cash_dfs_flutter/module/mobile_recharge/recharge_enter_amount_screen.dart';
import '../../common/model/common_list_bottom_sheet_model.dart';
import '../../common/toasts.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_contact_tile_widget.dart';
import '../../ui/custom_widgets/custom_list_bottom_sheet.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/extensions/extension_rounded_rectangle_border.dart';
import '../../utils/styles.dart';
import '../../utils/validation_utils.dart';

class MobileRechargeNumberScreen extends StatefulWidget {

  const MobileRechargeNumberScreen({
    Key? key
  }) : super(key: key);

  @override
  State<MobileRechargeNumberScreen> createState() => _MobileRechargeNumberScreenState();
}

class _MobileRechargeNumberScreenState extends State<MobileRechargeNumberScreen> {

  FeatureDetailsSingleton featureCodeSingleton = FeatureDetailsSingleton();
  List<Contact>? contacts;
  List<Contact>? filteredContacts;

  List<CommonListBottomSheetModel> operators = [
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_robi.svg", name: "Robi"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_airtel.svg", name: "Airtel"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_gp.svg", name: "Grameenphone"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_teletalk.svg", name: "Teletalk"),
    CommonListBottomSheetModel(icon: "assets/svg_files/ic_banglalink.svg", name: "Banglalink"),
  ];

  List<CommonListBottomSheetModel> simTypes = [];

  late CommonListBottomSheetModel operator;
  late CommonListBottomSheetModel simType;
  String userNumber = "";
  String userName = "";
  String typedNumber = "";
  bool isGP = false;

  @override
  void initState() {
    super.initState();
    getContact();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);

      if(contacts != null && contacts!.isNotEmpty){
        // contacts = ValidationUtils.getValidContacts(contacts!);
        filteredContacts = contacts;
        setState(() {});
      }
    }
  }

  void filterSearchResults(String text){
    List<Contact> dummyContacts = [];

    if (text.isEmpty) {
      dummyContacts = contacts!;
    } else {
      contacts?.forEach((userDetail) {
        if (userDetail.name.first.toLowerCase().contains(text.toLowerCase()) || userDetail.name.last.toLowerCase().contains(text.toLowerCase()) || userDetail.name.middle.toLowerCase().contains(text.toLowerCase()) || userDetail.phones.toString().contains(text)) {
          dummyContacts.add(userDetail);
        }
      });
    }

    setState(() {
      filteredContacts = dummyContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomCommonAppBarWidget(appBarTitle: 'mobile_recharge'),
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppDimen.toolbarBottomGap),
              Padding(
                padding: AppDimen.commonLeftRightPadding,
                child: CustomCommonInputFieldWidget(
                  obscureText: false,
                  scrollPadding: const EdgeInsets.all(0.0),
                  onChanged: (value) {
                    typedNumber = value;
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration(
                      labelText: 'search'.tr(),
                      suffixIcon: IconButton(
                        onPressed: (){
                          if(ValidationUtils.validateMobile(typedNumber)){
                            userName = getUsername(typedNumber);
                            numberFilter(typedNumber, context);
                          } else {
                            Toasts.showErrorToast("invalid_number".tr());
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        borderSide: BorderSide(color: BrandingDataController.instance.branding.colors.primaryColor, width: DimenSizes.dimen_half),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                      )
                  ),
                ),
              ),
              const SizedBox(height: DimenSizes.dimen_10),
              (contacts) == null
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                  child: ListView.builder(
                    itemCount: filteredContacts!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Uint8List? image = filteredContacts![index].photo;
                      String num = (filteredContacts![index].phones.isNotEmpty)
                          ? (filteredContacts![index].phones.first.number)
                          : "--";
                      return Card(
                        margin: AppDimen.contactListTextFieldMargin,
                        shape: ShapeStyle.listItemShape(),
                        child: CustomContactTileWidget(
                          contactItem: filteredContacts![index],
                          image: image,
                          num: num,
                          index: index,
                          onPressedFunction: () {
                            userName = "${filteredContacts![index].name.first} ${filteredContacts![index].name.middle} ${filteredContacts![index].name.last}";
                            if (filteredContacts![index].phones.length > 1) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: CustomCommonTextWidget(
                                      text: userName ,
                                      style: CommonTextStyle.regular_14,
                                      color: colorPrimaryText,
                                    ),
                                      content: alertDialogContainer(filteredContacts![index].phones),
                                    );
                                  });
                            } else {
                              numberFilter(filteredContacts![index].phones[0].number, context);
                            }
                          },
                        ),
                      );
                    },
                  )
              )

            ]
        )
    );
  }

  Widget alertDialogContainer(List<Phone> items) {
    return SizedBox(
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: ShapeStyle.listItemShape(),
              child:ListTile(
                title: CustomCommonTextWidget(
                  text: items[index].number ,
                  style: CommonTextStyle.regular_14,
                  color: colorPrimaryText,
                ),
                onTap: () {
                  numberFilter(items[index].number, context);
                  },
              )
          );
        },
      ),
    );
  }

  void numberFilter(rawNum, context){
    String countryCodeRemoved = rawNum.toString().replaceFirst("+880", "0");
    String dashRemoved = countryCodeRemoved.replaceAll("-", "");
    String spaceRemoved1 = dashRemoved.replaceAll(" ", "");
    String spaceRemoved2 = spaceRemoved1.replaceAll(" ", ""); // space like spacial character | ASCI = 160

    userNumber = spaceRemoved2;
    _operatorModalBottomSheet(context);
  }

  void _operatorModalBottomSheet(context){
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CustomListBottomSheet(
            title: "select_operator".tr(),
            models: operators,
            showImage: true,
            blockFunction:(position){
              operator = operators[position];
              simTypes.clear();
              simTypes.add(CommonListBottomSheetModel(icon: "", name: "Prepaid"));
              simTypes.add(CommonListBottomSheetModel(icon: "", name: "Postpaid"));
              if(operator.name == "Grameenphone") {
                isGP = true;
                simTypes.add(CommonListBottomSheetModel(icon: "",name: "skitto"),);
              }
              _simTypeBottomSheet(context);
            }
        );
      },
    );
  }

  void _simTypeBottomSheet(context){
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CustomListBottomSheet(
            title: "select_sim_type".tr(),
            models: simTypes,
            showImage: false,
            blockFunction:(position){
              simType = simTypes[position];
              Navigator.push(context, MaterialPageRoute(builder: (context) => RechargeEnterAmountScreen(simType: simType, number: userNumber, operator: operator, name: userName)));
            }
        );
      },
    );
  }

  String getUsername(String number){
    String username = number;
    filteredContacts?.forEach((element) {
      print(element);
      for (var phnElement in element.phones) {
        if(phnElement.number == number) {
          username = "${element.name.first} ${element.name.middle} ${element.name.last}";
        }
      }
    });

    return username;
  }
}