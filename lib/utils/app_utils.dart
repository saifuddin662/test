import 'package:flutter/material.dart';

class AppUtils {

  static hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

}
