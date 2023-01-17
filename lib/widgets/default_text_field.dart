import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_constants.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  const DefaultTextField(
      {Key? key, required this.controller, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greyLightShade, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Color(0xffC4C4C4))],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        cursorColor: readcolor,
        controller: controller,
        style: TextStyle(
          fontSize: 16.sp,
          color: bbColor,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w300,
        ),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: greyShade,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
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
