import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final int maxLength;
  final TextInputType inputType;
  final bool autoFocus;
  final EdgeInsets scPadding;

  const CustomTextInputWidget({super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.maxLength,
    required this.inputType,
    this.autoFocus = false,
    this.scPadding = const EdgeInsets.only(),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      controller: controller,
      obscureText: obscureText,
      maxLength: maxLength,
      keyboardType: inputType,
      scrollPadding: scPadding,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: const TextStyle(fontSize: 12.0),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        labelText: labelText,
        hintStyle: const TextStyle(fontSize: 12.0, color: Color(0xFF616161)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0xFF616161), width: 2.0),
        ),
      ),
    );
  }
}