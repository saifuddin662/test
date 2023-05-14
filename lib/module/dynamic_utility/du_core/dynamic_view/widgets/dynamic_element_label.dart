import 'package:flutter/material.dart';
import '../../../../../utils/Colors.dart';
import '../../api/du_detail/model/utility_detail_response.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 09,March,2023.

class DynamicElementLabel extends StatelessWidget {
  const DynamicElementLabel({
    super.key,
    required this.element,
  });

  final FieldItemList element;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "${element.label}",
            style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorPrimaryText),
          ),
          TextSpan(
            text: element.required == true ? " *" : "",
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.normal, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
