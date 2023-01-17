// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_constants.dart';

class DefaultColorButton extends StatelessWidget {
  String text;
  final Function() press;
  DefaultColorButton(
      {Key? key, required this.text, required this.press, required this.width})
      : super(key: key);
  double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: width,
        height: 50.h,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))
            ],
            gradient: primaryreadGradient,
            borderRadius: BorderRadius.circular(10.r)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: white),
          ),
        ),
      ),
    );
  }
}
