import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/mobileInforProvider.dart';
import 'package:virtual_attendance/screens/bottombar/bottomnavigationbar.dart';
import 'package:virtual_attendance/screens/login.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../widgets/bioMatericService.dart';
import 'employ With Attendance rights/markAttendance.dart';
import 'onBoarding.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // MobileInfoProvider mobileInformationProvider = MobileInfoProvider();
  var _employeId;
  var viewed;
  var supervisorStatus;
  final LocalAuthentication auth = LocalAuthentication();
  bool didauthenticate = false;
  @override
  void initState() {
    super.initState();
    // mobileInformationProvider =
    //     Provider.of<MobileInfoProvider>(context, listen: false);
//  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//         print("message recieved");
//         print(event.notification!.body);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('Message clicked!');
//     });
    Future.delayed(const Duration(seconds: 3), () {
      getUserToken();
      getModel();
      checkSignedIn();
    });
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        Provider.of<MobileInfoProvider>(context, listen: false).attendanceMode =
            androidInfo.model!.toString();
        log('attendanceMode = ${androidInfo.model!}');
        // attendanceserialNo = androidInfo.id!;
        // attendanceVersionNo = androidInfo.device!;
        var androidId = androidInfo.androidId.toString();
        Provider.of<MobileInfoProvider>(context, listen: false).devAppId =
            androidInfo.androidId.toString();
        log('androidInfo.androidId = ${androidInfo.androidId}');
        var board = androidInfo.board.toString();
        var bootloader = androidInfo.bootloader.toString();
        Provider.of<MobileInfoProvider>(context, listen: false).pMobileDevice =
            androidInfo.brand.toString();
        log(' androidInfo.brand = ${androidInfo.brand}');
        Provider.of<MobileInfoProvider>(context, listen: false)
            .pmobileDevicename = androidInfo.device.toString();
        log(' androidInfo.device = ${androidInfo.device}');
        var display = androidInfo.display;
        var fingerprint = androidInfo.fingerprint;
        var hardware = androidInfo.hardware;
        var host = androidInfo.host;
        // var id = androidInfo.id;
        Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber =
            androidInfo.id.toString();
        log(' androidInfo.id = ${androidInfo.id}');
        log('IMI = ${androidInfo.id}');
        var isPhysicalDevice = androidInfo.isPhysicalDevice;
        Provider.of<MobileInfoProvider>(context, listen: false)
            .isPhysicalDevice = androidInfo.isPhysicalDevice.toString();
        log(' androidInfo.isPhysicalDevice = ${androidInfo.isPhysicalDevice}');
        var manufacturer = androidInfo.manufacturer;

        var model = androidInfo.manufacturer;

        var product = androidInfo.product;
        Provider.of<MobileInfoProvider>(context, listen: false)
            .mobileidentifier = androidInfo.product.toString();
        log(' androidInfo.product = ${androidInfo.product}');
        var supported32BitAbis = androidInfo.supported32BitAbis;
        var supported64BitAbis = androidInfo.supported64BitAbis;
        var supportedAbis = androidInfo.supportedAbis;
        var systemFeatures = androidInfo.systemFeatures;
        var tags = androidInfo.tags;
        var type = androidInfo.type;
        // var version = androidInfo.version.securityPatch; //2020-09-05.
        // var version = androidInfo.version.previewSdkInt; //0.
        // var version = androidInfo.version.codename; // REL
        // var version = androidInfo.version.release;  //11.
        // var version = androidInfo.version.baseOS;   //.
        // var version = androidInfo.version.incremental;  // 6903271.
        var version = androidInfo.version.incremental;
        Provider.of<MobileInfoProvider>(context, listen: false).mobileVersion =
            androidInfo.version.incremental.toString();

        print(
            'Provider.of<MobileInfoProvider>(context, listen: false) = ${androidId.toString()}');
        print('This is Splash Screen ');
        print('board = ${board.toString()}');
        print('bootloader = ${bootloader.toString()}');
        print(
            'Provider.of<MobileInfoProvider>(context, listen: false).brand = ${Provider.of<MobileInfoProvider>(context, listen: false).pMobileDevice.toString()}');
        print(
            'Provider.of<MobileInfoProvider>(context, listen: false).device = ${Provider.of<MobileInfoProvider>(context, listen: false).pmobileDevicename.toString()}');
        print('display = ${display.toString()}');
        print('hardware = ${hardware.toString()}');
        print('fingerprint = ${fingerprint.toString()}');
        print('host = ${host.toString()}');
        print(
            'Provider.of<MobileInfoProvider>(context, listen: false)id = ${Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber.toString()}');
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
        print('version = $version');
        // 'version = ${Provider.of<MobileInfoProvider>(context, listen: false).mobileVersion.toString()}');
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log(iosInfo.utsname.machine.toString());
      setState(() {
        Provider.of<MobileInfoProvider>(context, listen: false).devAppId =
            iosInfo.utsname.machine;
        Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber =
            iosInfo.utsname.version;
        Provider.of<MobileInfoProvider>(context, listen: false).attendanceMode =
            iosInfo.utsname.sysname!;
        log('mobileInformationProvider.devAppId = ${Provider.of<MobileInfoProvider>(context, listen: false).devAppId}');
        log('mobileInformationProvider.devImEINumber = ${Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber}');
        log('mobileInformationProvider.attendanceMode = ${Provider.of<MobileInfoProvider>(context, listen: false).attendanceMode}');
        // attendanceMode = iosInfo.utsname.machine.toString();
        // attendanceserialNo = iosInfo.model!;
        // attendanceVersionNo = iosInfo.systemVersion!;
      });
    }
  }

  void getUserToken() async {
    firebaseMessaging.getToken().then((token) async {
      log('Device Token: $token');
      Provider.of<MobileInfoProvider>(context, listen: false).deviceToken =
          token;
      print(
          'mobileInformationProvider.deviceToken = ${Provider.of<MobileInfoProvider>(context, listen: false).deviceToken}');
    }).catchError((e) {
      log(e);
    });
  }

  void checkSignedIn() async {
    _employeId = await SharedPref.getEmployeId();
    viewed = await SharedPref.getIntroScreenState();
    supervisorStatus = await SharedPref.getisSupervisor();

    if (_employeId == null) {
      print("employe id null" + viewed.toString());

      if (viewed.toString() == 'true') {
        AppRoutes.pushAndRemoveUntil(
            context, PageTransitionType.bottomToTop, Login());
      } else {
        AppRoutes.pushAndRemoveUntil(
            context, PageTransitionType.bottomToTop, OnBoarding());
      }
    } else if (_employeId != null) {
      if (supervisorStatus == 'Y') {
        log('id admin');

        AppRoutes.pushAndRemoveUntil(
            context, PageTransitionType.bottomToTop, const MyNavigationBar());
      } else {
        log('id not  admin');

        AppRoutes.pushAndRemoveUntil(
            context, PageTransitionType.fade, const MyNavigationBar());
      }
    } else {
      AppRoutes.pushAndRemoveUntil(
          context, PageTransitionType.bottomToTop, const Login());
    }
    // AppRoutes.push(context, PageTransitionType.bottomToTop, MarkAttendance());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                logoupdate,
                width: 110.w,
                height: 94.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              text(
                context,
                "Welcome to Kohistan Logistics",
                18.sp,
                boldText: FontWeight.bold,
                color: black,
                fontFamily: "Open Sans",
              ),
              text(
                context,
                "EAMS",
                25.6.sp,
                boldText: FontWeight.bold,
                color: black,
                fontFamily: "Open Sans",
              ),
              const Spacer(),
              Image.asset(
                ustiLogo,
                width: 270.w,
                height: 32.h,
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     didauthenticate = true;

  //     log("In the try");

  //     authenticated = await auth.authenticate(
  //       localizedReason:
  //           'Scan your fingerprint (or face or whatever) to authenticate',
  //       options: const AuthenticationOptions(
  //         useErrorDialogs: true,
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),
  //     );
  //     print(" authenticated " + authenticated.toString());

  //     if (authenticated) {
  //       //main function login
  //       String username = await SharedPref.getUserName();
  //       String password = await SharedPref.getUserPassword();
  //       log("authenticate");
  //       await Apis().userLogin(
  //           context,
  //           username,
  //           password,
  //           Provider.of<MobileInfoProvider>(context, listen: false)
  //               .devImEINumber,
  //           Provider.of<MobileInfoProvider>(context, listen: false).deviceToken,
  //           Provider.of<MobileInfoProvider>(context, listen: false).devAppId,
  //           Provider.of<MobileInfoProvider>(context, listen: false)
  //               .pmobileDevicename,
  //           false,
  //           true);
  //     } else {
  //       if (Platform.isAndroid) {
  //         SystemNavigator.pop();
  //       } else if (Platform.isIOS) {
  //         exit(0);
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     print("Auth Errorr " + e.details.toString());
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }
  // }

}
