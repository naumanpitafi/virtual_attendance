import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/color_constants.dart';

class ReusableWidgets {
  static getAppBar(
      {required String title,
      required bool isBack,
      required BuildContext context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 65,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: 8.r),
        child: Container(
          margin: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
          ),
          height: 62.h,
          width: 350.w,
          decoration: BoxDecoration(
              gradient: primaryreadGradient,
              borderRadius: BorderRadius.circular(10.r)),
          child: Stack(
            children: [
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: white,
                    fontFamily: "Poppins-SemiBold",
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.01,
                child: isBack == false
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.r),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
