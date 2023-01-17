import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/loadingProvider.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/customToast.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import 'package:virtual_attendance/widgets/default_color_button.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../utils/color_constants.dart';
import '../utils/image_src.dart';
import '../utils/sheared_pref_Service.dart';
import '../widgets/default_text_field.dart';

class ChagePasswordScreen extends StatefulWidget {
  const ChagePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChagePasswordScreen> createState() => _ChagePasswordScreenState();
}

class _ChagePasswordScreenState extends State<ChagePasswordScreen> {
  TextEditingController oldpass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();
  bool textVisible1 = false;
  bool textVisible2 = false;
  bool textVisible3 = false;
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
    return Consumer<LoadingProvider>(builder: (context, prov, _) {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: ReusableWidgets.getAppBar(
                title: 'Change Password', isBack: true, context: context),
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 35.h,
                ),
                Container(
                  height: 245.h,
                  width: 252.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(changePasswordImage),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: enterOldpassword(
                    oldpass, 'Enter old Password',
                    // controller: oldpass,
                    // text: "Enter old Password",
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 103.w, right: 103.w),
                  child: Divider(
                    thickness: 1,
                    color: greyShade.withOpacity(0.4),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: enterNewpassword(newPass, "New Password"
                      // controller: newPass,
                      // text: "New Password",
                      ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // DefaultTextField(
                //   controller: confirmNewPass,
                //   text: "Confirm New Password",
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: confirmNewPassword(
                    "Confirm New Password",
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                prov.loading
                    ? const CircularProgressIndicator(
                        color: readcolor,
                      )
                    : DefaultColorButton(
                        width: 335.w,
                        text: "Save Changes",
                        press: () {
                          if (oldpass.text.isNotEmpty &&
                              newPass.text.isNotEmpty &&
                              confirmNewPass.text.isNotEmpty) {
                            if (oldpass.text == employeUsePassword &&
                                newPass.text == confirmNewPass.text &&
                                oldpass.text != newPass.text) {
                              log('everything done');
                              Apis().changeUserPassword(
                                  context,
                                  oldpass.text,
                                  newPass.text,
                                  'This is Password remarks',
                                  employeUseName,
                                  employeUsePassword,
                                  employeCode,
                                  employeId,
                                  _identifier);
                            } else {
                              log('everything not ok');
                              ToastUtils.showCustomToast(
                                context,
                                'Password is incorrect',
                                Colors.red,
                              );
                            }
                          } else {
                            ToastUtils.showCustomToast(
                              context,
                              'Password is Missing',
                              Colors.red,
                            );
                          }
                        }),
              ],
            )),
          ),
        ),
      );
    });
  }

  Widget confirmNewPassword(text) {
    return Container(
      width: 355.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greyLightShade, width: 1),
        boxShadow: [
          BoxShadow(blurRadius: 7.r, color: Colors.black.withOpacity(0.25))
        ],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        cursorColor: readcolor,
        controller: confirmNewPass,
        obscureText: !textVisible3,
        // onChanged: (val) {
        //   if (val != newPass.text) {
        //     ToastUtils.showCustomToast(
        //       context,
        //       'Old and New Password is Not Same',
        //       Colors.red,
        //     );
        //   } else {
        //     log('Done');
        //     ToastUtils.showCustomToast(
        //       context,
        //       'Old and New Password is Same',
        //       Colors.green,
        //     );
        //   }
        // },
        style: const TextStyle(
          fontSize: 16,
          color: bbColor,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w300,
        ),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  textVisible3 = !textVisible3;
                });
              },
              child: textVisible3
                  ? const Icon(Icons.visibility, color: Colors.red)
                  : const Icon(Icons.visibility_off, color: Colors.red)),
          hintText: text,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: greyShade,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
          fillColor: const Color(0xFFFFFFFF),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget enterOldpassword(
    controller,
    text,
  ) {
    return Container(
      width: 355.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greyLightShade, width: 1),
        boxShadow: [
          BoxShadow(blurRadius: 7.r, color: Colors.black.withOpacity(0.25))
        ],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        obscureText: !textVisible1,
        cursorColor: readcolor,
        controller: controller,
        style: TextStyle(
          fontSize: 16.sp,
          color: bbColor,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w300,
        ),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  textVisible1 = !textVisible1;
                });
              },
              child: textVisible1
                  ? const Icon(
                      Icons.visibility,
                      color: Colors.red,
                    )
                  : const Icon(Icons.visibility_off, color: Colors.red)),
          hintText: text,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: greyShade,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
          fillColor: const Color(0xFFFFFFFF),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget enterNewpassword(
    controller,
    text,
  ) {
    return Container(
      width: 355.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greyLightShade, width: 1),
        boxShadow: [
          BoxShadow(blurRadius: 7.r, color: Colors.black.withOpacity(0.25))
        ],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        obscureText: !textVisible2,
        cursorColor: readcolor,
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
          color: bbColor,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w300,
        ),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  textVisible2 = !textVisible2;
                });
              },
              child: textVisible2
                  ? const Icon(Icons.visibility, color: Colors.red)
                  : const Icon(Icons.visibility_off, color: Colors.red)),
          hintText: text,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: greyShade,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
          fillColor: const Color(0xFFFFFFFF),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
