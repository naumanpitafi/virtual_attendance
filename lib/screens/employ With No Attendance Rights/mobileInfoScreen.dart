import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/mobileInforProvider.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../../utils/apis_Url.dart';
import '../../utils/customToast.dart';
import '../../widgets/default_color_button.dart';

class MobileInfoScreen extends StatefulWidget {
  const MobileInfoScreen({Key? key}) : super(key: key);

  @override
  State<MobileInfoScreen> createState() => _MobileInfoScreenState();
}

class _MobileInfoScreenState extends State<MobileInfoScreen> {
  TextEditingController reviewController = TextEditingController();
  @override
  void initState() {
    getLocationForAttendance();
    getUserName();
    super.initState();
  }

  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';
  String employeId = '';
  late LatLng currentLaltg;
  final df = DateFormat('MM-dd-yyyy hh:mm a');
  var todayDateTime;
  String? userCurrentAddress;
  DateTime currentDateTime = DateTime.now();
  double? userAttendaceCurrentLatitude;
  double? userAttendaceCurrentLongitude;
  getLocationForAttendance() async {
    log('i am in the location function');
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      log("Location is Off =======================>>");
    } else {
      log("Location is ON =======================>>");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      log('position: $position');

      currentLaltg = LatLng(position.latitude, position.longitude);
      log('currentLaltg: $currentLaltg');
      DateTime selectedDateTime = DateTime.now();
      log('formated date time = ' + df.format(selectedDateTime));
      todayDateTime = df.format(selectedDateTime);
      log('todayDateTime = ' + todayDateTime);
      log(position.latitude.toString());
      log(position.longitude.toString());
      userAttendaceCurrentLatitude = position.latitude;
      userAttendaceCurrentLongitude = position.longitude;

      log('userAttendaceCurrentLatitude = ' +
          userAttendaceCurrentLatitude.toString());
      log('userAttendaceCurrentLongitude = ' +
          userAttendaceCurrentLongitude.toString());
      GetAddressFromLatLong(
          userAttendaceCurrentLatitude, userAttendaceCurrentLongitude);

      log('===========================Alll Done ===========');
      ToastUtils.showCustomToast(
        context,
        'Rouster Not Genereted',
        Colors.green,
      );
    }
  }

  Future<void> GetAddressFromLatLong(a, b) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(a, b);
    // print(placemarks);
    Placemark place = placemarks[0];
    userCurrentAddress = '${place.street}, ${place.subLocality}';
    setState(() {});
  }

  var _employeId;
  var _employeUsername;
  var _employeUsepassword;
  var employeLoginDateTime;
  var isPhysicalDevice;
  var pmobileDevice;
  var mobileVersion;
  var devAppId;
  var deviceToken;
  var devImEINumber;
  getUserName() async {
    try {
      _employeId =
          await Provider.of<MobileInfoProvider>(context, listen: false).userId;
      _employeUsername =
          await Provider.of<MobileInfoProvider>(context, listen: false)
              .username;
      _employeUsepassword =
          await Provider.of<MobileInfoProvider>(context, listen: false)
              .userPassword;

      isPhysicalDevice = Provider.of<MobileInfoProvider>(context, listen: false)
          .isPhysicalDevice;

      pmobileDevice =
          Provider.of<MobileInfoProvider>(context, listen: false).pMobileDevice;

      mobileVersion =
          Provider.of<MobileInfoProvider>(context, listen: false).mobileVersion;
      devAppId =
          Provider.of<MobileInfoProvider>(context, listen: false).devAppId;
      deviceToken =
          Provider.of<MobileInfoProvider>(context, listen: false).deviceToken;
      devImEINumber =
          Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber;
      employeLoginDateTime = df.format(DateTime.now());

      log('employeLoginDateTime 11 = $employeLoginDateTime');
      log('isPhysicalDevice  11 = $isPhysicalDevice');
      log('pmobileDevice  11 = $pmobileDevice');
      log('mobileVersion 11 = $mobileVersion');
      log('devAppId  11= $devAppId');
      log('deviceToken  11= $deviceToken');
      log('devImEINumber  11= $devImEINumber');

      setState(() {
        employeId = _employeId;
        employepassword = _employeUsepassword;
        employeUserName = _employeUsername;
        log('employeId = $employeId');
        log('employepassword = $employepassword');
        log('employeUserName = $employeUserName');
      });

      // log('===================================== my ============================ ');

      // '${ApiURls.baseURL}${ApiURls.userLoginLogsSave}pusername=$employeUserName&ppassword=$employepassword&pemp_id=$employeId&pmobiledevice=${Provider.of<MobileInfoProvider>(context, listen: false).pMobileDevice}&plogindatetime=${Provider.of<MobileInfoProvider>(context, listen: false).employeLoginDateTime}&pissuccessful=Y&pisphysicaldevice=Y&pmobilename=${Provider.of<MobileInfoProvider>(context, listen: false).pmobileDevicename}&pmobileversion=${Provider.of<MobileInfoProvider>(context, listen: false).mobileVersion}&pmobileidentifier=${Provider.of<MobileInfoProvider>(context, listen: false).employeLoginDateTime}&preleaseversion=${Provider.of<MobileInfoProvider>(context, listen: false).mobileVersion}&pmiscinfo=this is info &pisshow=Y&pdevappid=${Provider.of<MobileInfoProvider>(context, listen: false).devAppId}&platitude=$userAttendaceCurrentLatitude&plongitude=$userAttendaceCurrentLongitude&plocation=$userCurrentAddress&pauthtokenkey=${Provider.of<MobileInfoProvider>(context, listen: false).deviceToken}&pimei_number=${Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber}';

      // log(employeUserName);
      // log(employepassword);
      // log(employeId);
      // log('pMobileDevice  =' +
      //     Provider.of<MobileInfoProvider>(context, listen: false)
      //         .pMobileDevice);
      // log(employeId);
      // log('employeLoginDateTime' +
      //     Provider.of<MobileInfoProvider>(context, listen: false)
      //         .employeLoginDateTime);
      // log('Y');
      // log('isPhysicalDevice' +
      //             Provider.of<MobileInfoProvider>(context, listen: false)
      //                 .isPhysicalDevice ==
      //         'false'
      //     ? "N"
      //     : "Y");
      // log('pMobileDevice' +
      //     Provider.of<MobileInfoProvider>(context, listen: false)
      //         .pMobileDevice);
      // log('mobileVersion' +
      //     Provider.of<MobileInfoProvider>(context, listen: false)
      //         .mobileVersion);
      // log('This is pmiscinfo');
      // log("Y");
      // log('devAppId' +
      //     Provider.of<MobileInfoProvider>(context, listen: false).devAppId);
      // log(userAttendaceCurrentLatitude.toString());
      // log(userAttendaceCurrentLongitude.toString());
      // log(userCurrentAddress.toString());
      // log('deviceToken' +
      //     Provider.of<MobileInfoProvider>(context, listen: false).deviceToken);
      // log("prov.devImEINumber = ${Provider.of<MobileInfoProvider>(context, listen: false).devImEINumber}");
      // log('===================================== my task ============================ ');
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MobileInfoProvider>(builder: (context, prov, _) {
      return Scaffold(
        backgroundColor: mobileInfoBGColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 23.w, right: 23.w),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 110.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 120.h,
                      width: 120.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(mobileLogo),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                      context,
                      prov.pmobileDevicename,
                      16.sp,
                      boldText: FontWeight.w500,
                      color: white,
                      fontFamily: 'Poppins',
                    )
                  ],
                ),
                SizedBox(
                  height: 0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                      context,
                      prov.devImEINumber,
                      16.sp,
                      boldText: FontWeight.w500,
                      color: white,
                      fontFamily: 'Poppins',
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                      context,
                      prov.isPhysicalDevice,
                      14.sp,
                      boldText: FontWeight.w500,
                      color: white,
                      fontFamily: 'Poppins',
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                      context,
                      prov.mobileVersion,
                      14.sp,
                      boldText: FontWeight.w500,
                      color: white,
                      fontFamily: 'Poppins',
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                //  Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     text(
                //       context,
                //       prov.employeLoginDateTime,
                //       16.sp,
                //       boldText: FontWeight.w500,
                //       color: white,
                //       fontFamily: 'Poppins',
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 22.h,
                      width: 20.w,
                      decoration: const BoxDecoration(
                        //  color: white,
                        image: DecorationImage(
                          image: AssetImage(markerIcon),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    text(
                      context,
                      'Your Location',
                      14.sp,
                      boldText: FontWeight.w500,
                      color: white,
                      fontFamily: 'Poppins',
                      maxLines: 1,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                      context,
                      userCurrentAddress == null ? '' : userCurrentAddress,
                      14.sp,
                      boldText: FontWeight.w500,
                      color: white,
                      fontFamily: 'Poppins',
                      maxLines: 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 330.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: greyShaderemarkBix,
                    border: Border.all(
                      color: greyLightShade,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: black.withOpacity(0.25),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      fillColor: greyShaderemarkBix,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
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
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),

                prov.userLoginLogsSaveloading
                    ? const CircularProgressIndicator(
                        color: readcolor,
                      )
                    : DefaultColorButton(
                        width: 335.w,
                        text: "This my Device",
                        press: () {
                          if (reviewController.text.isNotEmpty) {
                            // var _employeId;
                            // var _employeUsername;
                            // var _employeUsepassword;
                            // var employeLoginDateTime;
                            // var isPhysicalDevice;
                            // var pmobileDevice;
                            // var mobileVersion;
                            // var devAppId;
                            // var deviceToken;
                            // var devImEINumber;
                            log('reviewController = ${reviewController.text}');
                            log('_employeId = ${_employeId}');

                            log('_employeUsername = ${_employeUsername}');
                            log('_employeUsepassword = ${_employeUsepassword}');
                            log('employeLoginDateTime = ${df.format(DateTime.now())}');
                            log('isPhysicalDevice = ${isPhysicalDevice}');
                            log('pmobileDevice = ${pmobileDevice}');
                            log('mobileVersion = ${mobileVersion}');
                            log('devAppId = ${devAppId}');
                            log('deviceToken = ${deviceToken}');
                            log('devImEINumber = ${devImEINumber}');
                            Apis().userLoginLogsSave(
                              context,
                              employeUserName,
                              employepassword,
                              employeId,
                              pmobileDevice,
                              employeLoginDateTime,
                              'Y',
                              isPhysicalDevice == 'false' ? "N" : "Y",
                              pmobileDevice,
                              mobileVersion,
                              devAppId,
                              mobileVersion,
                              'This is pmiscinfo',
                              "Y",
                              devAppId,
                              userAttendaceCurrentLatitude.toString(),
                              userAttendaceCurrentLongitude.toString(),
                              userCurrentAddress.toString(),
                              deviceToken,
                              devImEINumber,
                            );
                            Apis().makeMobileAuthRequest(
                              context,
                              employeUserName,
                              employepassword,
                              employeId,
                              prov.pMobileDevice,
                              prov.pmobileDevicename,
                              prov.deviceToken,
                              prov.devImEINumber,
                              reviewController.text,
                            );

                            // Future.delayed(const Duration(seconds: 3), () {});
                          } else {
                            ToastUtils.showCustomToast(
                              context,
                              'Enter Description',
                              Colors.red,
                            );
                          }
                        }),

                SizedBox(
                  height: 15.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: text(
                    context,
                    'Your Device name and location saved for ',
                    12.sp,
                    boldText: FontWeight.w400,
                    color: white,
                    fontFamily: 'Poppins',
                    maxLines: 2,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: text(
                      context,
                      'Future use.',
                      12.sp,
                      boldText: FontWeight.w400,
                      color: white,
                      fontFamily: 'Poppins',
                      maxLines: 2,
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
