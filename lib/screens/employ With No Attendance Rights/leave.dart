import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/models/employeLeaveRequestDetailsModel.dart';
import 'package:virtual_attendance/providers/getEmployeesLeaveRequestDetail.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
// <<<<<<< HEAD
// =======
import 'package:virtual_attendance/utils/lottie_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/EmptyScreenWidget.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../../utils/color_constants.dart';

// >>>>>>> 8cc3b523c3326d41f679e5539f73ff457e61347a
// import '../../providers/getEmployeesLeaveRequestDetail.dart';
// import '../../utils/color_constants.dart';
// import '../../utils/sheared_pref_Service.dart';
// import '../../widgets/default_text.dart';

class LeaveScreen extends StatefulWidget {
  int selectedVal;

  LeaveScreen({Key? key, required this.selectedVal}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  @override
  void initState() {
    // indexvalue = widget.selectedVal;
    getUserName();
    // currentMonth();
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';
  String employeId = 'Unknown';

  Widget _buildImage(
      {required String assetName, double? height, double? width}) {
    return Lottie.asset(
      assetName,
      height: height,
      width: width,
    );
  }

  getUserName() async {
    try {
      var _employeId = await SharedPref.getEmployeId();
      var _employeUsername = await SharedPref.getUserName();
      var _employeUsepassword = await SharedPref.getUserPassword();

      setState(() {
        employeId = _employeId;
        employepassword = _employeUsepassword;
        employeUserName = _employeUsername;
        // currentMonth();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  DateTime todayDate = DateTime.now();
  var currentMonthInitialdate;
  var currentMonthLastdate;

  void currentMonth() {
    var date1 =
        DateTime(DateTime.now().year, DateTime.now().month, 1).toString();
    var dateParse = DateTime.parse(date1);
    currentMonthInitialdate = formatter.format(dateParse);
    var prevMonth =
        DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
    currentMonthLastdate = formatter.format(prevMonth);

    var now = DateTime.now();
    var lastDayDateTime = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);
    currentMonthLastdate = formatter.format(lastDayDateTime);
    log(lastDayDateTime.day.toString());
    log(currentMonthLastdate);
    log("====================== Current month ====================");
    log('currentMonthInitialdate 1111 = $currentMonthInitialdate');
    log('currentMonthLastdate11111 = $currentMonthLastdate');

    Apis().getEmployeeLeavesDetail(
      context,
      employeId,
      employeUserName,
      employepassword,
      currentMonthInitialdate,
      currentMonthLastdate,
    );

    log("====================== Current month ====================");
  }

  void lastMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month + 0, 1);
    currentMonthInitialdate = formatter.format(firstDayOfMonth);
    currentMonthLastdate = formatter.format(now);
    log("====================== Last month ====================");
    log("currentMonthInitialdate = $currentMonthInitialdate");
    log("currentMonthLastdate = $currentMonthLastdate");

    Apis().getEmployeeLeavesDetail(context, employeId, employeUserName,
        employepassword, currentMonthLastdate, currentMonthInitialdate);
    log("====================== Last month ====================");
  }

  // int selectedCard = 1;
  // int? indexvalue ;
  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //         statusBarColor: Colors.transparent,
    //         statusBarIconBrightness: Brightness.dark,
    //         statusBarBrightness: Brightness.dark,
    //       ));
    List<EmployeLeavesRequestDetailsemodel> listData = [];
    return Consumer<EmployeLeavesRequestDetailProvider>(
        builder: (context, prov, _) {
      if (widget.selectedVal == 1) {
        listData = prov.pendingLeavesData;
      } else if (widget.selectedVal == 2) {
        listData = prov.appreovedLeavesData;
      } else if (widget.selectedVal == 3) {
        listData = prov.rejectedLeavesData;
      }

      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: ReusableWidgets.getAppBar(
                title: 'Leave', isBack: true, context: context),
            body: Container(
              padding: EdgeInsets.only(top: 13.r),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.r),
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedVal = 1;
                              widget.selectedVal = 1;
                            });
                          },
                          child: Container(
                            height: 35.h,
                            width: 106.w,
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 1
                                  ? const Color(0xffE01F27).withOpacity(0.10)
                                  : Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 9.sp,
                                  color: const Color(0xffD28F0E),
                                ),
                                Text(
                                  'Pending',
                                  style: TextStyle(
                                    // color: indexvalue == 1
                                    //     ? const Color(0xffFFB8B8)
                                    //     : const Color(0xff676060),
                                    color: widget.selectedVal == 1
                                        ? const Color(0xffE01F27)
                                        : const Color(0xff676060),

                                    fontWeight: widget.selectedVal == 1
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    // fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    fontFamily: "poppins",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedVal = 2;
                              widget.selectedVal = 2;
                            });
                          },
                          child: Container(
                            height: 35.h,
                            width: 106.w,
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 2
                                  ? const Color(0xffE01F27).withOpacity(0.1)
                                  : Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 9.sp,
                                  color: const Color(0xff00AC11),
                                ),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                    // color: indexvalue == 2
                                    //     ? const Color(0xffFFB8B8)
                                    //     : const Color(0xff676060),
                                    color: widget.selectedVal == 2
                                        ? const Color(0xffE01F27)
                                        : const Color(0xff676060),

                                    fontWeight: widget.selectedVal == 2
                                        ? FontWeight.w700
                                        : FontWeight.w400,

                                    fontSize: 14.sp,
                                    fontFamily: "poppins",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedVal = 3;
                              widget.selectedVal = 3;
                            });
                          },
                          child: Container(
                            height: 35.h,
                            width: 106.w,
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 3
                                  ? const Color(0xffE01F27).withOpacity(0.1)
                                  : Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 9.sp,
                                  color: const Color(0xffBA1616),
                                ),
                                Text(
                                  'Rejected',
                                  style: TextStyle(
                                    color: widget.selectedVal == 3
                                        ? const Color(0xffE01F27)
                                        : const Color(0xff676060),
                                    fontWeight: widget.selectedVal == 3
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: "poppins",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  prov.employeLeavesloading
                      ? Expanded(
                          child: Center(
                              child: _buildImage(
                                  assetName: loadingImg,
                                  height: 40.h,
                                  width: 80.h)),
                        )
                      : listData.isEmpty
                          ? Expanded(
                              child: EmptyScreenWidget(),
                            )
                          : Expanded(
                              child: AnimationLimiter(
                                child: ListView.builder(
                                    itemCount: listData.length,
                                    itemBuilder: (context, i) {
                                      EmployeLeavesRequestDetailsemodel cate =
                                          listData[i];

                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: i,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                              child: listData.isNotEmpty
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 13.r,
                                                      ),
                                                      child: leaveWidget(cate))
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                      child:
                                                          EmptyScreenWidget(),
                                                    )),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget leaveWidget(EmployeLeavesRequestDetailsemodel wholedata) {
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 15.h,
        bottom: 15.h,
      ),
      // height: 91.h,
      width: 362.w,
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: black.withOpacity(0.25),
          ),
        ],
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                context,
                wholedata.employeLeaveDateFrom!.isNotEmpty
                    ? DateFormat.yMMMM().format(
                        DateTime.tryParse(wholedata.employeLeaveDateFrom!)!)
                    : wholedata.employeLeaveDateFrom!,
                14.sp,
                fontFamily: "Poppins-Medium",
                color: const Color(0xff263238),
              ),
              Container(
                height: 30.h,
                width: 75.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: wholedata.employeApproved == "Y" &&
                          wholedata.employeRejected == "N"
                      ? const Color(0xffAFFF93)
                      : wholedata.employeApproved == "N" &&
                              wholedata.employeRejected == "Y"
                          ? const Color(0xffFFB8B8)
                          : const Color(0xffFFE7BA),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: text(
                    context,
                    wholedata.employeApproved == "Y" &&
                            wholedata.employeRejected == "N"
                        ? 'Approved'
                        : wholedata.employeApproved == "N" &&
                                wholedata.employeRejected == "Y"
                            ? 'Rejected'
                            : 'Pending',
                    14.sp,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins",
                    color: wholedata.employeApproved == "Y" &&
                            wholedata.employeRejected == "N"
                        ? const Color(0xff00AC11)
                        : wholedata.employeApproved == "N" &&
                                wholedata.employeRejected == "Y"
                            ? const Color(0xffBA1616)
                            : const Color(0xffD28F0E),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text(
                context,
                wholedata.employeDescription!.toLowerCase(),
                16.sp,
                fontFamily: "Poppins-Medium",
                color: const Color(0xff263238),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text(
                context,
                wholedata.employeLeaveDateTo!.isNotEmpty
                    ? '${DateFormat.E().addPattern(",").add_d().add_MMM().format(DateTime.tryParse(wholedata.employeLeaveDateTo!.toString())!)}'
                    : wholedata.employeLeaveDateTo!,
                16.sp,
                fontFamily: "Poppins-SemiBold",
                color: const Color(0xff263238),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text(
                context,
                'Remarks',
                14.sp,
                fontFamily: "Poppins-Medium",
                color: black,
              ),
            ],
          ),
          Wrap(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  wholedata.employeRemarks.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                    fontFamily: "Poppins",
                    color: Color(0xff263238),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
