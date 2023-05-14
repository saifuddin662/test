import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 17,January,2023.

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    EasyLoading.show();

    return Container();
  }
}
