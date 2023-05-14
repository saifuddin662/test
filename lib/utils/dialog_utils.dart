import 'package:flutter/material.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 27,March,2023.
class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {required String title,
        String okBtnText = "Ok",
        String cancelBtnText = "Cancel",
        required VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: const Text('Would you like to allow FirstCash to access your contact book? By doing this, we can help you select your desired contacts easily'),
            actions: <Widget>[

              TextButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context)),
              TextButton(
                onPressed: okBtnFunction,
                child: Text(okBtnText),
              ),
            ],
          );
        });
  }
}