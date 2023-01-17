import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/employeAttendanceSummery.dart';
import 'package:virtual_attendance/providers/singleUserAttendanceProvider.dart';
import 'package:virtual_attendance/utils/lottie_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/EmptyScreenWidget.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import '../../models/getAttendanceinformationofAUsera.dart';
import '../../providers/userProfileProvider.dart';
import '../../utils/apiScreen.dart';
import '../../utils/app_routes.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_src.dart';
import '../../widgets/default_text.dart';

class SingleUserAttendanceDetails extends StatefulWidget {
  int selectedVal;
  String? monthValue;
  SingleUserAttendanceDetails({
    Key? key,
    required this.selectedVal,
    required this.monthValue,
  }) : super(key: key);

  @override
  State<SingleUserAttendanceDetails> createState() =>
      _SingleUserAttendanceDetailsState();
}

class _SingleUserAttendanceDetailsState
    extends State<SingleUserAttendanceDetails> {
  ScrollController _myController = ScrollController();
  @override
  void initState() {
    // selectedCard = widget.selectedVal;
    indexvalue = widget.selectedVal;
    getUserName();
    if (widget.selectedVal == 4 || widget.selectedVal == 5) {
      Timer(Duration(milliseconds: 500),
          () => _myController.jumpTo(_myController.position.maxScrollExtent));
    }

    // currentMonth();
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';
  String employeId = 'Unknown';
  DateTime todayDate = DateTime.now();
  getUserName() async {
    // AllEmployeAttendanceSummeryProvider getattendanceSummeryProvider =
    //     Provider.of<AllEmployeAttendanceSummeryProvider>(context);
    //  Provider.of<AllEmployeAttendanceSummeryProvider>(context).setvaluesto0(true);
    try {
      var _employeId = await SharedPref.getEmployeId();
      var _employeUsername = await SharedPref.getUserName();
      var _employeUsepassword = await SharedPref.getUserPassword();

      setState(() {
        employeId = _employeId;
        employepassword = _employeUsepassword;
        employeUserName = _employeUsername;
        log('widget.monthValue = ${widget.monthValue}');
        widget.monthValue == 'Current Month' ? currentMonth() : lastMonth();
        // lastMonth();
        // Apis().getSingleUserAttendanceDetail(context, employeId,
        //     employeUserName, employepassword, '11-sep-2011', '23-sep-2011');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  // Initial Selected Value
  String dropdownvalue = 'Current Month';

  // List of items in our dropdown menu
  var items = [
    'Current Month',
    'Last Month',
  ];
  var currentMonthInitialdate;
  var currentMonthLastdate;

  void lastMonth() {
    // currentMonthInitialdate = formatter.format(todayDate);
    // currentMonthInitialdate = formatter.format(DateTime.now());

    var date1 =
        DateTime(DateTime.now().year, DateTime.now().month, 1).toString();
    var dateParse = DateTime.parse(date1);
    currentMonthInitialdate = formatter.format(dateParse);
    // currentMonthLastdate = todayDate.month;
    var prevMonth = DateTime(todayDate.year, todayDate.month - 1);
    currentMonthLastdate = formatter.format(prevMonth);

    log("====================== Last month ====================");
    log('currentMonthInitialdate = $currentMonthInitialdate');
    log('currentMonthLastdate = $currentMonthLastdate');

    Apis().getSingleUserAttendanceDetail(
      context,
      employeId,
      employeUserName,
      employepassword,
      currentMonthLastdate,
      currentMonthInitialdate,
    );

    log("====================== Last month ====================");
  }

  void currentMonth() {
    var now = DateTime.now();
    var first_day = DateTime(now.year, now.month, 1);

    currentMonthInitialdate = formatter.format(first_day);
// Find the last day of the month.
    var lastDayDateTime = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);
    currentMonthLastdate = formatter.format(lastDayDateTime);
    log(lastDayDateTime.day.toString());
    log(currentMonthLastdate);
    log("====================== current month ====================");
    log("LastMonthInitialdate = $currentMonthInitialdate");
    log("LastMonthLastdate = $currentMonthLastdate");
    Apis().getSingleUserAttendanceDetail(
      context,
      employeId,
      employeUserName,
      employepassword,
      currentMonthInitialdate,
      currentMonthLastdate,
    );
    log("====================== current month ====================");
  }

  Widget _buildImage(
      {required String assetName, double? height, double? width}) {
    return Lottie.asset(assetName, height: height, width: width);
  }

  int? selectedCard;
  int? indexvalue;
  @override
  Widget build(BuildContext context) {
    List<SingleUserAttendanceModel> listData = [];
    GetUserDetailProvider getUserDetailProvider =
        Provider.of<GetUserDetailProvider>(context, listen: true);
    return Consumer<SingleUserAttendanceProvider>(builder: (context, prov, _) {
      if (widget.selectedVal == 1) {
        listData = prov.singleUserAttendanceDetails;
      } else if (widget.selectedVal == 2) {
        listData = prov.singleUserPresentDetails;
      } else if (widget.selectedVal == 3) {
        listData = prov.singleUserAbsentDetails;
      } else if (widget.selectedVal == 4) {
        listData = prov.singleUserLateDetails;
      } else if (widget.selectedVal == 5) {
        listData = prov.singleUserLeaveDetails;
      }
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: ReusableWidgets.getAppBar(
                title: 'Attendance', isBack: true, context: context),
            body: Column(
              children: [
                // RaisedButton(
                //     onPressed: () {
                //       lastMonth();
                //     },
                //     child: Text('hit me')),
                Padding(
                  padding: EdgeInsets.only(
                    top: 12.h,
                    right: 10,
                    left: 10,
                  ),
                  child: Container(
                      height: 105.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4, color: black.withOpacity(0.25))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 17.h,
                                    width: 17.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(iconwithoutCircle),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 17.h,
                                    width: 17.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(calenderIcon),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                        context,
                                        'Emp Name',
                                        12.sp,
                                        fontFamily: 'Poppins',
                                        color: bbColor,
                                      ),
                                      text(
                                        context,
                                        getUserDetailProvider
                                            .empDetails1[0].employeName,
                                        12.sp,
                                        fontFamily: 'Poppins-Medium',
                                        color: Color(0xff2A2E32),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                        context,
                                        'Date of Birth',
                                        12.sp,
                                        fontFamily: 'Poppins',
                                        color: bbColor,
                                      ),
                                      text(
                                        context,
                                        //  getUserDetailProvider.empDetails1[0].employeDOB,
                                        getUserDetailProvider.empDetails1[0]
                                                    .employeDOB!.length >
                                                3
                                            ? '${DateFormat.yMd().format(DateTime.tryParse(getUserDetailProvider.empDetails1[0].employeDOB!)!)}'
                                            : getUserDetailProvider
                                                .empDetails1[0].employeDOB!,
                                        12.sp,
                                        fontFamily: 'Poppins-Medium',
                                        color: Color(0xff2A2E32),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 14.h,
                                    width: 19.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(profileNIC),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(profileMobile),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(context, 'CNIC', 12.sp,
                                          fontFamily: 'Poppins',
                                          color: bbColor),
                                      text(
                                        context,
                                        getUserDetailProvider
                                            .empDetails1[0].employeNIC,
                                        12.sp,
                                        fontFamily: 'Poppins-Medium',
                                        color: Color(0xff2A2E32),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                        context,
                                        'Phone No',
                                        12.sp,
                                        fontFamily: 'Poppins',
                                        color: bbColor,
                                      ),
                                      text(
                                        context,
                                        getUserDetailProvider
                                            .empDetails1[0].employeMobileNumber,
                                        12.sp,
                                        fontFamily: 'Poppins-Medium',
                                        color: Color(0xff2A2E32),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.only(top: 10.h),
                    child: ListView(
                      controller: _myController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(right: 5.h),
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedVal = 1;
                              widget.selectedVal = 1;
                              log('widget.selectedVal = ${widget.selectedVal}');
                            });
                          },
                          child: Container(
                            height: 35.h,
                            width: 58.w,
                            margin: EdgeInsets.only(right: 5.h),
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 1
                                  ? const Color(0xffE01F27)
                                  : const Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'All',
                                  style: TextStyle(
                                    color: widget.selectedVal == 1
                                        ? const Color(0xffFFffff)
                                        : const Color(0xff676060),
                                    fontSize: 12.sp,
                                    fontFamily: "Poppins-Medium",
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
                            width: 101.w,
                            margin: EdgeInsets.only(left: 5.h, right: 5.h),
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 2
                                  ? const Color(0xffE01F27)
                                  : const Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Presents',
                                  style: TextStyle(
                                    color: widget.selectedVal == 2
                                        ? const Color(0xffFFffff)
                                        : const Color(0xff676060),
                                    // color: readcolor,

                                    // fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    fontFamily: "Poppins-Medium",
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
                            width: 98.w,
                            margin: EdgeInsets.only(left: 5.h, right: 5.h),
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 3
                                  ? const Color(0xffE01F27)
                                  : const Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Absent',
                                  style: TextStyle(
                                    color: widget.selectedVal == 3
                                        ? const Color(0xffFFffff)
                                        : const Color(0xff676060),
                                    fontSize: 12.sp,
                                    fontFamily: "Poppins-Medium",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedVal = 4;
                              widget.selectedVal = 4;
                            });
                          },
                          child: Container(
                            height: 35.h,
                            width: 70.w,
                            margin: EdgeInsets.only(left: 5.h, right: 5.h),
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 4
                                  ? const Color(0xffE01F27)
                                  : const Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Late',
                                  style: TextStyle(
                                    color: widget.selectedVal == 4
                                        ? const Color(0xffFFffff)
                                        : const Color(0xff676060),
                                    fontSize: 12.sp,
                                    fontFamily: "Poppins-Medium",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedVal = 5;
                              widget.selectedVal = 5;
                            });
                          },
                          child: Container(
                            height: 35.h,
                            width: 107.w,
                            margin: EdgeInsets.only(left: 5.h, right: 5.h),
                            decoration: BoxDecoration(
                              color: widget.selectedVal == 5
                                  ? const Color(0xffE01F27)
                                  : const Color(0xff000000).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Leave',
                                  style: TextStyle(
                                    color: widget.selectedVal == 5
                                        ? const Color(0xffFFffff)
                                        : const Color(0xff676060),
                                    fontSize: 12.sp,
                                    fontFamily: "Poppins-Medium",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                prov.singleUserAttendanceloading == true
                    ? Expanded(
                        child: Center(
                            child: _buildImage(
                                assetName: loadingImg,
                                height: 40.h,
                                width: 80.h)),
                      )
                    : listData.length == 0
                        ? Expanded(
                            child: EmptyScreenWidget(),
                          )
                        : Expanded(
                            // height: MediaQuery.of(context).size.height * 0.6,
                            child: AnimationLimiter(
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: listData.length,
                                  itemBuilder: (context, i) {
                                    SingleUserAttendanceModel cate =
                                        listData[i];
                                    return AnimationConfiguration.staggeredList(
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
                                                            vertical: 5.w),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffFAFAFA),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 2,
                                                                color: black
                                                                    .withOpacity(
                                                                        0.25))
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 30,
                                                        ),
                                                        child:
                                                            presentWidget(cate),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.6,
                                                    child: EmptyScreenWidget(),
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
      );
    });
  }

  Widget presentWidget(SingleUserAttendanceModel wholedata) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Row(children: [
        Container(
          height: 70.h,
          width: 60.w,
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffE01F27).withOpacity(0.2),
          ),
          child: wholedata.employeDESCR == 'REST' ||
                  wholedata.employeDESCR == 'HOLIDAY'
              ? Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(sickImage),
                    fit: BoxFit.contain,
                  )),
                  height: 26.h,
                  width: 26.w,
                )
              : wholedata.employeDESCR == 'ABSENT' ||
                      wholedata.employeDESCR == 'LEAVE'
                  ? Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(absentimage),
                        fit: BoxFit.contain,
                      )),
                      height: 26.h,
                      width: 26.w,
                    )
                  : wholedata.employeDESCR == 'LATE'
                      ? Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(lateImage),
                            fit: BoxFit.contain,
                          )),
                          height: 26.h,
                          width: 26.w,
                        )
                      : wholedata.employeDESCR == 'PRESENT'
                          ? Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(presentimage),
                                fit: BoxFit.contain,
                              )),
                              height: 26.h,
                              width: 26.w,
                            )
                          : const SizedBox(),
        ),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                          context,
                          // 'Present',
                          wholedata.employeDESCR,
                          16.sp,
                          // color: greenShade,
                          color: wholedata.employeDESCR == "PRESENT"
                              ? greenShade
                              : readcolor,
                          fontFamily: "Poppins",
                          boldText: FontWeight.w500,
                        ),
                        text(
                          context,
                          // wholedata.attendanceDate,
                          wholedata.attendanceDate!.length > 3
                              ? '${DateFormat.E().addPattern(",").add_d().add_MMM().addPattern(",").add_y().format(DateTime.tryParse(wholedata.attendanceDate!.toString())!)}'
                              : wholedata.attendanceDate!,
                          DateFormat.EEEE()
                                      .addPattern(",")
                                      .add_d()
                                      .add_MMM()
                                      .format(DateTime.tryParse(wholedata
                                          .attendanceDate!
                                          .toString())!)
                                      .length >
                                  20
                              ? 13.sp
                              : 14.sp,
                          color: const Color(0xff263238),
                          fontFamily: "Poppins-Medium",
                          boldText: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              wholedata.employeDESCR == "PRESENT" ||
                      wholedata.employeDESCR == "LATE"
                  ? Row(
                      children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_outlined,
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
                                    text(
                                      context,
                                      // wholedata.inTime,
                                      wholedata.inTime!.length > 3
                                          ? '${DateFormat.jm().format(DateFormat("dd-MM-yyyy hh:mm").parse(wholedata.inTime!))}'
                                          : wholedata.inTime!,
                                      12.sp,
                                      color: bbColor,
                                      fontFamily: "Poppins",
                                      boldText: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_outlined,
                                  color: readcolor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(context, 'Clock out', 12.sp,
                                        color: black,
                                        fontFamily: "Poppins",
                                        boldText: FontWeight.w400),
                                    text(
                                      context,
                                      // wholedata.inTime,
                                      wholedata.inTime!.length > 3
                                          ? '${DateFormat.jm().format(DateFormat("dd-MM-yyyy hh:mm").parse(wholedata.inTime!))}'
                                          : wholedata.inTime!,
                                      12.sp,
                                      color: bbColor,
                                      fontFamily: "Poppins",
                                      boldText: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ))
                      ],
                    )
                  : SizedBox()
            ],
          ),
        )
      ]),
    );
  }
}
