import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../../utils/image_src.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: ReusableWidgets.getAppBar(
              title: 'Notifications', isBack: false, context: context),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: text(
                      context,
                      'Today',
                      18.sp,
                      boldText: FontWeight.bold,
                      fontFamily: "DM Sans",
                      color: const Color(0xff263238),
                    ),
                  ),
                  notificationWidget(),
                  notificationWidget(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: text(
                      context,
                      'Yesterday',
                      18.sp,
                      boldText: FontWeight.bold,
                      fontFamily: "DM Sans",
                      color: const Color(0xff263238),
                    ),
                  ),
                  notificationWidget(),
                  notificationWidget(),
                  notificationWidget(),
                  notificationWidget(),
                ],
              ),
            ),
          )),
    );
  }

  Widget notificationWidget() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: const Image(
          image: AssetImage(notificationimg),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: text(
            context,
            'Leave Request',
            18.sp,
            fontFamily: "DM Sans",
            boldText: FontWeight.w700,
            color: const Color(0xff263238),
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'Your leave Request from ',
                style: TextStyle(
                  color: bbColor,
                  fontFamily: "DM Sans",
                  fontSize: 14.sp,
                ),
              ),
              TextSpan(
                text: 'April 26 ',
                style: TextStyle(
                  color: const Color(0xffE01F27),
                  fontWeight: FontWeight.bold,
                  fontFamily: "DM Sans",
                  fontSize: 14.sp,
                ),
              ),
              TextSpan(
                text: 'to ',
                style: TextStyle(
                  color: bbColor,
                  fontFamily: "DM Sans",
                  fontSize: 14.sp,
                ),
              ),
              TextSpan(
                text: 'April 30 ',
                style: TextStyle(
                  color: const Color(0xffE01F27),
                  fontWeight: FontWeight.bold,
                  fontFamily: "DM Sans",
                  fontSize: 14.sp,
                ),
              ),
              TextSpan(
                text: 'has been ',
                style: TextStyle(
                  color: bbColor,
                  fontFamily: "DM Sans",
                  fontSize: 14.sp,
                ),
              ),
              TextSpan(
                text: 'Decline.',
                style: TextStyle(
                  color: const Color(0xffE01F27),
                  fontWeight: FontWeight.bold,
                  fontFamily: "DM Sans",
                  fontSize: 14.sp,
                ),
              ),
            ])),
            SizedBox(
              height: 5.h,
            ),
            text(
              context,
              '2 mins',
              12.sp,
              fontFamily: "DM Sans",
              boldText: FontWeight.w500,
              color: const Color(0xff676060),
            ),
          ],
        ));
  }
}
