import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCommonInputFieldWidget extends StatelessWidget {
  final bool autofocus;
  final bool readOnly;
  final TextEditingController? controller;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final EdgeInsets scrollPadding;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final bool? enabled;
  final Color? cursorColor;
  final TextAlign textAlign;

  const CustomCommonInputFieldWidget({
    super.key,
    this.autofocus = false,
    this.readOnly = false,
    this.controller,
    required this.obscureText,
    required this.scrollPadding,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.decoration,
    this.inputFormatters,
    this.autovalidateMode,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.style,
    this.enabled,
    this.cursorColor,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      scrollPadding: scrollPadding,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: decoration,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      onTap: onTap,
      style: style,
      enabled: enabled ?? decoration?.enabled ?? true,
      cursorColor: cursorColor,
      textAlign: textAlign,
    );
  }
}
