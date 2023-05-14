import 'package:easy_localization/easy_localization.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/ekyc_core/extensions/ext_nid_string.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.
class NidValidationMixin {

  String? validateMobileNo(String? value) {
    final txt = value ?? '';
    if (txt.isValidMobileNo) {
      return null;
    }
    return "enter_valid_mobile_no".tr();
  }

  String? validateAddress(String? value) {
    final txt = value ?? '';
    if (txt.isValidAddress) {
      return null;
    }
    return "enter_valid_address".tr();
  }

  String? validateNomDob(String? value) {
    final txt = value ?? '';
    if (txt.isValidNomDob) {
      return null;
    }
    return "enter_valid_dob".tr();
  }

  String? validateNid(String? value) {
    final txt = value ?? '';
    if (txt.isValidNid) {
      return null;
    }
    return "enter_valid_nid".tr();
  }

  String? validatePostCode(String? value) {
    final txt = value ?? '';
    if (txt.isValidPostCode) {
      return null;
    }
    return "enter_valid_post_code".tr();
  }


  String? validateBasicText(String? value, {String? title = ''}) {
    final txt = value ?? '';
    final mTitle = title == ''? 'input'.tr() : title;
    if (txt.isBasicValidText) {
      return null;
    }
    return "${"enter_valid".tr()} $mTitle";
  }


  String? validateBasicNumber(String? value, {String? title = 'Input'}) {
    final txt = value ?? '';
    if (txt.isBasicValidNumber) {
      return null;
    }
    return "Enter Valid $title";
  }
}
