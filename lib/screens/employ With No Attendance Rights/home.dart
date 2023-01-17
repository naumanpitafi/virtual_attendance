import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_attendance/models/getEmployesAttendanceSummeryModel.dart';
import 'package:virtual_attendance/providers/employeAttendanceSummery.dart';
import 'package:virtual_attendance/providers/getEmployePlacesProvider.dart';
import 'package:virtual_attendance/providers/getEmployeesLeaveRequestDetail.dart';
import 'package:virtual_attendance/providers/loadingProvider.dart';
import 'package:virtual_attendance/providers/userProfileProvider.dart';
import 'package:virtual_attendance/screens/bottombar/bottomnavigationbar.dart';
import 'package:virtual_attendance/screens/employ%20With%20No%20Attendance%20Rights/placeDetails.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/customToast.dart';
import 'package:virtual_attendance/widgets/default_text.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_src.dart';
import '../../utils/sheared_pref_Service.dart';
import '../employ With Attendance rights/markAttendance.dart';
import '../supervisor/markEmployeAttendanc.dart';
import 'allAttendanceofSingleuser.dart';
import 'leave.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2021, 11, 7),
  );

  bool appbarvalue = false;
  // TextEditingController leaveCommintcontroller = TextEditingController();
  TimeOfDay initialTimeOftheDay = TimeOfDay.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  DateTime selectedDateTime = DateTime.now();
  DateTime todayDate = DateTime.now();
  int barderValue = 0;
  var leaveValue;
  var leaveStartdate;
  var leaveEndDate;
  TextEditingController descriptionController = TextEditingController();
  String attendancePermission = "";
  String employeCode = "";

  String attendanceMode = 'Unknown';
  String attendanceserialNo = 'Unknown';
  String attendanceVersionNo = 'Unknown';
  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';
  String employeId = '';

  // Initial Selected Value
  String dropdownvalue = 'Current Month';

  // List of items in our dropdown menu
  var items = [
    'Current Month',
    'Last Month',
  ];
  var currentMonthInitialdate;
  var currentMonthLastdate;

  void currentMonth() {
    // currentMonthInitialdate = formatter.format(todayDate);
    // currentMonthInitialdate = formatter.format(DateTime.now());

    // var prevMonth =
    //     DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
    // currentMonthLastdate = formatter.format(prevMonth);

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
    log("====================== Current getALLEmployeeAttendanceSummeryDetail month ====================");
    log('currentMonthInitialdate = $currentMonthInitialdate');
    log('currentMonthLastdate = $currentMonthLastdate');
    Apis().getALLEmployeeAttendanceSummeryDetail(
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
    // DateTime now = DateTime.now();
    // DateTime firstDayOfMonth = DateTime(now.year, now.month + 0, 1);
    // currentMonthInitialdate = formatter.format(firstDayOfMonth);
    var prevMonth = DateTime(
      todayDate.year,
      todayDate.month - 1,
    );
    currentMonthLastdate = formatter.format(prevMonth);
    log("====================== Last month ====================");
    log("currentMonthInitialdate = $currentMonthInitialdate");
    log("currentMonthLastdate = $currentMonthLastdate");
    Apis().getALLEmployeeAttendanceSummeryDetail(
      context,
      employeId,
      employeUserName,
      employepassword,
      currentMonthLastdate,
      currentMonthInitialdate,
    );
    // Apis().getSingleUserAttendanceDetail(
    //   context,
    //   employeId,
    //   employeUserName,
    //   employepassword,
    //   currentMonthLastdate,
    //   currentMonthInitialdate,
    // );
    log("====================== Last month ====================");
  }

  @override
  void initState() {
    //  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //     print("message recieved");
    //     print(event.notification!.body);
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log("message recieved");
      log("${event.notification!.body}");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Message clicked!');
    });
    getUserName();
    getModel();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log("message recieved");
      log("${event.notification!.body}");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Message clicked!');
    });
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
        var currentdatre = formatter.format(DateTime.now());
        log('currentdatre = $currentdatre');
        Apis().getpersonalEmployeeDetail(
            context, employeId, employeUserName, employepassword, currentdatre);
        Apis().getALLEmployeeDetail(
            context, employeId, employeUserName, employepassword, currentdatre);
        Apis()
            .getALLplaces(context, employeId, employeUserName, employepassword);
        currentMonthLeave();
        currentMonth();
        currentAttendance();
        getAttendanceForMap();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void currentMonthLeave() {
    // currentMonthInitialdate = formatter.format(DateTime.now());

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

    log("====================== getEmployeeLeavesDetail month ====================");
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

    log("====================== getEmployeeLeavesDetail month ====================");
  }

  void getAttendanceForMap() {
    var now = DateTime.now();
    currentMonthInitialdate = formatter.format(now);
// Find the last day of the month.
    var lastDayDateTime = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);
    currentMonthLastdate = formatter.format(lastDayDateTime);
    log(lastDayDateTime.day.toString());
    log(currentMonthLastdate);

    log("====================== getAttendanceForMap month ====================");
    log('currentMonthInitialdate getAttendanceForMap = $currentMonthInitialdate');
    log('currentMonthLastdate getAttendanceForMap = $currentMonthLastdate');

    Apis().getSingleUserAttendanceForMapScreenDetail(
      context,
      employeId,
      employeUserName,
      employepassword,
      currentMonthInitialdate,
      currentMonthLastdate,
    );

    log("====================== Current month ====================");
  }

  void currentAttendance() {
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

    Apis().getSingleUserAttendanceDetail(
      context,
      employeId,
      employeUserName,
      employepassword,
      currentMonthInitialdate,
      currentMonthLastdate,
    );

    log("====================== Current month ====================");
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

  openwhatsapp() async {
    var whatsapp = "+923136776506";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    }
  }

  List<GetEmployeAttendanceSummeryModel> attendanceSumery = [];
  @override
  Widget build(BuildContext context) {
    EmployeLeavesRequestDetailProvider employeLeavesRequestDetailProvider =
        Provider.of<EmployeLeavesRequestDetailProvider>(context);
    GetAllPlacesProvider getAllPlacesProvider =
        Provider.of<GetAllPlacesProvider>(context);
    AllEmployeAttendanceSummeryProvider getattendanceSummeryProvider =
        Provider.of<AllEmployeAttendanceSummeryProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          left: 15.w,
          right: 15.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<GetUserDetailProvider>(builder: (context, prov, _) {
                  return prov.userProfileloading
                      ? const SizedBox()
                      : prov.empDetails1.isEmpty
                          ? const SizedBox()
                          : prov.empDetails1[0].employeMArkAttendance == 'Y'
                              ? FloatingActionButton(
                                  heroTag: 'button2',
                                  elevation: 10.0,
                                  backgroundColor: Colors.transparent,
                                  onPressed: () {
                                    AppRoutes.push(
                                        context,
                                        PageTransitionType.bottomToTop,
                                        const MarkAttendance());
                                  },
                                  child: Container(
                                    //  height: 80.h,
                                    // width: 80.w,
                                    padding: EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      // color: readcolor,
                                      gradient: primaryreadGradient,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      height: 80.h,
                                      width: 80.w,
                                      decoration: const BoxDecoration(
                                        // color: readcolor,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(presentimage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ))
                              : const SizedBox();
                }),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      context,
                      'Summary',
                      16.sp,
                      fontFamily: 'Poppins-SemiBold',
                      boldText: FontWeight.w600,
                      color: bbColor,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        // Initial Value
                        value: dropdownvalue,
                        style: TextStyle(
                            color: bbColor,
                            fontFamily: 'Poppins',
                            fontSize: 14.sp),
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                                style: TextStyle(
                                    color: bbColor,
                                    fontFamily: 'Poppins',
                                    fontSize: 14.sp)),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            getattendanceSummeryProvider.setvaluesto0(true);
                            dropdownvalue == 'Last Month'
                                ? lastMonth()
                                : dropdownvalue == 'Current Month'
                                    ? currentMonth()
                                    : const SizedBox();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // padding: EdgeInsets.only(
                //   // top: 12.h,
                //   left: 15.w,
                //   right: 15.w,
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<AllEmployeAttendanceSummeryProvider>(
                        builder: (context, prov, _) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    AppRoutes.push(
                                        context,
                                        PageTransitionType.bottomToTop,
                                        SingleUserAttendanceDetails(
                                          selectedVal: 2,
                                          monthValue: dropdownvalue,
                                        ));
                                  },
                                  child: containerWidget(
                                      greenShade,
                                      'Presents',
                                      prov.present == null
                                          ? 0
                                          : (double.tryParse(prov.present))!
                                              .toStringAsFixed(0),
                                      presentimage,
                                      164.w,
                                      100.h),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    AppRoutes.push(
                                        context,
                                        PageTransitionType.bottomToTop,
                                        // const SingleUserAttendanceDetails()
                                        // SingleEmployeAbsentDetails()
                                        SingleUserAttendanceDetails(
                                          selectedVal: 3,
                                          monthValue: dropdownvalue,
                                        ));
                                    // EmployessSpAttendance
                                  },
                                  child: containerWidget(
                                    redShade,
                                    'Absents',
                                    prov.absent == null
                                        ? 0
                                        : (double.tryParse(prov.absent))!
                                            .toStringAsFixed(0),
                                    absentimage,
                                    164.w,
                                    100.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    AppRoutes.push(
                                        context,
                                        PageTransitionType.bottomToTop,
                                        // SingleEmployeLateDetails(),
                                        SingleUserAttendanceDetails(
                                          selectedVal: 5,
                                          monthValue: dropdownvalue,
                                        ));
                                  },
                                  child: containerWidget(
                                      yellowShade,
                                      'Leave',
                                      // prov.leave == null ? 0 :
                                      prov.leave,
                                      leaveImage,
                                      164.w,
                                      100.h),
                                ),
                              ),
                              SizedBox(
                                width: 20.h,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    AppRoutes.push(
                                        context,
                                        PageTransitionType.bottomToTop,
                                        // SingleEmployeLateDetails(),
                                        SingleUserAttendanceDetails(
                                          selectedVal: 4,
                                          monthValue: dropdownvalue,
                                        ));
                                  },
                                  child: containerWidget(
                                      Color(0xff1A5C9C),
                                      'Late',
                                      prov.late == null
                                          ? 0
                                          : (double.tryParse(prov.late))!
                                              .toStringAsFixed(0),
                                      lateImage,
                                      164.w,
                                      100.h),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  PageTransitionType.bottomToTop,
                                  const PlaceDetails());
                            },
                            child: containerWidgetFullWidth(
                                orangeShade,
                                'My Places',
                                "These are the places where you can mark your attendance",
                                markerPoint,
                                MediaQuery.of(context).size.width,
                                100.h,
                                "${getAllPlacesProvider.allPlacesDetails.length}"),
                          ),
                        ],
                      );
                    }),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(9.w),
                      // height: 137.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 7, color: black.withOpacity(0.25))
                        ],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(
                              context,
                              'Leaves',
                              18.sp,
                              fontFamily: 'Poppins-SemiBold',
                              color: bbColor,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppRoutes.push(
                                            context,
                                            PageTransitionType.bottomToTop,
                                            LeaveScreen(
                                              selectedVal: 1,
                                            ));
                                      },
                                      child: LeaveContainers(
                                          containerName: "Pending",
                                          value:
                                              "${employeLeavesRequestDetailProvider.pendingLeavesData.length}",
                                          image: pendingLeaves),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppRoutes.push(
                                            context,
                                            PageTransitionType.bottomToTop,
                                            LeaveScreen(
                                              selectedVal: 2,
                                            ));
                                      },
                                      child: LeaveContainers(
                                          containerName: "Approved",
                                          value:
                                              "${employeLeavesRequestDetailProvider.appreovedLeavesData.length}",
                                          image: approveLeaves),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppRoutes.push(
                                            context,
                                            PageTransitionType.bottomToTop,
                                            LeaveScreen(
                                              selectedVal: 3,
                                            ));
                                      },
                                      child: LeaveContainers(
                                          containerName: "Rejected",
                                          value:
                                              "${employeLeavesRequestDetailProvider.rejectedLeavesData.length}",
                                          image: rejectedLeaves),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            text(
                              context,
                              'Leave Request',
                              18.sp,
                              fontFamily: 'Poppins-SemiBold',
                              color: bbColor,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          barderValue = 1;
                                          leaveValue = 8;
                                        });
                                      },
                                      child: cantComeOfficeContainerWidget1(
                                          90.w, 'Sick', sickImage)),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  flex: 6,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        barderValue = 2;
                                        leaveValue = 4;
                                      });
                                    },
                                    child: cantComeOfficeContainerWidget2(
                                        146.w, 'Urgent work', urgentworkImage),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          barderValue = 3;
                                          leaveValue = 5;
                                        });
                                      },
                                      child: cantComeOfficeContainerWidget3(
                                          75.w, 'Other...', null)),
                                ),
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
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 41.h,
                                      decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            color: greyLightShade, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3,
                                              color: black.withOpacity(0.25))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                        // keyboardType: TextInputType.,
                                        // maxLines: 5,
                                      )),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      print(descriptionController.text.length);

                                      if (descriptionController.text.length <=
                                          70) {
                                        if (barderValue >= 0 &&
                                            leaveValue != null) {
                                          if (descriptionController
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
                                                                      .circular(
                                                                          8)),
                                                          child:
                                                              SfDateRangePicker(
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
                                                              DateTime(
                                                                  2021, 11, 5),
                                                              DateTime(
                                                                  2021, 11, 7),
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
                                                                      formatter
                                                                          .format(
                                                                              rangeStartDate);
                                                                  leaveStartdate =
                                                                      formatted;
                                                                  log('leave Start date = ' +
                                                                      leaveStartdate);
                                                                  final String
                                                                      formatted1 =
                                                                      formatter
                                                                          .format(
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
                                                        Provider.of<LoadingProvider>(
                                                                  context,
                                                                ).loading ==
                                                                true
                                                            ? const CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (leaveStartdate !=
                                                                          null &&
                                                                      leaveEndDate !=
                                                                          null) {
                                                                    try {
                                                                      Provider.of<LoadingProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setLoading(
                                                                              true);
                                                                      await Apis()
                                                                          .leaveRequestApi(
                                                                              context,
                                                                              employeId.toString(),
                                                                              leaveStartdate,
                                                                              leaveEndDate,
                                                                              leaveValue.toString(),
                                                                              descriptionController.text,
                                                                              employeUserName,
                                                                              attendanceMode)
                                                                          .then((value) {
                                                                        if (value ==
                                                                            true) {
                                                                          descriptionController
                                                                              .clear();
                                                                          AppRoutes.pushAndRemoveUntil(
                                                                              context,
                                                                              PageTransitionType.bottomToTop,
                                                                              const MyNavigationBar());
                                                                        } else {
                                                                          ToastUtils.showCustomToast(
                                                                              context,
                                                                              'An unexpected error occured',
                                                                              Colors.red);
                                                                        }
                                                                      });
                                                                    } finally {
                                                                      Provider.of<LoadingProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setLoading(
                                                                              false);
                                                                    }

                                                                    // AppRoutes.pop(
                                                                    //     context);
                                                                  } else {
                                                                    ToastUtils
                                                                        .showCustomToast(
                                                                      context,
                                                                      'Select Date Range for Leave',
                                                                      Colors
                                                                          .red,
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
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
                                                                        Alignment
                                                                            .center,
                                                                    child: text(
                                                                      context,
                                                                      'Submit',
                                                                      16.sp,
                                                                      color:
                                                                          white,
                                                                      boldText:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      gradient:
                                                                          primaryreadGradient,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.r)),
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
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
                                      } else {
                                        ToastUtils.showCustomToast(
                                          context,
                                          'Description must be of 70 or lower characters',
                                          Colors.red,
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 41.h,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: bbColor,
                                        border: Border.all(
                                            color: greyLightShade, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3,
                                              color: black.withOpacity(0.25))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 90.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerWidget1(
    borderColor,
    text1,
    text2,
    image,
    containerWidth,
    containerHeight,
  ) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))],
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
                  Image(image: AssetImage(image))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget containerWidget(
    borderColor,
    text1,
    text2,
    image,
    containerWidth,
    containerHeight,
  ) {
    return Container(
      height: containerHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              spreadRadius: 0, blurRadius: 7.r, color: black.withOpacity(0.25))
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.r),
                  bottomRight: Radius.circular(4.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(context, text1, 18.sp,
                          color: bbColor, fontFamily: 'Poppins-SemiBold'),
                      text(context, text2, 18.sp,
                          color: bbColor,
                          boldText: FontWeight.w500,
                          fontFamily: 'Poppins-Medium'),
                    ],
                  ),
                  // Image(image: AssetImage(image))
// <<<<<<< HEAD
                  // Container(
                  //   decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //     image: AssetImage(image),
                  //     fit: BoxFit.cover,
                  //   )),
                  //   height: 59.h,
                  //   width: 55.w,
                  // child: const Image(
                  //   image: AssetImage(presentimage),
                  // ),
// =======
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.r),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      )),
                      height: 44.h,
                      width: 44.w,
                      // child: const Image(
                      //   image: AssetImage(presentimage),
                      // ),
                    ),
