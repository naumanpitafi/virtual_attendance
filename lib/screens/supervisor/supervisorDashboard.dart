import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/default_text.dart';
import '../../providers/loadingProvider.dart';
import '../../utils/app_routes.dart';
import '../../utils/customToast.dart';
import '../../utils/image_src.dart';
import '../employ With Attendance rights/markAttendance.dart';
import 'markEmployeAttendanc.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({Key? key}) : super(key: key);

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  final List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(2021, 8, 10),
    DateTime(2021, 8, 13),
  ];
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2021, 11, 7),
  );

  bool appbarvalue = true;
  // TextEditingController leaveCommintcontroller = TextEditingController();
  TimeOfDay initialTimeOftheDay = TimeOfDay.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  DateTime selectedDateTime = DateTime.now();
  int barderValue = 0;
  var leaveValue;
  var leaveStartdate;
  var leaveEndDate;
  TextEditingController descriptionController = TextEditingController();
  String attendancePermission = "";
  String employeCode = "";
  String employeId = '';
  String attendanceMode = 'Unknown';
  String attendanceserialNo = 'Unknown';
  String attendanceVersionNo = 'Unknown';
  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';

  @override
  void initState() {
    getUserName();
    getModel();
    super.initState();
  }

  getUserName() async {
    try {
      var _attendancePermission = await SharedPref.getAttendancePermission();
      var _employeCode = await SharedPref.getEmployeCode();
      var _employeId = await SharedPref.getEmployeId();
      var _employeUsername = await SharedPref.getUserName();
      var _employeUsepassword = await SharedPref.getUserPassword();

      setState(() {
        attendancePermission = _attendancePermission;
        employeCode = _employeCode;
        employeId = _employeId;
        employepassword = _employeUsepassword;
        employeUserName = _employeUsername;
        Apis().getpersonalEmployeeDetail(
            context, employeId, employeUserName, employepassword,'01-apr-2022' );
        Apis().getALLEmployeeDetail(
            context, employeId, employeUserName, employepassword,'01-apr-2022');
      });
      // log('employeId = ' + employeId);
      // log('employeCode = ' + employeCode);
      // log('attendancePermission = ' + attendancePermission);
      // log('employepassword = ' + employepassword);
      // log('employeUserName = ' + employeUserName);
    } catch (e) {
      log(e.toString());
    }
  }

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        attendanceMode = androidInfo.model!;
        attendanceserialNo = androidInfo.id!;
        attendanceVersionNo = androidInfo.device!;
      });
      // log('attendanceMode = ' + attendanceMode);
      // log('attendanceserialNo = ' + attendanceserialNo);
      // log('attendanceVersionNo = ' + attendanceVersionNo);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log(iosInfo.utsname.machine.toString());
      setState(() {
        attendanceMode = iosInfo.utsname.machine.toString();
        attendanceserialNo = iosInfo.model!;
        attendanceVersionNo = iosInfo.systemVersion!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(builder: (context, prov, _) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    AppRoutes.push(context, PageTransitionType.bottomToTop,
                        const EmployessSpAttendance());
                  },
                  child: Container(
                    // height: 250.h,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,

                    child: Column(
                      children: [
                        Container(
                          height: 103.h,
                          width: MediaQuery.of(context).size.width,
                          // height: 250.h,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(klc),
                            ),
                            gradient: primaryreadGradient,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5.w,
                            right: 5.w,
                            left: 5.w,
                          ),
                          padding: EdgeInsets.all(5.h),
                          alignment: Alignment.center,
                          height: 70.h,
                          width: 375.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.r),
                              bottomRight: Radius.circular(5.r),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Image(
                                image: AssetImage(presentimage),
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(context, 'Mark Employees ', 16.sp,
                                      color: readcolor,
                                      boldText: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                  text(context, 'Attendance', 16.sp,
                                      color: readcolor,
                                      boldText: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ],
                              ),
                              Expanded(child: Container()),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                              AppRoutes.push(
                              context,
                              PageTransitionType.topToBottom,
                              const MarkAttendance());
                        },
                        child: leavesWidgets(
                          'Mark Your Attendance',
                          formatter.format(selectedDateTime),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(context, 'Employes', 16.sp,
                            fontFamily: "Poppins",
                            boldText: FontWeight.w600,
                            color: const Color(0xff676060)),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          containerWidget(redShade, 'Absents', '03',
                              absentimage, 164.w, 100.h),
                          containerWidget(greenShade, 'Presents', '19',
                              presentimage, 164.w, 100.h),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          containerWidget(yellowShade, 'Leaves', '03',
                              leaveImage, 164.w, 100.h),
                          containerWidget(
                              readcolor, 'Late', '05', lateImage, 164.w, 100.h),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(9.w),
                  // height: 137.h,
                  width: 345.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))
                    ],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        context,
                        'Leave Request',
                        18.sp,
                        fontFamily: 'Poppins',
                        boldText: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  barderValue = 1;
                                  leaveValue = 8;
                                });
                              },
                              child: cantComeOfficeContainerWidget1(
                                  90.w, 'Sick', sickImage)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                barderValue = 2;
                                leaveValue = 4;
                              });
                            },
                            child: cantComeOfficeContainerWidget2(
                                146.w, 'Urgent work', urgentworkImage),
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  barderValue = 3;
                                  leaveValue = 5;
                                });
                              },
                              child: cantComeOfficeContainerWidget3(
                                  75.w, 'Other', urgentworkImage)),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    
                      SizedBox(
                        height: 10.h,
                      ),
                      // containertextfieldWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 203.w,
                              height: 41.h,
                              decoration: BoxDecoration(
                                color: white,
                                border:
                                    Border.all(color: greyLightShade, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      color: black.withOpacity(0.25))
                                ],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextFormField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.r),
                                    ),
                                    borderSide: const BorderSide(
                                      width: 2,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.r),
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.r),
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      )),
                                  filled: true,
                                  // prefixIcon: icondata,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 10.w,
                                  ),
                                  hintText: 'Enter Description',
                                  hintStyle: const TextStyle(
                                    color: Color(0xff929292),
                                  ),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                              )),
                          prov.loading
                              ? const CircularProgressIndicator(
                                  color: primaryColorDark,
                                )
                              : InkWell(
                                  onTap: () {
                                    log('asddfgg');

                                    if (barderValue >= 0 &&
                                        leaveValue != null) {
                                      if (

                                          // leaveStartdate != null &&
                                          //   leaveEndDate != null &&
                                          descriptionController
                                              .text.isNotEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20.0,
                                                ),
                                              ),
                                              child: SizedBox(
                                                height: 370,
                                                width: 120,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Container(
                                                      height: 300,
                                                      // width: 120,

                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: SfDateRangePicker(
                                                        backgroundColor:
                                                            Colors.white,
                                                        startRangeSelectionColor:
                                                            primaryColorDark,
                                                        endRangeSelectionColor:
                                                            readcolor,
                                                        // showTodayButton: true,
                                                        selectionMode:
                                                            DateRangePickerSelectionMode
                                                                .range,
                                                        showActionButtons:
                                                            false,
                                                        initialSelectedRange:
                                                            PickerDateRange(
                                                          DateTime(2021, 11, 5),
                                                          DateTime(2021, 11, 7),
                                                        ),
                                                        onSelectionChanged:
                                                            (DateRangePickerSelectionChangedArgs
                                                                args) {
                                                          if (args.value
                                                              is PickerDateRange) {
                                                            setState(() {
                                                              final DateTime
                                                                  rangeStartDate =
                                                                  args.value
                                                                      .startDate;
                                                              final DateTime
                                                                  rangeEndDate =
                                                                  args.value
                                                                      .endDate;
                                                              log(rangeStartDate
                                                                  .toString());
                                                              log(rangeEndDate
                                                                  .toString());

                                                              final String
                                                                  formatted =
                                                                  formatter.format(
                                                                      rangeStartDate);
                                                              leaveStartdate =
                                                                  formatted;
                                                              log('leave Start date = ' +
                                                                  leaveStartdate);
                                                              final String
                                                                  formatted1 =
                                                                  formatter.format(
                                                                      rangeEndDate);
                                                              leaveEndDate =
                                                                  formatted1;
                                                              log('leave End date = ' +
                                                                  leaveEndDate);
                                                            });
                                                          } else {
                                                            final List<
                                                                    PickerDateRange>
                                                                selectedRanges =
                                                                args.value;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (leaveStartdate !=
                                                                null &&
                                                            leaveEndDate !=
                                                                null) {
                                                          Apis().leaveRequestApi(
                                                              context,
                                                              employeId
                                                                  .toString(),
                                                              leaveStartdate,
                                                              leaveEndDate,
                                                              leaveValue
                                                                  .toString(),
                                                              descriptionController
                                                                  .text,
                                                              employeCode,
                                                              attendanceMode);
                                                        } else {
                                                          ToastUtils
                                                              .showCustomToast(
                                                            context,
                                                            'Select Date Range for Leave',
                                                            Colors.red,
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        // width: 120,
                                                        // margin: EdgeInsets
                                                        //     .only(
                                                        //         left:
                                                        //            8.w,
                                                        //         right:
                                                        //           8.w),

                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: text(
                                                            context,
                                                            'Submit',
                                                            16.sp,
                                                            color: white,
                                                            boldText:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            gradient:
                                                                primaryreadGradient,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                        // log(leaveValue.toString());
                                        // log(leaveStartdate.toString());
                                        // log(leaveEndDate.toString());
                                        // log(descriptionController.text);
                                        // log(_identifier);
                                        // Apis().leaveRequestApi(
                                        //     context,
                                        //     employeId.toString(),
                                        //     leaveStartdate,
                                        //     leaveEndDate,
                                        //     leaveValue.toString(),
                                        //     descriptionController.text,
                                        //     employeCode,
                                        //     attendanceMode);
                                      } else {
                                        ToastUtils.showCustomToast(
                                          context,
                                          ' Description is Missing',
                                          Colors.red,
                                        );
                                      }
                                    } else {
                                      ToastUtils.showCustomToast(
                                        context,
                                        'Select only one Reason for Leave',
                                        Colors.red,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 41.h,
                                    width: 111.w,
                                    decoration: BoxDecoration(
                                      color: bbColor,
                                      border: Border.all(
                                          color: greyLightShade, width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 3,
                                            color: black.withOpacity(0.25))
                                      ],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: text(
                                          context,
                                          'Select date',
                                          16.sp,
                                          color: const Color(0xffFFFFFF),
                                          boldText: FontWeight.w400,
                                          fontFamily: "Poppin",
                                        )),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });}

    Widget containerWidget(
        borderColor, text1, text2, image, containerWidth, containerHeight) {
      return Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))
          ],
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  bottomLeft: Radius.circular(4.r),
                ),
              ),
              width: 10,
            ),
            Expanded(
              child: Container(
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(context, text1, 18.sp,
                            boldText: FontWeight.bold, fontFamily: 'Poppins'),
                        text(context, text2, 18.sp,
                            boldText: FontWeight.w500, fontFamily: 'Poppins'),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      )),
                      height: 55.h,
                      width: 55.w,
                    ),
                    // Image(
                    //   image: AssetImage(image),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget leavesWidgets(
      text1,
      text2,
    ) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))
          ],
        ),
        margin: EdgeInsets.only(
          bottom: 5.w,
          right: 5.w,
          left: 5.w,
        ),
        padding: EdgeInsets.all(5.h),
        alignment: Alignment.center,
        // height: 70.h,
        width: 375.w,

        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(presentimage),
                fit: BoxFit.cover,
              )),
              height: 55.h,
              width: 55.w,
            ),
            // const Image(
            //   image: AssetImage(presentimage),
            // ),
            SizedBox(
              width: 20.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(context, text1, 16.sp,
                    color: readcolor,
                    boldText: FontWeight.w600,
                    fontFamily: 'Poppins'),
                Row(
                  children: [
                    text(context, text2, 12.sp,
                        color: greyShade,
                        boldText: FontWeight.w400,
                        fontFamily: 'Poppins'),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      );
    }
  
    Widget cantComeOfficeContainerWidget1(containerWidth, String textt, photoo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: barderValue == 1 ? readcolor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          photoo == null ? const SizedBox() : Image(image: AssetImage(photoo)),
          text(
            context,
            textt,
            16.sp,
            boldText: FontWeight.w400,
            fontFamily: "poppins",
          )
        ],
      ),
    );
  }

  Widget cantComeOfficeContainerWidget2(containerWidth, String textt, photoo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: barderValue == 2 ? readcolor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          photoo == null ? const SizedBox() : Image(image: AssetImage(photoo)),
          text(
            context,
            textt,
            16.sp,
            boldText: FontWeight.w400,
            fontFamily: "poppins",
          )
        ],
      ),
    );
  }

  Widget cantComeOfficeContainerWidget3(containerWidth, String textt, photoo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: barderValue == 3 ? readcolor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          photoo == null ? const SizedBox() : Image(image: AssetImage(photoo)),
          text(
            context,
            textt,
            16.sp,
            boldText: FontWeight.w400,
            fontFamily: "poppins",
          )
        ],
      ),
    );
  }

  
  
  
  }




