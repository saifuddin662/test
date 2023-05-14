import 'package:flutter/material.dart';
import '../../../../../utils/Colors.dart';
import '../../../../../utils/dimens/app_dimens.dart';
import '../../../../../utils/dimens/dimensions.dart';
import '../../../du_detail_screen.dart';
import '../../api/du_detail/model/utility_detail_response.dart';
import '../data/dynamic_utility_data_controller.dart';
import '../mixins/dynamic_utility_validation_mixin.dart';
import '../utils/du_utils.dart';
import '../widgets/dynamic_element_label.dart';
import '/../utils/extensions/extension_text_style.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.

class DynamicTextField extends StatefulWidget {
  final FieldItemList element;
  final DynamicValueListener valueListener;

  const DynamicTextField(
      {Key? key, required this.element, required this.valueListener})
      : super(key: key);

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField>
    with DynamicUtilityValidationMixin {
  bool _changed = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimen.gapBetweenTextField),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicElementLabel(
            element: widget.element,
          ),
          const SizedBox(height: DimenSizes.dimen_10),
          TextFormField(
            keyboardType: DuUtils().setKeyboardType(widget.element),
            style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.normal ,color: colorPrimaryText),
            decoration: InputDecoration(
              hintText: "${widget.element.hint}",
              hintStyle: FontStyle.l_16_regular(color: suvaGray),
              border: OutlineInputBorder(
                borderRadius: AppDimen.commonCircularBorderRadius,
                borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
              ),
            ),
            onChanged: (value) {
              if (!_changed) {
                setState(() {
                  if(widget.element.required!) DynamicUtilityDataController.instance.requiredMap[widget.element.key!] = true;
                  _changed = true;
                });
              }

              widget.valueListener(widget.element.key!, value);
            },
            validator: (value) => _changed ? validateDynamicField(value, widget.element) : null,
          ),
        ],
      ),
    );
  }

}
