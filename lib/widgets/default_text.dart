import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_attendance/utils/color_constants.dart';

Widget text(context, text, size,
    {color = "", boldText = "", fontFamily = "", maxLines = 9}) {
  return Text(
    text,
    style: TextStyle(
      color: color == "" ? Colors.black : color,
      fontSize: size,
      fontWeight: boldText == "" ? FontWeight.normal : boldText,
      fontFamily: fontFamily == "" ? 'DM Sans' : fontFamily,
    ),
    maxLines: maxLines,
  );
}

myinputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
    // / -- Text and Icon -- /
    hintText: "Search...",
    hintStyle: TextStyle(
      fontSize: 16.sp,
      fontFamily: "Poppins-Light",
      color: Color(0xFFB3B1B1),
    ), // TextStyle
    suffixIcon: const Icon(
      Icons.search,
      size: 26,
      color: Colors.black54,
    ), // Icon
    // / -- Border Styling -- /
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFFACA6A6),
      ), // BorderSide
    ), // OutlineInputBorder
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFFACA6A6),
      ), // BorderSide
    ), // OutlineInputBorder
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        width: 2.0,
        color: readcolor,
      ), // BorderSide
    ), // OutlineInputBorder
  );
}
