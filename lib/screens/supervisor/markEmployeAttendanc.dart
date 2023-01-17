import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/models/allEmployeDetailsforAttendancemodel.dart';
import 'package:virtual_attendance/providers/allEmployesDetailProvider.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/constantFile.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/utils/lottie_src.dart';
import 'package:virtual_attendance/widgets/EmptyScreenWidget.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../../providers/loadingProvider.dart';
import '../../providers/markEmployeAttendanceProvider.dart';
import '../../providers/mobileInforProvider.dart';
import '../../utils/apiScreen.dart';
import '../../utils/map_Service.dart';
import '../../utils/sheared_pref_Service.dart';
import '../../widgets/customLoadingAnimtion.dart';

class EmployessSpAttendance extends StatefulWidget {
  const EmployessSpAttendance({Key? key}) : super(key: key);

  @override
  State<EmployessSpAttendance> createState() => _EmployessSpAttendanceState();
}

class _EmployessSpAttendanceState extends State<EmployessSpAttendance> {
  TextEditingController searchController = TextEditingController();
  List filterData = [];
  int barderValue = 1;
  var leaveValue;
  GoogleMapController? _controller;
  Location currentLocation = Location();
  var todayDateTime;
  double? userCurrentLatitude;
  double? userCurrentLongitude;
  final df = DateFormat('MM-dd-yyyy hh:mm a');
  String attendanceMode = 'Unknown';
  String attendanceserialNo = 'Unknown';
  String attendanceVersionNo = 'Unknown';
  String employeUserID = '';
  String employeUserName = 'Unknown';
  String employepassword = '';
  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  String employeId = '';
  @override
  void initState() {
    getModel();
    getLocation();
    getUserName();
    super.initState();
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
      log('attendanceMode = ' + attendanceMode);
      log('attendanceserialNo = ' + attendanceserialNo);
      log('attendanceVersionNo = ' + attendanceVersionNo);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log(iosInfo.utsname.machine.toString());
      setState(() {
        attendanceMode = iosInfo.utsname.machine.toString();
      });
    }
  }

  Widget _buildImage(
      {required String assetName, double? height, double? width}) {
    return Lottie.asset(assetName, height: height, width: width);
  }

  getUserName() async {
    try {
      var _employeCode = await SharedPref.getEmployeCode();
      var _employeId = await SharedPref.getEmployeId();
      var _employeUsername = await SharedPref.getUserName();
      var _employeUsepassword = await SharedPref.getUserPassword();

      setState(() {
        employeId = _employeId;
        employepassword = _employeUsepassword;
        employeUserName = _employeUsername;
        var currentdatre = formatter.format(DateTime.now());
        log('currentdatre = $currentdatre');

        log('employeId = $employeId');
        log('employepassword = $employepassword');
        log('employeUserName = $employeUserName');
        Apis().getALLEmployeeDetail(
          context,
          employeId,
          employeUserName,
          employepassword,
          currentdatre,
        );
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void getLocation() async {
    var _employUserId = await SharedPref.getEmployeId();
    var _employUserUsername = await SharedPref.getEmployeemail();
    var _employePassword = await SharedPref.getUserPassword();
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        employeUserID = _employUserId;
        log('employeUserID = ' + employeUserID);

        employepassword = _employePassword;
        log('employepassword = ' + employepassword);

        DateTime selectedDateTime = DateTime.now();
        log('formated date time = ' + df.format(selectedDateTime));
        todayDateTime = df.format(selectedDateTime);
        log('todayDateTime = ' + todayDateTime);
        userCurrentLatitude = value.latitude;
        userCurrentLongitude = value.longitude;
        log('userCurrentLatitude = ' + userCurrentLatitude.toString());
        log('userCurrentLongitude = ' + userCurrentLongitude.toString());
      });
    });
  }

  int selectedCard = 1;
  String selectedValue = 'A';

  @override
  Widget build(BuildContext context) {
    MarEmployeAttendanceLoadingProvider allEmployesAyyyendanceLoadingProvider =
        Provider.of<MarEmployeAttendanceLoadingProvider>(context);
    List<AllEmployeDetailsforAttendancemodel> listData = [];
    return Consumer<AllEmployeDetailProvider>(builder: (context, prov, _) {
      if (selectedCard == 1) {
        listData = prov.allEmployeDetails;
      } else if (selectedCard == 2) {
        listData = prov.presentData;
      } else if (selectedCard == 3) {
        listData = prov.absentData;
      } else if (selectedCard == 4) {
        listData = prov.leaveData;
      } else if (selectedCard == 5) {
        listData = prov.lateData;
      }

      return Container(
        color: const Color(0xffF9F9F9).withOpacity(1),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffF9F9F9).withOpacity(1),
            appBar: ReusableWidgets.getAppBar(
                title: 'Employees', isBack: true, context: context),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: TextField(
                        controller: searchController,
                        onChanged: ((value) {
                          setState(() {
                            filterData = prov.allEmployeDetails
                                .where((filt) => filt.employeName
                                    .toString()
                                    .toUpperCase()
                                    .contains(searchController.text
                                        .toString()
                                        .toUpperCase()))
                                .toList();
                            print('filterData =${filterData}');
                          });
                        }),
                        decoration: myinputDecoration(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCard = 1;
                              selectedValue = 'A';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                            ),
                            height: 38.h,
                            width: 72.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedCard == 1
                                  ? readcolor
                                  : const Color(0xffE5E5E5),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: text(context, 'All', 12.sp,
                                    color: selectedCard == 1 ? white : black,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins")),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCard = 2;
                              selectedValue = 'P';
                            });
                          },
                          child: Container(
                            height: 38.h,
                            width: 111.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedCard == 2
                                  ? readcolor
                                  : const Color(0xffE5E5E5),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: text(context, 'Present', 12.sp,
                                    color: selectedCard == 2 ? white : black,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins")),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCard = 3;
                              selectedValue = 'A';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                            ),
                            height: 38.h,
                            width: 104.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedCard == 3
                                  ? readcolor
                                  : const Color(0xffE5E5E5),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: text(context, 'Absent', 12.sp,
                                    color: selectedCard == 3 ? white : black,
                                    fontFamily: "Poppins-Medium")),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCard = 4;
                              selectedValue = 'L';
                            });
                          },
                          child: Container(
                            height: 38.h,
                            width: 97.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedCard == 4
                                  ? readcolor
                                  : const Color(0xffE5E5E5),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: text(context, 'Leave', 12.sp,
                                    color: selectedCard == 4 ? white : black,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins")),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCard = 5;
                              selectedValue = 'L';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                              right: 15.w,
                            ),
                            height: 38.h,
                            width: 87.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedCard == 5
                                  ? readcolor
                                  : const Color(0xffE5E5E5),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: text(context, 'Late', 12.sp,
                                    color: selectedCard == 5 ? white : black,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  searchController.text.isEmpty
                      ? listData.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const EmptyScreenWidget())
                          : Expanded(
                              child: allEmployesAyyyendanceLoadingProvider
                                      .marEmployeAttendanceLoadingLoading
                                  ? Center(
                                      child: _buildImage(
                                          assetName: loadingImg,
                                          height: 40.h,
                                          width: 80.h))
                                  : ListView.builder(
                                      itemCount: listData.length,
                                      itemBuilder: (context, i) {
                                        AllEmployeDetailsforAttendancemodel
                                            cate = listData[i];
                                        log(prov.allEmployeDetails.length
                                            .toString());
                                        debugPrint(
                                            ' cate.attendanceStatus: ${cate.attendanceStatus}');
                                        debugPrint(
                                            'selectedValue: $selectedValue');
                                        return listData.isNotEmpty
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 15.r),
                                                child: singleAllUserData(cate),
                                              )
                                            : Center(
                                                child: text(
                                                    context,
                                                    'There is no User Data ',
                                                    15.0,
                                                    color: readcolor));
                                      }),
                            )
                      : filterData.isEmpty
                          ? Expanded(child: EmptyScreenWidget())
                          : Expanded(
                              // padding:
                              // const EdgeInsets.only(top: 10, bottom: 10),
                              // height: MediaQuery.of(context).size.height*0.7,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount:
                                    filterData.isEmpty ? 0 : filterData.length,
                                itemBuilder: (BuildContext context, i) {
                                  AllEmployeDetailsforAttendancemodel cate =
                                      filterData[i];
                                  return singleAllUserData(cate);
                                },
                              ),
                            ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget singleAllUserData(AllEmployeDetailsforAttendancemodel indexvalue) {
    return Container(
      // height: 217.h,
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: 9.h, left: 11.w, right: 11.w, bottom: 9.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(context, 'Personal Information', 14.sp,
                color: black, fontFamily: "Poppins-Medium"),
            SizedBox(
              height: 5.h,
            ),
            Container(

                // width: 322.w,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.r, vertical: 15.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: Color(0xffE01F27).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              iconwithoutCircle,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Employee Name',
                                        style: TextStyle(
                                            color: bbColor,
                                            fontFamily: "Poppins",
                                            fontSize: 12.sp)),
                                    Tooltip(
                                      triggerMode: TooltipTriggerMode.tap,
                                      message: indexvalue.employeName!,
                                      // verticalOffset: 48,
                                      height: 24,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          indexvalue.employeName!.length > 5
                                              ? '${indexvalue.employeName!.substring(0, 5)}...'
                                              : indexvalue.employeName!,
                                          style: TextStyle(
                                              color: bbColor,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: 16.sp),
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: indexvalue.attendanceStatus == 'P'
                                          ? greenShade
                                          : readcolor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: indexvalue.employeDescr == 'LEAVE'
                                          ? text(
                                              context,
                                              'LEAVE',
                                              10.sp,
                                              color: white,
                                              boldText: FontWeight.w500,
                                            )
                                          : text(
                                              context,
                                              indexvalue.attendanceStatus == 'P'
                                                  ? 'Present'
                                                  : 'Absent',
                                              10.sp,
                                              color: white,
                                              boldText: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                  text(
                                    context,
                                    'Status',
                                    10.sp,
                                    color: black,
                                    boldText: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 14.h,
                                        width: 19.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(profileNIC),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 7.r),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            text(context, 'CNIC', 12.sp,
                                                color: bbColor,
                                                fontFamily: "Poppins"),
                                            text(context,
                                                indexvalue.employeCnic, 12.sp,
                                                color: black,
                                                fontFamily: "Poppins-Medium"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 20.14.h,
                                        width: 12.5.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(profileMobile),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 7.r),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            text(context, 'Phone No', 12.sp,
                                                color: bbColor,
                                                fontFamily: "Poppins"),
                                            text(
                                                context, '+924569874575', 12.sp,
                                                color: black,
                                                fontFamily: "Poppins-Medium"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 13.5.h,
                                        width: 13.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(calenderIcon),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 7.r),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            text(
                                                context, 'Date of Birth', 12.sp,
                                                color: bbColor,
                                                fontFamily: "Poppins"),
                                            text(
                                                context,
                                                indexvalue.employeBOB!.length >
                                                        3
                                                    ? '${indexvalue.employeBOB!.substring(0, 10)}'
                                                    : indexvalue.employeBOB!,
                                                12.sp,
                                                color: black,
                                                fontFamily: "Poppins-Medium"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 19.13.h,
                                        width: 8.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                                profileEmployefathername),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 7.r),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            text(context, 'Emp Father Name',
                                                12.sp,
                                                color: bbColor,
                                                fontFamily: "Poppins"),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: text(
                                                  context,
                                                  indexvalue.employefatherName,
                                                  12.sp,
                                                  color: black,
                                                  fontFamily: "Poppins-Medium"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 7.h,
            ),
            text(context, 'Company Information', 14.sp,
                color: black, fontFamily: "Poppins-Medium"),
            SizedBox(
              height: 5.h,
            ),
            Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.r, vertical: 5.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 21.55.h,
                                    width: 12.55.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image:
                                            AssetImage(logoprofileBranchWhite),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.r),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(context, 'Branch Name', 12.sp,
                                            color: bbColor,
                                            fontFamily: "Poppins"),
                                        text(
                                            context,
                                            indexvalue.employeBranchName!,
                                            12.sp,
                                            color: black,
                                            fontFamily: "Poppins-Medium"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 13.46.h,
                                    width: 12.55.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(profileDOB),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.r),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(context, 'Date of Joining', 12.sp,
                                            color: bbColor,
                                            fontFamily: "Poppins"),
                                        text(
                                            context,
                                            indexvalue.employeDOJ!
                                                .substring(0, 10),
                                            12.sp,
                                            color: black,
                                            fontFamily: "Poppins-Medium"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 16.18.h,
                                    width: 12.55.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(profileSubDepartment),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.r),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(context, 'Department', 12.sp,
                                            color: bbColor,
                                            fontFamily: "Poppins"),
                                        text(
                                            context,
                                            indexvalue.employeDepartment!,
                                            12.sp,
                                            color: black,
                                            fontFamily: "Poppins-Medium"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 13.24.h,
                                    width: 12.55.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(profileSubDepartment),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.r),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(context, 'Sub department', 12.sp,
                                            color: bbColor,
                                            fontFamily: "Poppins"),
                                        text(
                                            context,
                                            indexvalue.employeSubDepartment,
                                            indexvalue.employeSubDepartment!
                                                        .length >
                                                    16
                                                ? 10.sp
                                                : 12.sp,
                                            color: black,
                                            fontFamily: "Poppins-Medium"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  height: 13.51.h,
                                  width: 15.w,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(designationIcion),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.r),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(context, 'Designation', 12.sp,
                                          color: bbColor,
                                          fontFamily: "Poppins"),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: text(
                                            context,
                                            indexvalue.employeDesignation!,
                                            12.sp,
                                            color: black,
                                            fontFamily: "Poppins-Medium"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(designationIcion),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.r),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(context, 'Designation', 12.sp,
                                          color: Colors.white,
                                          fontFamily: "Poppins"),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: text(
                                            context,
                                            indexvalue.employeDesignation!,
                                            12.sp,
                                            color: Colors.white,
                                            fontFamily: "Poppins-Medium"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 15.h,
            ),
            indexvalue.employeDescr == 'LEAVE'
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      indexvalue.inTime!.length == 0 ||
                              indexvalue.inTime!.isEmpty
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Apis()
                                        .markAttendanceApi(
                                      context,
                                      employeUserName,
                                      employepassword,
                                      employeUserID,
                                      // todayDateTime,
                                      df.format(DateTime.now()),
                                      Provider.of<MobileInfoProvider>(context,
                                              listen: false)
                                          .attendanceMode,
                                      Provider.of<MobileInfoProvider>(context,
                                              listen: false)
                                          .devAppId,
                                      Provider.of<MobileInfoProvider>(context,
                                              listen: false)
                                          .devImEINumber,
                                      userCurrentLatitude,
                                      // '31.55067532257941',
                                      // '74.35665174485734',
                                      // 31.5501869986124350,
                                      // 74.35718794695957,
                                      // 31.4524351893972850,
                                      // 74.26841073901737,
                                      userCurrentLongitude,
                                      'This is Remarks',
                                      indexvalue.employeId,
                                    )
                                        .then((value) async {
                                      await getUserName();
                                    });
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 157.w,
                                    decoration: BoxDecoration(
                                      color: greenShade,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.access_time_outlined,
                                          size: 20,
                                          color: white,
                                        ),
                                        // text(context, indexvalue.inTime, 23),
                                        SizedBox(width: 8.w),
                                        text(
                                          context,
                                          'Check-IN',
                                          // indexvalue.inTime,
                                          12.sp,
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          boldText: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: 'Please Check In First',
                                  // verticalOffset: 48,
                                  height: 24,
                                  child: Container(
                                    height: 40.h,
                                    width: 157.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xffB4B4B4),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.access_time_outlined,
                                          size: 20,
                                          color: white,
                                        ),
                                        // text(context, indexvalue.inTime, 23),
                                        SizedBox(width: 8.w),
                                        text(
                                          context,
                                          'Check Out',
                                          // indexvalue.inTime,
                                          12.sp,
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          boldText: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                indexvalue.inTime!.length == 0 ||
                                        indexvalue.inTime!.isEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          Apis()
                                              .markAttendanceApi(
                                            context,
                                            employeUserName,
                                            employepassword,
                                            employeUserID,
                                            // todayDateTime,
                                            df.format(DateTime.now()),
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .attendanceMode,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .devAppId,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .devImEINumber,
                                            userCurrentLatitude,
                                            // '31.55067532257941',
                                            // '74.35665174485734',
                                            // 31.5501869986124350,
                                            // 74.35718794695957,
                                            // 31.4524351893972850,
                                            // 74.26841073901737,
                                            userCurrentLongitude,
                                            'This is Remarks',
                                            indexvalue.employeId,
                                          )
                                              .then((value) async {
                                            await getUserName();
                                          });
                                        },
                                        child: Container(
                                          height: 40.h,
                                          width: 157.w,
                                          decoration: BoxDecoration(
                                            color: greenShade,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.access_time_outlined,
                                                size: 20,
                                                color: white,
                                              ),
                                              // text(context, indexvalue.inTime, 23),
                                              SizedBox(width: 8.w),
                                              text(
                                                context,
                                                'In Time',
                                                // indexvalue.inTime,
                                                12.sp,
                                                color: Colors.white,
                                                fontFamily: "Poppins",
                                                boldText: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 40.h,
                                        width: 157.w,
                                        decoration: BoxDecoration(
                                          color: greyLightShade,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: text(
                                                context,
                                                indexvalue.inTime,
                                                12.sp,
                                                color: Colors.black,
                                                fontFamily: "Poppins",
                                                boldText: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                indexvalue.outTime!.length == 0 ||
                                        indexvalue.outTime!.isEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          Apis()
                                              .markAttendanceApi(
                                            context,
                                            employeUserName,
                                            employepassword,
                                            employeUserID,
                                            // todayDateTime,
                                            df.format(DateTime.now()),
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .attendanceMode,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .devAppId,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .devImEINumber,
                                            userCurrentLatitude,

                                            // 31.4524351893972850,
                                            // 74.26841073901737,
                                            userCurrentLongitude,
                                            'This is Remarks',
                                            indexvalue.employeId,
                                          )
                                              .then((value) async {
                                            await getUserName();
                                          });
                                        },
                                        child: Container(
                                          height: 40.h,
                                          width: 157.w,
                                          decoration: BoxDecoration(
                                            color: readcolor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.access_time_outlined,
                                                size: 20,
                                                color: white,
                                              ),
                                              SizedBox(width: 8.w),
                                              text(
                                                context,
                                                'Out Time',
                                                12.sp,
                                                color: white,
                                                fontFamily: "Poppins",
                                                boldText: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 40.h,
                                        width: 157.w,
                                        decoration: BoxDecoration(
                                          color: greyLightShade,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: text(
                                            context,
                                            indexvalue.outTime,
                                            12.sp,
                                            color: black,
                                            fontFamily: "Poppins",
                                            boldText: FontWeight.w600,
                                          ),
                                        ),
                                      )
                              ],
                            ),
                    ],
                  ),
            SizedBox(
              height: 0.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget nameWidget(
    String text1,
  ) {
    return Container(
      height: 30.h,
      width: 30.h,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text1,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
