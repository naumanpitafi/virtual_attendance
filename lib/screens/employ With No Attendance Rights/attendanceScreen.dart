import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../../utils/image_src.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 35.h,
              ),
              Container(
                // margin: EdgeInsets.only(left: 10.w, right: 10.w),
                height: 62.h,
                width: 350.w,
                decoration: BoxDecoration(
                    gradient: primaryreadGradient,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: white,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 70.w,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: text(context, 'Attendance', 22.sp,
                          fontFamily: "Poppins",
                          boldText: FontWeight.w600,
                          color: white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              presentWidget(),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Divider(
                  thickness: 2,
                  color: greyLightShade.withOpacity(0.3),
                ),
              ),
              presentWidget(),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Divider(
                  thickness: 2,
                  color: greyLightShade.withOpacity(0.3),
                ),
              ),
              absentWidget(),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Divider(
                  thickness: 2,
                  color: greyLightShade.withOpacity(0.3),
                ),
              ),
              presentWidget(),
               Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Divider(
                  thickness: 2,
                  color: greyLightShade.withOpacity(0.3),
                ),
              ),
              presentWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget presentWidget() {
    return Row(children: [
      Container(
          height: 60.h,
        width: 60.w,
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffE01F27).withOpacity(0.2),
        ),
        child: Container(
   
          decoration: BoxDecoration(
            
              image: DecorationImage(
                image: AssetImage(presentimage),
                fit: BoxFit.contain,
              )),
          height: 40.h,
          width: 40.w,
        ),
      ),
      SizedBox(
        width: 20.w,
      ),
      Column(
        children: [
          text(context, 'Present', 16.sp,
              color: greenShade,
              fontFamily: "Poppins",
              boldText: FontWeight.w500),
          Row(
            children: [
              Icon(
                Icons.access_time_filled_sharp,
                color: greenShade,
                size: 20,
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, 'Clock In', 12.sp,
                      color: black,
                      fontFamily: "Poppins",
                      boldText: FontWeight.w400),
                  text(context, '8:56 PM', 12.sp,
                      color: black,
                      fontFamily: "Poppins",
                      boldText: FontWeight.w400),
                ],
              ),
            ],
          ),
        ],
      ),
      Spacer(),
      Column(
        children: [
          text(context, 'Thursday 3 july', 14.sp,
              color: const Color(0xff263238),
              fontFamily: "Poppins",
              boldText: FontWeight.w500),
          Row(
            children: [
              Icon(
                Icons.access_time_filled_sharp,
                color: readcolor,
                size: 20,
              ),
              // SizedBox(
              //   width: 10.w,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, 'Clock Out', 12.sp,
                      color: black,
                      fontFamily: "Poppins",
                      boldText: FontWeight.w400),
                  text(context, '8:56 PM', 12.sp,
                      color: black,
                      fontFamily: "Poppins",
                      boldText: FontWeight.w400),
                ],
              ),
            ],
          ),
        ],
      )
    ]);
  }

  Widget absentWidget() {
    return Row(children: [
      Container(
        height: 60.h,
        width: 60.w,
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffE01F27).withOpacity(0.2),
        ),
        child: Container(
          decoration: BoxDecoration(
              image: const DecorationImage(
            image: AssetImage(absentimage),
            fit: BoxFit.contain,
          )),
          height: 40.h,
          width: 40.w,
        ),
      ),
      SizedBox(
        width: 20.w,
      ),
      text(
        context,
        'Absent',
        16.sp,
        color: redShade,
        fontFamily: "Poppins",
        boldText: FontWeight.w500,
      ),
    ]);
  }
}
