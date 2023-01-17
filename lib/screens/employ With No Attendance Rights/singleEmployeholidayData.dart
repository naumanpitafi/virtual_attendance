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

class SingleEmployeHolidayDetails extends StatefulWidget {
  const SingleEmployeHolidayDetails({Key? key}) : super(key: key);

  @override
  State<SingleEmployeHolidayDetails> createState() =>
      _SingleEmployeHolidayDetailsState();
}

class _SingleEmployeHolidayDetailsState
    extends State<SingleEmployeHolidayDetails> {
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

  void currentMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month + 0, 1);
    currentMonthInitialdate = formatter.format(firstDayOfMonth);
    currentMonthLastdate = formatter.format(now);
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
                        child: text(context, 'Holiday Details', 22.sp,
                            fontFamily: "Poppins",
                            boldText: FontWeight.w600,
                            color: white),
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
                    :prov.singleUserHOLIDAYDetails.isEmpty?Column(
                      children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.3,
                      ),
                        Center(
                                      child: text(
                                        context,
                                        'There is no Holiday  Detail ',
                                        15.0,
                                        color: readcolor,
                                      ),
                                    ),
                              
                      ],
                    ):  ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prov.singleUserHOLIDAYDetails.isEmpty
                            ? 0
                            : prov.singleUserHOLIDAYDetails.length,
                        itemBuilder: (context, i) {
                          SingleUserAttendanceModel cate =
                              prov.singleUserHOLIDAYDetails[i];
                          log(prov.singleUserHOLIDAYDetails.length.toString());
                          debugPrint(
                              ' cate.attendanceStatus: ${cate.attendanceStatus}');
                          debugPrint('selectedValue: $cate');
                          return prov.singleUserHOLIDAYDetails.isNotEmpty
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
    return   Container(
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
            child:wholedata.employeDESCR == "HOLIDAY"? Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(

                  restDays),
                fit: BoxFit.contain,
              )),
              height: 40.h,
              width: 40.w,
            ):const SizedBox(),
          ),
          SizedBox(
            width: 20.w,
          ), text(
                context,
                wholedata.attendanceStatus =="H"? 'HOLIDAY':'',
                16.sp,
                color: wholedata.attendanceStatus
                 == "H" ? greenShade : readcolor,
                fontFamily: "Poppins",
                boldText: FontWeight.w500,
              ),
         SizedBox(
            width: 20.w,
          ),
          text(
                context,
                  wholedata.attendanceDate!.length > 3
                          ? '${wholedata.attendanceDate!.substring(0, 10)}'
                          : wholedata.attendanceDate!,
                16.sp,
                color: black,
                fontFamily: "Poppins",
                boldText: FontWeight.w500,
              ),
        ]),

      );
  }
}
