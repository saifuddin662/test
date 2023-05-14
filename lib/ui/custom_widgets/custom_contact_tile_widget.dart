import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

import '../../utils/Colors.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 02,March,2023.

class CustomContactTileWidget extends StatefulWidget {
  const CustomContactTileWidget({
    super.key,
    required this.image,
    required this.num,
    this.onPressedFunction,
    required this.index,
    this.contactItem,
  });

  final Contact? contactItem;
  final Uint8List? image;
  final String num;
  final VoidCallback? onPressedFunction;
  final int index;

  @override
  State<CustomContactTileWidget> createState() =>
      _CustomContactTileWidgetState();
}

class _CustomContactTileWidgetState extends State<CustomContactTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: (widget.contactItem?.photo == null)
            ? CircleAvatar(
                backgroundColor: BrandingDataController.instance.branding.colors.primaryColor, child: const Icon(Icons.person))
            : CircleAvatar(backgroundImage: MemoryImage(widget.image!)),
        title: CustomCommonTextWidget(
            text: "${widget.contactItem!.name.first} ${widget.contactItem!.name.middle} ${widget.contactItem!.name.last}",
            style: CommonTextStyle.regular_16,
            color: colorPrimaryText,
            shouldShowMultipleLine : true
        ),
        subtitle: CustomCommonTextWidget(
            text: widget.num,
            style: CommonTextStyle.regular_14,
            color: greyColor,
            shouldShowMultipleLine : true
        ),
        onTap: () => widget.onPressedFunction!());
  }
}
