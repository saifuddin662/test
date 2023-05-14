import 'package:flutter/cupertino.dart';

import '../../api/du_detail/model/utility_detail_response.dart';
import '../enum/du_keyboard_type.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 29,March,2023.

class DuUtils {
  TextInputType setKeyboardType(FieldItemList element) {
    var keyboardType = TextInputType.text;
    if (element.dataType == DuKeyboardType.text.name) {
      keyboardType = TextInputType.text;
    } else if (element.dataType == DuKeyboardType.numeric.name) {
      keyboardType = TextInputType.number;
    } else {
      keyboardType = TextInputType.text;
    }

    return keyboardType;
  }
}
