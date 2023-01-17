import 'dart:io';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:imei_plugin/imei_plugin.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/customToast.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/default_color_button.dart';
import 'package:virtual_attendance/widgets/default_text_field.dart';

import '../providers/loadingProvider.dart';
import '../providers/mobileInforProvider.dart';
import '../widgets/default_text.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  final String _identifier = 'Unknown';
  bool textVisible = true;
  var deviceToken;
  var devAppId;
  var devImEINumber;
  var attendanceMode;
  bool _rememberMe = false;
  bool? canCheckBiometrics;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool isBioLogin = false;
  bool bioCheck = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        attendanceMode = androidInfo.model!;
        // attendanceserialNo = androidInfo.id!;
        // attendanceVersionNo = androidInfo.device!;
        var androidId = androidInfo.androidId.toString();
        devAppId = androidInfo.androidId.toString();
        var board = androidInfo.board.toString();
        var bootloader = androidInfo.bootloader.toString();
        var brand = androidInfo.brand;
        var device = androidInfo.device;
        var display = androidInfo.display;
        var fingerprint = androidInfo.fingerprint;
        var hardware = androidInfo.hardware;
        var host = androidInfo.host;
        var id = androidInfo.id;
        devImEINumber = androidInfo.id;
        var isPhysicalDevice = androidInfo.isPhysicalDevice;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        var product = androidInfo.product;
        var supported32BitAbis = androidInfo.supported32BitAbis;
        var supported64BitAbis = androidInfo.supported64BitAbis;
        var supportedAbis = androidInfo.supportedAbis;
        var systemFeatures = androidInfo.systemFeatures;
        var tags = androidInfo.tags;
        var type = androidInfo.type;
        var version = androidInfo.version;

        print('androidId = ${androidId.toString()}');
        print('board = ${board.toString()}');
        print('bootloader = ${bootloader.toString()}');
        print('brand = ${brand.toString()}');
        print('device = ${device.toString()}');
        print('display = ${display.toString()}');
        print('hardware = ${hardware.toString()}');
        print('fingerprint = ${fingerprint.toString()}');
        print('host = ${host.toString()}');
        print('id = ${id.toString()}');
        print('model = ${model.toString()}');
        print('isPhysicalDevice = ${isPhysicalDevice.toString()}');
        print('manufacturer = ${manufacturer.toString()}');
        print('product = ${product.toString()}');
        print('supported32BitAbis = ${supported32BitAbis.toString()}');
        print('supported64BitAbis = ${supported64BitAbis.toString()}');
        print('supportedAbis = ${supportedAbis.toString()}');
        print('systemFeatures = ${systemFeatures.toString()}');
        print('tags = ${tags.toString()}');
        print('type = ${type.toString()}');
        print('version = ${version.codename.toString()}');
      });
      // log('attendanceMode = ' + attendanceMode);
      // log('attendanceserialNo = ' + attendanceserialNo);
      // log('attendanceVersionNo = ' + attendanceVersionNo);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log(iosInfo.utsname.machine.toString());
      setState(() {
        // attendanceMode = iosInfo.utsname.machine.toString();
        // attendanceserialNo = iosInfo.model!;
        // attendanceVersionNo = iosInfo.systemVersion!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    biocheck();
    getUserToken();
    getModel();
    isRemember();
    isbioLogincheck();
  }

  biocheck() {
    checkingForBioMetrics().then((value) {
      setState(() {
        canCheckBiometrics = value;
      });
    });
  }

  Future<bool> checkingForBioMetrics() async {
    bool? canCheck = await _localAuthentication.canCheckBiometrics;
    return canCheck;
  }

  isbioLogincheck() async {
    var bioLoginCheck = await SharedPref.getBiometricInfo();
    print("Share Prefs bioCheck $bioLoginCheck");
    if (bioLoginCheck == true) {
      setState(() {
        isBioLogin = true;
        bioCheck = true;
      });
    } else {
      setState(() {
        isBioLogin = false;
        bioCheck = false;
      });
    }
  }

  isRemember() async {
    var rememberMe = await SharedPref.getrememberMe();
    var username = await SharedPref.getUserNameRememberMe();
    var password = await SharedPref.getUserPasswordRememeberMe();

    if (rememberMe == true) {
      setState(() {
        _rememberMe = true;
        email.text = username;
        pass.text = password;
        log("message");
        log(email.text);
        log(pass.text);
      });
    }
  }

  void getUserToken() async {
    firebaseMessaging.getToken().then((token) async {
      log('Device Token: $token');
      deviceToken = token;
      print('deviceToken = $deviceToken');
    }).catchError((e) {
      log(e);
    });
  }

  String test = "TEST";
  @override
  Widget build(BuildContext context) {
    if (isBioLogin == true && bioCheck == true) {
      print("Both are true  $isBioLogin .. $bioCheck");
      _authenticateWithBiometrics();
    } else {
      print("failed by single or both  $isBioLogin .. $bioCheck ");
    }
    return Consumer<LoadingProvider>(builder: (context, prov, _) {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.96,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 60.r),
                            child: Container(
                              height: 99.h,
                              width: 110.w,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    logoupdate,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.r),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: text(context, "Welcome to", 16.sp,
                                      boldText: FontWeight.w600,
                                      color: greyShadetext,
                                      fontFamily: "Open Sans"),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: text(
                                    context,
                                    "Kohistan Logistics AMS",
                                    22.sp,
                                    boldText: FontWeight.w600,
                                    color: readcolor,
                                    fontFamily: "Open Sans",
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: text(
                                    context,
                                    "Login",
                                    18.sp,
                                    boldText: FontWeight.w700,
                                    color: readcolor,
                                    fontFamily: "DM Sans",
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          ),
                          DefaultTextField(
                            controller: email,
                            text: "Username",
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          passwordField('Password', pass),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.r, vertical: 8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildRememberMeCheckbox(),
                                _buildBiologin(),
                              ],
                            ),
                          ),
// <<<<<<< HEAD
//                           prov.loading
//                               ? const CircularProgressIndicator(
//                                   color: readcolor,
//                                 )
//                               : DefaultColorButton(
//                                   text: "Login",
//                                   press: () {
//                                        log('Emsil = ${email.text}');
//                                       log('pass = ${pass.text}');
//                                     if (email.text.isNotEmpty &&
//                                         pass.text.isNotEmpty &&
//                                         _identifier.isNotEmpty) {
//                                       log('Emsil = ${email.text}');
//                                       log('pass = ${pass.text}');
//                                       Apis().userLogin(
//                                         context,
//                                         email.text,
//                                         pass.text,
//                                         Provider.of<MobileInfoProvider>(context,
//                                                 listen: false)
//                                             .devImEINumber,
//                                         Provider.of<MobileInfoProvider>(context,
//                                                 listen: false)
//                                             .deviceToken,
//                                         Provider.of<MobileInfoProvider>(context,
//                                                 listen: false)
//                                             .devAppId,
//                                         Provider.of<MobileInfoProvider>(context,
//                                                 listen: false)
//                                             .pmobileDevicename,
//                                         _rememberMe,
//                                         bioCheck,
//                                       );
                                  
//                                     } else {
//                                       ToastUtils.showCustomToast(
//                                         context,
//                                         'Email or Password is Missing',
//                                         Colors.red,
//                                       );
//                                     }
// // =======
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.r),
                            child: prov.loading
                                ? const CircularProgressIndicator(
                                    color: readcolor,
                                  )
                                : DefaultColorButton(
                                    width: MediaQuery.of(context).size.width,
                                    text: "Login",
                                    press: () {
                                      print(email.text.toString());
                                      print(pass.text.toString());
                                      if (email.text.isNotEmpty &&
                                          pass.text.isNotEmpty &&
                                          _identifier.isNotEmpty) {
                                        Apis().userLogin(
                                            context,
                                            email.text,
                                            pass.text,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .devImEINumber,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .deviceToken,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .devAppId,
                                            Provider.of<MobileInfoProvider>(
                                                    context,
                                                    listen: false)
                                                .pmobileDevicename,
                                            _rememberMe,
                                            bioCheck);
                                      } else {
                                        ToastUtils.showCustomToast(
                                          context,
                                          'Email or Password is Missing',
                                          Colors.red,
                                        );
                                      }
// >>>>>>> 08c8ccbcbcee3b6785b1b8efdc3195948a9dbeb8

                                      // AppRoutes.push(
                                      //     context, PageTransitionType.fade, const MyNavigationBar());
                                    }),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        ustiLogo,
                        width: 270.w,
                        height: 32.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget passwordField(
    String hintText,
    TextEditingController cont,
  ) {
    return Container(
      width: 355.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greyLightShade, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Color(0xffC4C4C4))],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        cursorColor: readcolor,
        controller: cont,
        style: TextStyle(
          fontSize: 16.sp,
          color: bbColor,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w300,
        ),
        obscureText: textVisible,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  textVisible = !textVisible;
                });
              },
              child: textVisible == true
                  ? const Icon(Icons.visibility_off, color: Colors.red)
                  : const Icon(Icons.visibility, color: Colors.red)),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
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

  Widget _buildRememberMeCheckbox() {
    return Padding(
      padding: EdgeInsets.only(left: 11.r),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.transparent),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffEBEBEB),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff000000).withOpacity(0.25),
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
                borderRadius: BorderRadius.circular(3.r),
              ),
              alignment: Alignment.center,
              width: 22,
              height: 22,
              child: Checkbox(
                value: _rememberMe,
                checkColor: white,
                activeColor: readcolor,
                focusColor: readcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                onChanged: _handleRemeberme,
              ),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Text(
            'Remember Me!',
            style: TextStyle(
              fontSize: 14.sp,
              color: greyShade,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      log("In the try");

      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print(" authenticated " + authenticated.toString());

      if (authenticated) {
        //main function login
        String username = await SharedPref.getUserName();
        String password = await SharedPref.getUserPassword();
        log("authenticate $username  $password");
        await Apis().userLogin(
            context,
            username,
            password,
            Provider.of<MobileInfoProvider>(context, listen: false)
                .devImEINumber,
            Provider.of<MobileInfoProvider>(context, listen: false).deviceToken,
            Provider.of<MobileInfoProvider>(context, listen: false).devAppId,
            Provider.of<MobileInfoProvider>(context, listen: false)
                .pmobileDevicename,
            _rememberMe,
            bioCheck);
      } else {
        setState(() {
          bioCheck = false;
        });
        // if (Platform.isAndroid) {
        //   SystemNavigator.pop();
        // } else if (Platform.isIOS) {
        //   exit(0);
        // }
      }
    } on PlatformException catch (e) {
      print("Auth Errorr " + e.details.toString());
      return;
    }
    if (!mounted) {
      return;
    }
  }

  Widget _buildBiologin() {
    return Row(
      //  mainAxisAlignment: MainAxisAlignment.end,

      children: [
        if (canCheckBiometrics == true) ...[
          Text(
            "BioLogin",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: bioCheck ? readcolor : greyShade,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: readcolor,
              value: bioCheck,
              onChanged: _handleBioLogin,
            ),
          ),
        ],
      ],
    );
  }

  void _handleBioLogin(bool? value2) {
    setState(() {
      bioCheck = value2!;
    });
  }

  //handle remember me function
  void _handleRemeberme(bool? value1) {
    setState(() {
      _rememberMe = value1!;
    });
  }
}
