import '../../api/du_detail/model/utility_detail_response.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 09,March,2023.

class DynamicUtilityValidationMixin {
  String? validateDynamicField(String? value, FieldItemList element) {
    final txt = value ?? '';
    if (element.required ?? false) {
      if (txt.isEmpty) return 'Input cant be empty!';
    }
    if (element.regex != null && txt.isNotEmpty) {
      if (validateRegex(txt, element.regex!)) {
        return null;
      } else {
        return 'Please Enter Valid ${element.label}';
      }
    } else {
      return null;
    }
  }

  String? validateNotificationField(String? value, FieldItemList element) {
    final txt = value ?? '';

    if (txt.isEmpty) return 'Input cant be empty!';

    if (element.regex != null && txt.isNotEmpty) {
      if (validateRegex(txt, element.regex!)) {
        return null;
      } else {
        return 'Please Enter Valid ${element.label}';
      }
    } else {
      return null;
    }
  }

  bool validateRegex(String input, String pattern) {
    final regExp = RegExp(pattern);
    return regExp.hasMatch(input);
  }
}
