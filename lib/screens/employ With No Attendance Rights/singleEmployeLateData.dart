import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/singleUserAttendanceProvider.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';

import '../../models/getAttendanceinformationofAUsera.dart';
import '../../utils/apiScreen.dart';
import '../../utils/app_routes.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_src.dart';
import '../../widgets/default_text.dart';

class SingleEmployeLateDetails extends StatefulWidget {
  const SingleEmployeLateDetails({Key? key}) : super(key: key);

  @override
  State<SingleEmployeLateDetails> createState() =>
      _SingleEmployeLateDetailsState();
}

class _SingleEmployeLateDetailsState extends State<SingleEmployeLateDetails> {
  @override
  void initState() {
    getUserName();
    // currentMonth();
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';
  String employeId = 'Unknown';
  DateTime todayDate = DateTime.now();
  getUserName() async {
    try {
      var _employeId = await SharedPref.getEmployeId();
      var _employeUsername = await SharedPref.getUserName();
      var _employeUsepassword = await SharedPref.getUserPassword();

      setState(() {
        employeId = _employeId;
        employepassword = _employeUsepassword;
        employeUserName = _employeUsername;
        currentMonth();
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

  // void lastMonth() {
  //   // currentMonthInitialdate = formatter.format(todayDate);
  //   currentMonthInitialdate = formatter.format(DateTime.now());
  //   // currentMonthLastdate = todayDate.month;
  //   var prevMonth =
  //       DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
  //   currentMonthLastdate = formatter.format(prevMonth);

  //   log("====================== Last month ====================");
  //   log('currentMonthInitialdate = $currentMonthInitialdate');
  //   log('currentMonthLastdate = $currentMonthLastdate');

  //   Apis().getSingleUserAttendanceDetail(
  //     context,
  //     employeId,
  //     employeUserName,
  //     employepassword,
  //     currentMonthInitialdate,
  //     currentMonthLastdate,
  //   );
  //   // SingleUserAttendanceDetails

  //   log("====================== Last month ====================");
  // }
    void lastMonth() {
    // currentMonthInitialdate = formatter.format(todayDate);
    currentMonthInitialdate = formatter.format(DateTime.now());
    // currentMonthLastdate = todayDate.month;
    var prevMonth =
        DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
    currentMonthLastdate = formatter.format(prevMonth);

    log("====================== Last month ====================");
    log('currentMonthInitialdate = $currentMonthInitialdate');
    log('currentMonthLastdate = $currentMonthLastdate');

    Apis().getSingleUserAttendanceDetail(
      context,
      employeId,
      employeUserName,
      employepassword,currentMonthLastdate,
      currentMonthInitialdate,
      
    );
    // SingleUserAttendanceDetails

    log("====================== Last month ====================");
  }

  void currentMonth() {
    // DateTime now = DateTime.now();
    // DateTime firstDayOfMonth = DateTime(now.year, now.month + 0, 1);
    // currentMonthInitialdate = formatter.format(firstDayOfMonth);
    // currentMonthLastdate = formatter.format(now);
      var now = DateTime.now();
    currentMonthInitialdate = formatter.format(now);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleUserAttendanceProvider>(builder: (context, prov, _) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
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
                        child: text(
                          context,
                          'Late Details',
                          22.sp,
                          fontFamily: "Poppins",
                          boldText: FontWeight.w600,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 12.h,
                    left: 15.w,
                    right: 15.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                            context,
                            'Employee Name',
                            12.sp,
                            fontFamily: 'Poppins',
                            boldText: FontWeight.w400,
                            color: black,
                          ),
                          text(
                            context,
                            employeUserName,
                            16.sp,
                            fontFamily: 'Poppins',
                            boldText: FontWeight.w600,
                            color: black,
                          ),
                        ],
                      ),
                      DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            dropdownvalue == 'Current Month'
                                ? currentMonth()
                                : dropdownvalue == 'Last Month'
                                    ? lastMonth()
                                    : const SizedBox();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                prov.singleUserAttendanceloading
                    ? const CircularProgressIndicator(
                        color: readcolor,
                      )
                    : prov.singleUserLateDetails.isEmpty
                        ? Column(
                      children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.3,
                      ),
                        Center(
                                      child: text(
                                        context,
                                        'There is no Late Detail ',
                                        15.0,
                                        color: readcolor,
                                      ),
                                    ),
                              
                      ],
                    )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: prov.singleUserLateDetails.isEmpty
                                ? 0
                                : prov.singleUserLateDetails.length,
                            itemBuilder: (context, i) {
                              SingleUserAttendanceModel cate =
                                  prov.singleUserLateDetails[i];
                              log(prov.singleUserLateDetails.length.toString());
                              debugPrint(
                                  ' cate.attendanceStatus: ${cate.attendanceStatus}');
                              debugPrint('selectedValue: $cate');
                              return prov.singleUserLateDetails.isNotEmpty
                                  ? presentWidget(cate)
                                  : Center(
                                      child: text(
                                        context,
                                        'There is no User Data ',
                                        15.0,
                                        color: readcolor,
                                      ),
                                    );
                            }),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget presentWidget(SingleUserAttendanceModel wholedata) {
    // return Text('${wholedata.toString()}');
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(children: [
        Container(
          height: 60.h,
          width: 60.w,
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffE01F27).withOpacity(0.2),
          ),
          child: wholedata.employeDESCR == "LATE"
              ? Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(lateImage),
                    fit: BoxFit.contain,
                  )),
                  height: 40.h,
                  width: 40.w,
                )
              : SizedBox(),
        ),
        SizedBox(
          width: 20.w,
        ),
        text(
          context,
          // 'Present',
          wholedata.employeDESCR == "LATE" ? 'LATE' : '',
          16.sp,
          // color: greenShade,
          color: wholedata.employeDESCR == "LATE" ? yellowShade : readcolor,
          fontFamily: "Poppins",
          boldText: FontWeight.w500,
        ),
        SizedBox(
          width: 20.w,
        ),
        Column(
          children: [
            text(
              context,
              // 'Present',
              wholedata.employeDESCR,
              16.sp,
              // color: greenShade,
              // color: wholedata.attendanceStatus == "P" ? greenShade : readcolor,
              fontFamily: "Poppins",
              boldText: FontWeight.w500,
            ),
            wholedata.employeDESCR == 'LATE'
                ? Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_sharp,
                        color: yellowShade,
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
                                ? '${wholedata.inTime!.substring(10, 16)}.'
                                : wholedata.inTime!,
                            12.sp,
                            color: black,
                            fontFamily: "Poppins",
                            boldText: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  )
                : wholedata.employeDESCR == 'LATE'
                    ? Row(
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
                              text(
                                context,
                                // wholedata.inTime,
                                wholedata.inTime!.length > 3
                                    ? '${wholedata.inTime!.substring(10, 16)}.'
                                    : wholedata.inTime!,
                                12.sp,
                                color: black,
                                fontFamily: "Poppins",
                                boldText: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
          ],
        ),
        Spacer(),
        Column(
          children: [
            text(
              context,
              // wholedata.attendanceDate,
              wholedata.attendanceDate!.length > 3
                  ? '${wholedata.attendanceDate!.substring(0, 10)}'
                  : wholedata.attendanceDate!,
              14.sp,
              color: const Color(0xff263238),
              fontFamily: "Poppins",
              boldText: FontWeight.w500,
            ),
            Row(
              children: [
                const Icon(
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
                    text(
                      context,
                      // wholedata.outTime,
                      wholedata.outTime!.length > 3
                          ? '${wholedata.outTime!.substring(10, 16)}.'
                          : wholedata.outTime!,
                      12.sp,
                      color: black,
                      fontFamily: "Poppins",
                      boldText: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
