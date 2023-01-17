import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/image_src.dart';

import '../screens/bottombar/bottomnavigationbar.dart';
import '../widgets/default_text.dart';

class ToastUtils {
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;

  static void showCustomToast(
      BuildContext context, String message, Color color) {
    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntry(context, message, color);
      Overlay.of(context)!.insert(_overlayEntry!);
      toastTimer = Timer(const Duration(seconds: 5), () {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
        }
      });
    }
  }

  static void showCustomToast1(
      BuildContext context, String message, Color color) {
    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntry(context, message, color);
      Overlay.of(context)!.insert(_overlayEntry!);
      toastTimer = Timer(const Duration(seconds: 7), () {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
        }
      });
    }
  }

  static void showCustomDialog(
      BuildContext context, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Image(
                  image: const AssetImage(greenWatch),
                  height: 44.h,
                  width: 44.w,
                ),
                SizedBox(
                  height: 10.h,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: message,
                        style: TextStyle(
                            color: black,
                            fontFamily: "Poppins",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      )
                    ])),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    AppRoutes.push(context, PageTransitionType.bottomToTop,
                        const MyNavigationBar());
                  },
                  child: Container(
                    height: 44.h,
                    width: 120.w,
                    // margin: EdgeInsets
                    //     .only(
                    //         left:
                    //            8.w,
                    //         right:
                    //           8.w),

                    child: Align(
                      alignment: Alignment.center,
                      child: text(
                        context,
                        'Done',
                        16.sp,
                        color: white,
                        boldText: FontWeight.w600,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: greenShade,
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static OverlayEntry createOverlayEntry(
      BuildContext context, String message, Color color) {
    return OverlayEntry(
        builder: (context) => Positioned(
            top: 50.0,
            width: MediaQuery.of(context).size.width - 20.w,
            left: 10,
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 13, bottom: 10),
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(10.r)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.rubik(
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )));
  }
}
