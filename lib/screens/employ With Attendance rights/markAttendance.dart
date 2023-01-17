import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:provider/provider.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:virtual_attendance/providers/loadingProvider.dart';
import 'package:virtual_attendance/utils/apiScreen.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/distanCalculator.dart';
import 'package:virtual_attendance/utils/lottie_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import '../../providers/getEmployePlacesProvider.dart';
import '../../providers/mobileInforProvider.dart';
import '../../providers/singleUserAttendanceProvider.dart';
import '../../utils/color_constants.dart';
import '../../utils/constantFile.dart';
import '../../utils/customToast.dart';
import '../../utils/image_src.dart';
import '../../utils/map_Service.dart';
import '../../widgets/default_text.dart';
import 'package:geolocator/geolocator.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  Iterable circless = [];
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late LatLng distination;
  late LatLng pickupLatlng;
  @override
  void initState() {
    super.initState();

    _polylinePoints = PolylinePoints();

    // distination = LatLng(31.5501869986124350, 74.35718794695957);
    // pickupLatlng = LatLng(31.3817199573802520, 74.22969590203769);
    // getLocation();
    // getEmployeTodayAttendanceDetai();
    getModel();
    getUserName();
    // getAttendanceForMap();
    locatePosition();
  }

  @override
  void dispose() {
    super.dispose();
    _customInfoWindowController.dispose();
    _controller!.dispose();
  }

  final DateFormat formatter = DateFormat('dd MMM yyyy ');
  String employepassword = 'Unknown';
  String employeUserName = 'Unknown';
  // String employeId = 'Unknown';

  DateTime todayDate = DateTime.now();
  var currentMonthInitialdate;
  var currentMonthLastdate;
  void currentAttendance() {
    // currentMonthInitialdate = formatter.format(DateTime.now());
    // var prevMonth =
    //     DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
    // currentMonthLastdate = formatter.format(prevMonth);

    var now = DateTime.now();
    currentMonthInitialdate = formatter.format(now);
// Find the last day of the month.
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

  int value = 0;
  bool positive = false;
  Color circilarColoris = readcolor;
  int colorValu = 1;
  bool roolingValue = false;

// Provider.of<LoadingProvider>(context,
//                                   listen: false)
//                               .loading

  void makrCircle() {
    Iterable _circles = Iterable.generate(
      Provider.of<GetAllPlacesProvider>(context, listen: false)
          .allPlacesDetails
          .length,
      (index) {
        double? lat = Provider.of<GetAllPlacesProvider>(context, listen: false)
            .allPlacesDetails[index]
            .aLMLLAT;
        double? lng = Provider.of<GetAllPlacesProvider>(context, listen: false)
            .allPlacesDetails[index]
            .aLMLLANG;
        String? loactionname =
            Provider.of<GetAllPlacesProvider>(context, listen: false)
                .allPlacesDetails[index]
                .aLMLPLACENAME;
        LatLng latLngMarker = LatLng(lat!, lng!);

        String coolor =
            Provider.of<GetAllPlacesProvider>(context, listen: false)
                .allPlacesDetails[index]
                .colorCode
                .toString();

        String color = coolor.replaceAll('#', '0xff');
        Color finalColor = Color(int.parse(color));
        // log("finalColor = ${finalColor.toString()}");
        addCompanymarkers(latLngMarker, loactionname);

        return Circle(
          fillColor: finalColor.withOpacity(0.2),
          strokeColor: Colors.transparent,
          circleId: CircleId(loactionname!),
          center: latLngMarker,
          radius: 200,

          // },
        );
      },
    );
    log('ALL DONE');
    circless = _circles;
  }

  DateTime timenow = DateTime.now();

  final df = DateFormat('MM-dd-yyyy hh:mm a');
  var todayDateTime;
  DateTime currentDateTime = DateTime.now();
  GoogleMapController? _controller;
  late LatLng currentLaltg;
  final Set<Marker> _markers = {};
  double? userCurrentLatitude;
  double? userCurrentLongitude;
  double? userAttendaceCurrentLatitude;
  double? userAttendaceCurrentLongitude;
  String attendanceMode = 'Unknown';
  String attendanceserialNo = 'Unknown';
  String attendanceVersionNo = 'Unknown';
  String attendancePermission = "";
  String employeCode = "";
  String employeId = '';
  String employeUserID = '';

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

  locatePosition() async {
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
      var latlong = LatLng(position.latitude, position.longitude);
      userCurrentLatitude = position.latitude;
      userCurrentLongitude = position.longitude;
      log('userCurrentLatitude = ' + userCurrentLatitude.toString());
      log('userCurrentLongitude = ' + userCurrentLongitude.toString());
      CameraPosition cameraPosition =
          CameraPosition(target: currentLaltg, zoom: 16);
      // const CameraPosition(
      //     target: LatLng(31.55067532257941, 74.35665174485734), zoom: 2);
      _controller!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // addmarkers(latlong, 'employe');
      addmarkers(currentLaltg, 'employe');
      makrCircle();
      setPolylineOnMap();
    }
  }

  Map<PolylineId, Polyline> polylines = {};

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 5,
        color: const Color(0xffff0000));
    polylines.clear();
    polylines[id] = polyline;
    print(" this is the add funcgion ========>>>>  + " + polyline.toString());
  }

  Future<Set<Marker>> addmarkers(
    LatLng showLocation,
    markerId,
  ) async {
    final Uint8List markerIcon =
        await MapServices.getMarkerWithSize(110, 140, ownMarker);
    setState(() {
      _markers.add(Marker(
        onTap: () {
          log('employe latitude = ${showLocation.latitude}');
          log('employe longitude = ${showLocation.longitude}');
          polylines.clear();
          _customInfoWindowController.addInfoWindow!(
            Container(
              height: 27.h,
              width: 105.w,
              decoration: BoxDecoration(
                color: bbColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "${markerId == "employe" ? "You" : markerId}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: white,
                    fontFamily: "Poppins-SemiBold",
                  ),
                ),
              ),
            ),
            LatLng(showLocation.latitude, showLocation.longitude),
          );
        },
        markerId: MarkerId(markerId),
        position: showLocation,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
    });
    return _markers;
  }

  Future<Set<Marker>> addCompanymarkers(
    LatLng? showLocation,
    markerId,
  ) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize1(80);
    setState(() {
      _markers.add(Marker(
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Container(
              height: 27.h,
              width: 105.w,
              decoration: BoxDecoration(
                color: bbColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "$markerId",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: white,
                    fontFamily: "Poppins-SemiBold",
                  ),
                ),
              ),
            ),
            LatLng(showLocation!.latitude, showLocation.longitude),
          );

          log('destination lcation latitude = ${showLocation.latitude}');
          log('destination lcation Longitude = ${showLocation.longitude}');
          polylineCoordinates.clear();
          polylineCoordinates
              .add(LatLng(showLocation.latitude, showLocation.longitude));
          log('destination Corordinates added Succesfully' +
              polylineCoordinates[0].latitude.toString());
          polylineCoordinates
              .add(LatLng(userCurrentLatitude!, userCurrentLongitude!));
          log('Start Corordinates added Succesfully' +
              polylineCoordinates[1].latitude.toString());
          addPolyLine(polylineCoordinates);
          // Future.delayed(const Duration(seconds: 3), () {
          //   setPolylineOnMap(
          //       // showLocation!,
          //       );
          // });
        },
        markerId: MarkerId(markerId),
        position: showLocation!,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
    });
    return _markers;
  }

  getLocationForAttendance() async {
    Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
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
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      ToastUtils.showCustomToast(
        context,
        'Rouster Not Genereted',
        Colors.green,
      );
    }
  }

  getUserName() async {
    try {
      var _employeCode = await SharedPref.getEmployeCode();
      var _employeId = await SharedPref.getEmployeId();
      var _employUserId = await SharedPref.getUserName();

      var _employeUsepassword = await SharedPref.getUserPassword();
      setState(() {
        employeCode = _employeCode;
        employeId = _employeId;
        employeUserID = _employUserId;
        employepassword = _employeUsepassword;
      });
      log('employeId = ' + employeId);
      log('employeCode = ' + employeCode);
      log('employeUserID = ' + employeUserID);
    } catch (e) {
      log(e.toString());
    }
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

  var rideTime = 0.0;
  var ridedistance = 0.0;

  late StreamSubscription geoLocatorListiner;
  Set<Polyline> _polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints? _polylinePoints;

  getLiveLocationUpdate() {
    geoLocatorListiner =
        Geolocator.getPositionStream().listen((Position position) {
      //   print("listiner");
      LatLng liveLocation = LatLng(position.latitude, position.longitude);
      log('liveLocation  = $liveLocation');
    });
  }

  List<LatLng> polylineCoordinates = [];

  final Set<Polyline> _polylines = <Polyline>{};

  void setPolylineOnMap() async {
    log("String Polyline..............................");
    log('userCurrentLatitude = ' + userCurrentLatitude.toString());
    log('userCurrentLongitude = ' + userCurrentLongitude.toString());

    log('PolyLine marked Started');
    PolylineId id = PolylineId('poly');
    polylineCoordinates
        .add(LatLng(userCurrentLatitude!, userCurrentLongitude!));

    setState(() {
      _polylines.add(Polyline(
        width: 20,
        polylineId: id,
        color: readcolor,
        points: polylineCoordinates,
      ));
    });

    log('PolyLine marked ended');
  }

  DateTime? startDatetime;
  bool mapValue = false;
  @override
  Widget build(BuildContext context) {
    LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context, listen: true);
    SingleUserAttendanceProvider singleUserAttendanceProvider =
        Provider.of<SingleUserAttendanceProvider>(context, listen: true);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: ReusableWidgets.getAppBar(
              title: "Mark Attendance", isBack: true, context: context),
          body: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                mapType: mapValue ? MapType.hybrid : MapType.terrain,
                rotateGesturesEnabled: true,
                trafficEnabled: false,
                tiltGesturesEnabled: false,
                scrollGesturesEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: true,
                indoorViewEnabled: true,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.25),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(31.55067532257941, 74.35665174485734),
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _customInfoWindowController.googleMapController = controller;
                },
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
                markers: _markers,
                circles: Set.from(circless),
                polylines: Set<Polyline>.of(polylines.values),
              ),
              Positioned(
                top: 70.h,
                right: 10,
                left: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.r),
                      child: Container(
                        height: 87.h,
                        padding: EdgeInsets.symmetric(
                            vertical: 4.r, horizontal: 20.r),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: mapValue
                              ? Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.7)
                              : Color(0xff676060).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            singleUserAttendanceProvider.intimeofUser == null
                                ? GestureDetector(
                                    onTap: () {
                                      // getLiveLocationUpdate();
                                    },
                                    child: text(
                                      context,
                                      'Mark Attendance',
                                      16.sp,
                                      fontFamily: "Poppins-Medium",
                                    ),
                                  )
                                : text(
                                    context,
                                    ("Attendance Marked at ${singleUserAttendanceProvider.intimeofUser!.length > 3 ? '${DateFormat.jm().format(DateFormat("dd-MM-yyyy hh:mm").parse(singleUserAttendanceProvider.intimeofUser!))}' : singleUserAttendanceProvider.intimeofUser!}"),
                                    16.sp,
                                    fontFamily: "Poppins-Medium",
                                  ),

                            text(
                                context,
                                //  DateFormat.Hms().add_MMMEd().format(timenow)
                                // newDateFormat.jm().format(DateFormat.jm().parse(input)),
                                'Time: ' +
                                    DateFormat.jm().format(DateTime.now()),
                                25.6.sp,
                                fontFamily: "Poppins-Medium",
                                color: readcolor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 37.h,
                width: 105.w,
                offset: 50,
              ),
              Positioned(
                right: 3,
                // height: 75.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 90.r, right: 2.r),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            mapValue = !mapValue;
                          });
                        },
                        child: ClipOval(
                          child: CircleAvatar(
                            backgroundColor: mapValue
                                ? Color(0xffE01F27).withOpacity(0.5)
                                : Colors.transparent,
                            foregroundColor: mapValue
                                ? Color(0xffE01F27).withOpacity(0.5)
                                : Color(0xffE01F27).withOpacity(0.4),
                            foregroundImage: AssetImage(mapType),
                            radius: 28.r,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller!.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                          child: Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: mapValue
                                  ? Color(0xffE01F27).withOpacity(0.6)
                                  : Color(0xffE01F27).withOpacity(0.4),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller!.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                          child: Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: mapValue
                                  ? Color(0xffE01F27).withOpacity(0.6)
                                  : Color(0xffE01F27).withOpacity(0.4),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.remove, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20.h,
                width: 335.w,
                height: 60.h,
                child: Consumer<SingleUserAttendanceProvider>(
                    builder: (context, prov, _) {
                  if (prov.attendanceFinalDate == 'true') {
                    if (prov.intimeofUser == null &&
                        prov.outtimeofUser == null) {
                      return GestureDetector(
                        onTap: () {
                          Apis().markSelfAttendanceApi(
                            context,
                            1,
                            employeId,
                            todayDateTime,
                            // '01-31-2017 10:06 PM',
                            // attendanceMode,
                            Provider.of<MobileInfoProvider>(context,
                                    listen: false)
                                .attendanceMode,
                            // attendanceserialNo,
                            Provider.of<MobileInfoProvider>(context,
                                    listen: false)
                                .devAppId,
                            // attendanceVersionNo,
                            Provider.of<MobileInfoProvider>(context,
                                    listen: false)
                                .devImEINumber,
                            userCurrentLatitude,
                            // '31.55067532257941',
                            // '74.35665174485734',
                            userCurrentLongitude,
                            'This is Remarks',
                            employeUserID,
                            // 'This is Remarks',
                          );
                        },
                        child: loadingProvider.loading == true
                            ? Center(
                                child: Container(
                                  height: 50.h,
                                  width: 50.w,
                                  child: const CircularProgressIndicator(
                                    color: readcolor,
                                  ),
                                ),
                              )
                            : Container(
                                height: 50.h,
                                width: 335.w,
                                child: Align(
                                  alignment: Alignment.center,
                                  // child: text(context, 'Clock Out', Size: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        color: white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10.w),
                                      text(
                                        context,
                                        'Clock In',
                                        16.sp,
                                        color: white,
                                        fontFamily: "Poppins",
                                        boldText: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    gradient: primaryreadGradient),
                              ),
                      );
                    } else if (prov.intimeofUser != null &&
                        prov.outtimeofUser == null) {
                      return GestureDetector(
                        onTap: () {
                          Apis().markSelfAttendanceApi(
                            context,
                            2,
                            employeId,
                            todayDateTime,
                            // '01-31-2017 10:06 PM',
                            // attendanceMode,
                            Provider.of<MobileInfoProvider>(context,
                                    listen: false)
                                .attendanceMode,
                            // attendanceserialNo,
                            Provider.of<MobileInfoProvider>(context,
                                    listen: false)
                                .devAppId,
                            // attendanceVersionNo,
                            Provider.of<MobileInfoProvider>(context,
                                    listen: false)
                                .devImEINumber,
                            // userCurrentLatitude,
                            '31.55067532257941',
                            '74.35665174485734',
                            // userCurrentLongitude,
                            'This is Remarks',
                            employeUserID,
                            // 'This is Remarks',
                          );
                        },
                        child: loadingProvider.loading == true
                            ? Center(
                                child: Container(
                                  height: 50.h,
                                  width: 50.w,
                                  child: const CircularProgressIndicator(
                                    color: readcolor,
                                  ),
                                ),
                              )
                            : Container(
                                height: 50.h,
                                width: 335.w,
                                child: Align(
                                  alignment: Alignment.center,
                                  // child: text(context, 'Clock Out', Size: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        color: white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10.w),
                                      text(
                                        context,
                                        'Clock Out',
                                        // loadingProvider.loading.toString(),
                                        16.sp,
                                        color: white,
                                        fontFamily: "Poppins",
                                        boldText: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    gradient: primaryreadGradient),
                              ),
                      );
                    } else if (prov.intimeofUser != null &&
                        prov.outtimeofUser != null) {
                      return Container(
                        height: 50.h,
                        width: 335.w,
                        child: Align(
                          alignment: Alignment.center,
                          // child: text(context, 'Clock Out', Size: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.alarm,
                                color: black,
                                size: 20,
                              ),
                              SizedBox(width: 10.w),
                              text(
                                context,
                                // 'InTime : ${prov.intimeofUser}  ',
                                prov.intimeofUser!.length > 3
                                    ? 'InTime : ${DateFormat.jm().format(DateFormat("dd-MM-yyyy hh:mm").parse(prov.intimeofUser!))}'
                                    : prov.intimeofUser!,

                                16.sp,
                                color: black,
                                fontFamily: "Poppins",
                                boldText: FontWeight.w600,
                              ),
                              SizedBox(width: 5.w),
                              text(
                                context,
                                prov.outtimeofUser!.length > 3
                                    ? 'OutTime : ${DateFormat.jm().format(DateFormat("dd-MM-yyyy hh:mm").parse(prov.outtimeofUser!))}'
                                    : prov.outtimeofUser!,
                                16.sp,
                                color: black,
                                fontFamily: "Poppins",
                                boldText: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          // gradient: primaryreadGradient
                          color: mapValue
                              ? Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.7)
                              : greyShade.withOpacity(0.4),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  } else {
                    return Text('Date is false');
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