// // >>>>>>> 8cc3b523c3326d41f679e5539f73ff457e61347a
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget containerWidgetFullWidth(
    borderColor,
    text1,
    text2,
    image,
    containerWidth,
    containerHeight,
    placeValue,
  ) {
    return Container(
      height: containerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              spreadRadius: 0, blurRadius: 7, color: black.withOpacity(0.25))
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        image,
                        fit: BoxFit.fill,
                        height: 46.h,
                        width: 40.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.r),
                              child: Text(text1,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontFamily: "Poppins-SemiBold",
                                    color: bbColor,
                                  )),
                            ),
                            SizedBox(
                              width: 190.w,
                              child: Text(text2,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: bbColor,
                                      fontFamily: "Poppins-Medium")),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 20.r),
                    child: Text("${placeValue}",
                        style: TextStyle(
                            color: bbColor,
                            fontSize: 22.sp,
                            fontFamily: "Poppins-Medium")),
                  )
                  // Image(image: AssetImage(image))
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
        boxShadow: [BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))],
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

  Widget cantComeOfficeWidget() {
    return Container(
      padding: EdgeInsets.all(9.w),
      // height: 137.h,
      width: 345.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(
            context,
            'Can’t come to office?',
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
                  child:
                      cantComeOfficeContainerWidget1(90.w, 'Sick', sickImage)),
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
                  child:
                      cantComeOfficeContainerWidget3(75.w, 'Other...', null)),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, 'Select Leave Start Date', 12.sp,
                      fontFamily: 'Poppins',
                      boldText: FontWeight.w600,
                      color: greyShade),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                      onTap: () {
                        _selectleaveStartDateToAdd(context);
                      },
                      child: leaveStartdate == null
                          ? leaveContainerWidget(
                              95.w,
                              'Start Date',
                            )
                          : leaveContainerWidget(
                              95.w,
                              leaveStartdate,
                            ))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, 'Select Leave End Date', 12.sp,
                      fontFamily: 'Poppins',
                      boldText: FontWeight.w600,
                      color: greyShade),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                      onTap: () {
                        _selectleaveEndDateToAdd(context);
                      },
                      child: leaveEndDate == null
                          ? leaveContainerWidget(
                              90.w,
                              'End Date',
                            )
                          : leaveContainerWidget(
                              95.w,
                              leaveEndDate,
                            ))
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          containertextfieldWidget(),
        ],
      ),
    );
  }

  Widget cantComeOfficeContainerWidget1(containerWidth, String textt, photoo) {
    return Container(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h, left: 1.w, right: 1.w),
      decoration: BoxDecoration(
        color: barderValue == 1 ? readcolor : Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 7,
            color: black.withOpacity(0.25),
          ),
        ],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          photoo == null
              ? const SizedBox()
              : Image(
                  image: AssetImage(photoo),
                  height: 21.h,
                  width: 21.w,
                ),
          text(
            context,
            textt,
            16.sp,
            boldText: FontWeight.w400,
            fontFamily: "poppins",
            color: barderValue == 1 ? white : bbColor,
          )
        ],
      ),
    );
  }

  Widget cantComeOfficeContainerWidget2(containerWidth, String textt, photoo) {
    return Container(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h, left: 1.w, right: 1.w),
      decoration: BoxDecoration(
        color: barderValue == 2 ? readcolor : Colors.white,
        // border: Border.all(
        //   color: barderValue == 2 ? readcolor : Colors.transparent,
        //   width: 2,
        // ),
        boxShadow: [BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          photoo == null
              ? const SizedBox()
              : Image(image: AssetImage(photoo), height: 21.h, width: 21.w),
          text(
            context,
            textt,
            16.sp,
            fontFamily: "Poppins",
            color: barderValue == 2 ? white : bbColor,
          )
        ],
      ),
    );
  }

  Widget cantComeOfficeContainerWidget3(containerWidth, String textt, photoo) {
    return Container(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h, left: 1.w, right: 1.w),
      decoration: BoxDecoration(
        color: barderValue == 3 ? readcolor : Colors.white,
        boxShadow: [BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: containerWidth,
      child: Center(
        child: text(context, textt, 16.sp,
            fontFamily: "Poppins", color: barderValue == 3 ? white : bbColor),
      ),
    );
  }

  _selectleaveStartDateToAdd(
    BuildContext context,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2500),
      helpText: "SELECT TO DATE",
      fieldHintText: "MONTH/DATE/YEAR",
      fieldLabelText: "TO DATE",
      errorFormatText: "Enter a Valid Date",
      errorInvalidText: "Date Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColorLight, // header background color
              onPrimary: white, // header text color
              onSurface: primaryColorDark, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: primaryColorDark, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDateTime) {
      setState(() {
        final String formatted = formatter.format(selected);
        leaveStartdate = formatted;
        log('leaveStartdate = ' + leaveStartdate);
      });
    } else if (selected != null && selected == selectedDateTime) {
      setState(() {
        final String formatted = formatter.format(selected);
        leaveStartdate = formatted;
        log('leaveStartdate = ' + leaveStartdate);
      });
    }
  }

  _selectleaveEndDateToAdd(
    BuildContext context,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2500),
      helpText: "SELECT TO DATE",
      fieldHintText: "MONTH/DATE/YEAR",
      fieldLabelText: "TO DATE",
      errorFormatText: "Enter a Valid Date",
      errorInvalidText: "Date Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColorLight, // header background color
              onPrimary: white, // header text color
              onSurface: primaryColorDark, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: primaryColorDark, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDateTime) {
      setState(() {
        final String formatted = formatter.format(selected);
        leaveEndDate = formatted;
        log('leave End date = ' + leaveEndDate);
      });
    } else if (selected != null && selected == selectedDateTime) {
      setState(() {
        final String formatted = formatter.format(selected);
        leaveEndDate = formatted;
        log('leave End date = ' + leaveEndDate);
      });
    }
  }

  Widget leaveContainerWidget(
    containerWidth,
    String textt,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))],
        borderRadius: BorderRadius.circular(4.r),
      ),
      height: 32.h,
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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

  Widget containertextfieldWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 203.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: white,
              border: Border.all(color: greyLightShade, width: 1),
              boxShadow: [
                BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))
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
        InkWell(
          onTap: () {
            if (barderValue >= 0 && leaveValue != null) {
              if (leaveStartdate != null &&
                  leaveEndDate != null &&
                  descriptionController.text.isNotEmpty) {
                log(leaveValue.toString());
                log(leaveStartdate.toString());
                log(leaveEndDate.toString());
                log(descriptionController.text);
                log(attendanceMode);
                Apis().leaveRequestApi(
                    context,
                    employeId,
                    leaveStartdate,
                    leaveEndDate,
                    leaveValue,
                    descriptionController.text,
                    employeCode,
                    attendanceMode);
                // ToastUtils.showCustomToast(
                //   context,
                //   'every thing is Fine',
                //   Colors.green,
                // );
              } else {
                ToastUtils.showCustomToast(
                  context,
                  'Start time and End time is Missing or Description',
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
              border: Border.all(color: greyLightShade, width: 1),
              boxShadow: [
                BoxShadow(blurRadius: 3, color: black.withOpacity(0.25))
              ],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Align(
                alignment: Alignment.center,
                child: text(
                  context,
                  'Inform HR',
                  16.sp,
                  color: const Color(0xffFFFFFF),
                  boldText: FontWeight.w400,
                  fontFamily: "Poppin",
                )),
          ),
        ),
      ],
    );
  }
}

class LeaveContainers extends StatelessWidget {
  LeaveContainers({
    Key? key,
    required this.containerName,
    required this.value,
    required this.image,
  }) : super(key: key);
  String image;
  String value;
  String containerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              spreadRadius: 0,
              blurRadius: 7.r,
              color: Color(0xff000000).withOpacity(0.25))
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 45.h,
            width: 45.h,
          ),
          Padding(
            padding: EdgeInsets.all(3.0.r),
            child: Text(value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: "Poppins",
                  color: bbColor,
                )),
          ),
          Text(containerName,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Poppins-Medium",
                  color: bbColor)),
        ],
      ),
    );
  }
}
