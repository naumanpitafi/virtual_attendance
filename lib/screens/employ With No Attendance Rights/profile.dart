import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_attendance/providers/employeAttendanceSummery.dart';
import 'package:virtual_attendance/providers/getSupervisorStatusProvider.dart';
import 'package:virtual_attendance/providers/singleUserAttendanceProvider.dart';
import 'package:virtual_attendance/providers/userProfileProvider.dart';
import 'package:virtual_attendance/screens/login.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/customToast.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import 'package:virtual_attendance/widgets/default_text.dart';
import 'package:virtual_attendance/widgets/default_text_field.dart';

import '../../providers/loadingProvider.dart';
import '../../utils/color_constants.dart';
import '../../widgets/default_color_button.dart';
import '../changePassword.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController remarks = TextEditingController();
  bool appbarvalue = true;
  String employeCode = "";
  String employeId = '';
  String employeUseName = '';
  String employeUsePassword = '';
  String _identifier = 'Unknown';
  @override
  void initState() {
    getUserName();
    getModel();
    super.initState();
  }

  getUserName() async {
    try {
      var _employeCode = await SharedPref.getEmployeCode();
      var _employeId = await SharedPref.getEmployeId();
      var _employeUserName = await SharedPref.getUserName();
      var _employeUserPassword = await SharedPref.getUserPassword();

      setState(() {
        employeCode = _employeCode;
        employeId = _employeId;
        employeUseName = _employeUserName;
        employeUsePassword = _employeUserPassword;
      });
      log(employeId);
      log(employeCode);
      log(employeUseName);
      log(employeUsePassword);
    } catch (e) {
      log(e.toString());
    }
  }

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _identifier = androidInfo.model!;
      });
      log(androidInfo.model.toString());
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log(iosInfo.utsname.machine.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    GetUserDetailProvider employeDetailProvider =
        Provider.of<GetUserDetailProvider>(context);
    GetSupervisorStatusProvider employeSuperVisorStatusProvider =
        Provider.of<GetSupervisorStatusProvider>(context);
    AllEmployeAttendanceSummeryProvider employeAttendancesummeryProvider =
        Provider.of<AllEmployeAttendanceSummeryProvider>(context);
    SingleUserAttendanceProvider singleUserAttendanceDetail =
        Provider.of<SingleUserAttendanceProvider>(context);
    return Consumer<GetUserDetailProvider>(builder: (context, prov, _) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ReusableWidgets.getAppBar(
              title: 'Profile', isBack: false, context: context),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70.h,
                      width: 70.w,
                      decoration: const BoxDecoration(
                        // border: Border.all(color: readcolor, width: 5),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(imageIcon),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: text(
                    context,
                    // getuserDetailProvider.empDetails1.toString(),
                    prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                        ? "Name"
                        : prov.empDetails1[0].employeName!.toString().isEmpty
                            ? 'Name'
                            : prov.empDetails1[0].employeName.toString(),
                    16.sp,
                    color: black,

                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 26.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: text(
                      context,
                      'Personal Information',
                      14.sp,
                      color: black,
                      fontFamily: 'Poppins-Medium',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileMobile,
                  'Phone No',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Phone No"
                      : prov.empDetails1[0].employeMobileNumber
                              .toString()
                              .isEmpty
                          ? 'Phone No'
                          : prov.empDetails1[0].employeMobileNumber.toString(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileNIC,
                  'CNIC',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "CNIC"
                      : prov.empDetails1[0].employeNIC.toString().isEmpty
                          ? ''
                          : prov.empDetails1[0].employeNIC.toString(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileDOB,
                  'Date of Birth',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Date of Birth"
                      : prov.empDetails1[0].employeDOB.toString().isEmpty
                          ? ''
                          : prov.empDetails1[0].employeDOB!.length > 3
                              ? prov.empDetails1[0].employeDOB!.substring(0, 10)
                              : prov.empDetails1[0].employeDOB!,

                  //  prov.empDetails1[0].employeDOB.toString(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileEmployefathername,
                  'Emp Father Name',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Father Name"
                      : prov.empDetails1[0].employeFatherName.toString().isEmpty
                          ? ''
                          : prov.empDetails1[0].employeFatherName.toString(),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 26.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: text(
                      context,
                      'Company Information',
                      14.sp,
                      color: black,
                      fontFamily: 'Poppins-Medium',
                    ),
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                profileWidget(
                  logoprofileBranchWhite,
                  'Bracnch Name',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Bracnch Name"
                      : prov.empDetails1[0].employeBranchName.toString().isEmpty
                          ? ''
                          : prov.empDetails1[0].employeBranchName.toString(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileSubDepartment,
                  'Department',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Department"
                      : prov.empDetails1[0].employeDepartment.toString().isEmpty
                          ? ''
                          : prov.empDetails1[0].employeDepartment.toString(),
                ),

                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileDepart,
                  'Sub department',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Sub department"
                      : prov.empDetails1[0].employeSubDepartment
                              .toString()
                              .isEmpty
                          ? ''
                          : prov.empDetails1[0].employeSubDepartment.toString(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileDOB,
                  'Date of Joining',
                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Date of Joining"
                      : prov.empDetails1[0].employeDOJ.toString().isEmpty
                          ? ''
                          : prov.empDetails1[0].employeDOJ!.length > 3
                              ? '${prov.empDetails1[0].employeDOJ!.substring(0, 10)}'
                              : prov.empDetails1[0].employeDOJ!,

                  // prov.empDetails1[0].employeDOJ.toString(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileWidget(
                  profileDOB,
                  'Designation',

                  prov.empDetails1.length < 0 || prov.empDetails1.isEmpty
                      ? "Designation"
                      : prov.empDetails1[0].employeDesignation
                              .toString()
                              .isEmpty
                          ? ''
                          : prov.empDetails1[0].employeDesignation.toString(),
                  // prov.empDetails1[0].employeDesignation
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 26.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: text(
                      context,
                      'Settings',
                      14.sp,
                      color: black,
                      fontFamily: 'Poppins-Medium',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                    onTap: () {
                      print("sdfsd");
                      // changePasswordDialog();
                      AppRoutes.push(context, PageTransitionType.bottomToTop,
                          const ChagePasswordScreen());
                    },
                    child: Container(child: profileChangePasswordWidget())),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                    onTap: () async {
                      employeDetailProvider.empDetails1.clear();
                      employeSuperVisorStatusProvider.superVisorStattusDetails
                          .clear();
                      employeAttendancesummeryProvider
                          .allEmployeAttendanceSummeryDetails
                          .clear();
                      employeAttendancesummeryProvider.setvaluesto0(true);
                      singleUserAttendanceDetail.singleUserAttendanceDetails
                          .clear();
                      singleUserAttendanceDetail.singleUserAttendanceDetails1
                          .clear();
                      singleUserAttendanceDetail.singleUserAbsentDetails
                          .clear();
                      singleUserAttendanceDetail.singleUserPresentDetails1
                          .clear();
                      singleUserAttendanceDetail.singleUserPresentDetails
                          .clear();
                      singleUserAttendanceDetail.singleUserLateDetails.clear();
                      singleUserAttendanceDetail.singleUserRESTDetails.clear();

                      singleUserAttendanceDetail.singleUserLeaveDetails.clear();

                      singleUserAttendanceDetail.singleUserHOLIDAYDetails
                          .clear();
                      final prefs = await SharedPreferences.getInstance();
                      var rememberMe = await SharedPref.getrememberMe();

                      var bioCheck = await SharedPref.getBiometricInfo();

                      print("$rememberMe + $bioCheck");
                      if (rememberMe == true || bioCheck == true) {
                        print("Single one tru");
                        await prefs.remove('employeID');
                        await prefs.remove('employeCode');
                        await prefs.remove('attendancePermission');
                        await prefs.remove('isSupervisor');
                      } else {
                        await prefs.remove('userName');
                        await prefs.remove('userPassword');
                        await prefs.remove('employeID');
                        await prefs.remove('employeCode');
                        await prefs.remove('attendancePermission');
                        await prefs.remove('isSupervisor');
                      }

                      // log('All Done');
                      AppRoutes.pushAndRemoveUntil(context,
                          PageTransitionType.bottomToTop, const Login());
                    },
                    child: profileLogoutWidget()),
                // GestureDetector(
                //   onTap: () {
                //     changePasswordDialog();
                //   },
                //   child: Container(
                //     padding: EdgeInsets.only(left: 26.w, right: 26.w),
                //     width: 374.w,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: 24.h,
                //           width: 24.w,
                //           child: const Image(
                //             image: AssetImage(forgetPass),
                //           ),
                //         ),
                //         SizedBox(
                //           width: 15.w,
                //         ),
                //         text(
                //           context,
                //           'Change Password',
                //           15.sp,
                //           color: black,
                //           boldText: FontWeight.w500,
                //           fontFamily: 'Work Sans',
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10.h,
                // ),
                // GestureDetector(
                //   onTap: () async {
                //     // Obtain shared preferences.
                //     final prefs = await SharedPreferences.getInstance();
                //     await prefs.remove('employeID');
                //     await prefs.remove('employeCode');
                //     await prefs.remove('attendancePermission');
                //     await prefs.remove('isSupervisor');
                //     await prefs.remove('remember_me');
                //     await prefs.remove('userName');
                //     await prefs.remove('userPassword');

                //     log('All Done');
                //     AppRoutes.pushAndRemoveUntil(
                //         context, PageTransitionType.bottomToTop, const Login());
                //   },
                //   child: Container(
                //     padding: EdgeInsets.only(left: 26.w, right: 26.w),
                //     width: 374.w,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: 24.h,
                //           width: 24.w,
                //           child: const Image(
                //             image: AssetImage(forgetPass),
                //           ),
                //         ),
                //         SizedBox(
                //           width: 15.w,
                //         ),
                //         text(
                //           context,
                //           'Log Out',
                //           15.sp,
                //           color: black,
                //           boldText: FontWeight.w500,
                //           fontFamily: 'Work Sans',
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  changePasswordDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.r,
            ),
          ),
          child: SizedBox(
            height: 380.h,
            width: 360.w,
            child: Column(
              children: [
                Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: readcolor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 6.w, right: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        color: white,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      text(context, 'Change Password', 14.sp,
                          boldText: FontWeight.w600, color: white),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.w),
                  child: Column(
                    children: [
                      DefaultTextField(
                        controller: pass,
                        text: "Old Password",
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultTextField(
                        controller: confirmPass,
                        text: "Confirm Password",
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultTextField(
                        controller: remarks,
                        text: "Remarks",
                      ),
                      SizedBox(
                        height: 45.h,
                      ),
                      Provider.of<LoadingProvider>(context, listen: false)
                              .loading
                          ? const CircularProgressIndicator(
                              color: primaryColorDark,
                            )
                          : DefaultColorButton(
                              width: 335.w,
                              text: "Change Password",
                              press: () {
                                if (pass.text.isNotEmpty &&
                                    confirmPass.text.isNotEmpty &&
                                    remarks.text.isNotEmpty) {
                                  if (employeUsePassword != pass.text) {
                                    log(pass.text);
                                    log(employeUsePassword);
                                    log(confirmPass.text);
                                    log(remarks.text);
                                    log(employeUseName);
                                    log(employeCode);
                                    log(employeId);
                                    ToastUtils.showCustomToast(
                                      context,
                                      'Old Password is incorrect',
                                      Colors.orange,
                                    );
                                  } else {
                                    log(pass.text);
                                    log(confirmPass.text);
                                    log(remarks.text);
                                    log(employeUseName);
                                    log(employeUsePassword);
                                    log(employeCode);
                                    log(employeId);
                                    Apis().changeUserPassword(
                                        context,
                                        pass.text,
                                        confirmPass.text,
                                        remarks.text,
                                        employeUseName,
                                        employeUsePassword,
                                        employeCode,
                                        employeId,
                                        _identifier);
                                  }
                                } else {
                                  ToastUtils.showCustomToast(
                                    context,
                                    'Email or Password is Missing',
                                    Colors.red,
                                  );
                                }
                              }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget iconTextRowWidget(
    text1,
    img,
  ) {
    return Row(
      children: [
        SizedBox(
          height: 21.h,
          width: 21.w,
          child: Image(
            image: AssetImage(img),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        text(
          context,
          text1,
          15.sp,
          color: black,
          boldText: FontWeight.w500,
          fontFamily: 'Work Sans',
        ),
      ],
    );
  }

  Widget textRowWidget(
    text1,
    text2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
          context,
          text1,
          15.sp,
          color: black,
          boldText: FontWeight.w500,
          fontFamily: 'Work Sans',
        ),
        text(
          context,
          text2,
          11.sp,
          color: bbColor,
          boldText: FontWeight.w400,
          fontFamily: 'Work Sans',
        ),
      ],
    );
  }

  Widget profileWidget(
    image,
    text1,
    text2,
  ) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.r),
        padding: EdgeInsets.only(
          top: 8.h,
          bottom: 8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xffE01F27).withOpacity(0.20),
            width: 1,
          ),
          // color: const Color(0xffE01F27),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 21.h,
                width: 23.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, text1, 12.sp,
                      color: const Color(0xff676060), fontFamily: "Poppins"),
                  text(context, text2, 14.sp,
                      color: const Color(0xff2A2E32),
                      fontFamily: "Poppins-Medium"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget profileChangePasswordWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 60.h,
        margin: EdgeInsets.symmetric(horizontal: 20.r),
        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xffE01F27).withOpacity(0.20),
            width: 1,
          ),
          // color: const Color(0xffE01F27),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Container(
                  height: 27.h,
                  width: 30.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        changePassword1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 17,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(context, 'Change Password', 14.sp,
                      color: const Color(0xff2A2E32),
                      fontFamily: "Poppins-Medium"),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: black,
                    size: 15,
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox())
          ],
        ),
      ),
    );
  }

  Widget profileLogoutWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 60.h,
        margin: EdgeInsets.symmetric(horizontal: 20.r),
        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xffE01F27).withOpacity(0.20),
            width: 1,
          ),
          // color: const Color(0xffE01F27),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20.h,
              width: 23.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(logout),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            text(context, 'Log Out', 14.sp,
                color: readcolor, fontFamily: "Poppins-Medium"),
          ],
        ),
      ),
    );
  }
}
