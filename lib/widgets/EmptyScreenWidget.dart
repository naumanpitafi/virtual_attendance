import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/lottie_src.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipRect(
              child: Lottie.asset(
            emptyScreen,
            height: 300.h,
            width: 300.w,
          )),
        ),
        Padding(
          padding: EdgeInsets.only(top: 200.r),
          child: Center(
              child: Text(
            "No Data Found !",
            style: TextStyle(
                fontSize: 18.sp,
                color: bbColor,
                fontFamily: "Poppins-SemiBold"),
          )),
        )
      ],
    );
  }
}
