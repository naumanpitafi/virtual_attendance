import 'package:flutter/material.dart';

import '../utils/color_constants.dart';

class DefaultTextFieldSufix extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final Icon textIcon;
  const DefaultTextFieldSufix(
      {Key? key,
      required this.controller,
      required this.text,
      required this.textIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greyLightShade, width: 1),
        boxShadow: [BoxShadow(blurRadius: 6, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
            fontSize: 16,
            color: bbColor,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w300),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          suffixIcon: textIcon,
          hintText: text,
          hintStyle: const TextStyle(
              fontSize: 16, color: bbColor, fontFamily: 'Open Sans'),
          fillColor: const Color(0xFFFFFFFF),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}