import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/request_money/request_money_enter_amount_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_user/check_user_controller.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_error_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../ui/custom_widgets/custom_contact_tile_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/extensions/extension_rounded_rectangle_border.dart';
import '../../utils/pref_keys.dart';
import '../../utils/validation_utils.dart';


class RequestMoneyNumberScreen extends ConsumerStatefulWidget {
  const RequestMoneyNumberScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RequestMoneyNumberScreen> createState() =>
      _RequestMoneyNumberScreenState();
}

class _RequestMoneyNumberScreenState
    extends BaseConsumerState<RequestMoneyNumberScreen> {
  List<Contact>? contacts;
  List<Contact>? filteredContacts;

  String userNumber = "";
  String typedNumber = "";
  String userName = "";

  final userNumberTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getContact();
  }

  @override
  void dispose() {
    userNumberTextController.dispose();
    userName = "";
    super.dispose();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: false);
      if (contacts != null && contacts!.isNotEmpty) {
        contacts = ValidationUtils.getValidContacts(contacts!);
        filteredContacts = contacts;
        setState(() {});
      }
    }
  }

  void filterSearchResults(String text) {
    List<Contact> dummyContacts = [];

    if (text.isEmpty) {
      dummyContacts = contacts!;
    } else {
      contacts?.forEach((userDetail) {
        if (userDetail.name.first.toLowerCase().contains(text.toLowerCase()) ||
            userDetail.name.middle.toLowerCase().contains(text.toLowerCase()) ||
            userDetail.name.last.toLowerCase().contains(text.toLowerCase()) ||
            userDetail.phones.toString().contains(text)) {
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
    final userWallet = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);
    final checkUser = ref.read(checkUserControllerProvider.notifier);

    ref.listen<AsyncValue>(
      checkUserControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          if (currentState.value.userType == "CUSTOMER") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequestMoneyEnterAmountScreen(
                        userName: currentState.value.userName,
                        walletNumber: userNumberTextController.text,
                    )
                )
            );
          } else {
            Toasts.showErrorToast("invalid_account_type".tr());
          }
        }
      },
    );

    return Scaffold(
        appBar: const CustomCommonAppBarWidget(appBarTitle: 'request_money'),
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppDimen.toolbarBottomGap),
              Form(
                child: Padding(
                  padding: AppDimen.commonLeftRightPadding,
                  child: CustomCommonInputFieldWidget(
                    obscureText: false,
                    scrollPadding: const EdgeInsets.all(0.0),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: userNumberTextController,
                    onChanged: (value) {
                      typedNumber = value;
                      filterSearchResults(value);
                    },
                    validator: (val) {
                      if (val!.length < 12) {
                        return "enter_valid_wallet_num".tr();
                      }
                      return null;
                    },
                    maxLength: 12,
                    decoration: InputDecoration(
                        labelText: 'enter_name_or_number'.tr(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (userNumberTextController.text.isNotEmpty) {
                              if(userNumberTextController.text == userWallet){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CustomCommonErrorWidget(errorMessage: "Request money to your own number is not allowed")
                                    )
                                );
                              }
                              else {
                                checkUser.checkUser(userNumberTextController.text);
                              }
                            } else {
                              Toasts.showErrorToast(
                                  "enter_name_or_number".tr());
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppDimen.commonCircularBorderRadius,
                          borderSide: BorderSide(
                              color: BrandingDataController.instance.branding.colors.primaryColor,
                              width: DimenSizes.dimen_half),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AppDimen.commonCircularBorderRadius,
                          borderSide: BorderSide(
                              color: greyColor, width: DimenSizes.dimen_2),
                        )),
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
                      String num =
                      (filteredContacts![index].phones.isNotEmpty)
                          ? (filteredContacts![index].phones.first.number)
                          : "--";
                      return Card(
                        shape: ShapeStyle.listItemShape(),
                        margin: AppDimen.contactListTextFieldMargin,
                        child: CustomContactTileWidget(
                          contactItem: filteredContacts![index],
                          image: image,
                          num: num,
                          index: index,
                          onPressedFunction: () {
                            numberFilter(filteredContacts![index].phones[0].number);
                            userName =
                            "${filteredContacts![index].name.first} ${filteredContacts![index].name.middle} ${filteredContacts![index].name.last}";
                            userNumberTextController.text = userNumber;
                            userNumberTextController.selection = TextSelection.fromPosition(
                                TextPosition(offset: userNumberTextController.text.length));
                          },
                        ),
                      );
                    },
                  ))
            ]));
  }

  void contactClickAction(int index) {
    numberFilter(filteredContacts![index].phones[0].number);
    userName =
    "${filteredContacts![index].name.first} ${filteredContacts![index].name.middle} ${filteredContacts![index].name.last}";
    userNumberTextController.text = userNumber;
    userNumberTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: userNumberTextController.text.length));
  }

  void numberFilter(rawNum) {
    String countryCodeRemoved = rawNum.toString().replaceFirst("+880", "0");
    String dashRemoved = countryCodeRemoved.replaceAll("-", "");
    String spaceRemoved1 = dashRemoved.replaceAll(" ", "");
    String spaceRemoved2 = spaceRemoved1.replaceAll(" ", "");
    userNumber = spaceRemoved2;
  }
}
