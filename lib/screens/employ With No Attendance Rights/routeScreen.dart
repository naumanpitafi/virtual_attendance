import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/widgets/default_text.dart';

import '../../utils/color_constants.dart';
import '../employ With Attendance rights/markAttendance.dart';

class RouteOnMap extends StatefulWidget {
  const RouteOnMap({Key? key}) : super(key: key);

  @override
  State<RouteOnMap> createState() => _RouteOnMapState();
}

class _RouteOnMapState extends State<RouteOnMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Marker> markers = {};
  final LatLng initialLatLng = const LatLng(30.029585, 31.022356);
  GoogleMapController? myController;
  late LatLng currentLaltg;
  locatePosition() async {
    print('i am in the location function');
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      print("Location is Off =======================>>");
    } else {
      print("Location is ON =======================>>");
      // Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      print('position: $position');
      var currentPosition = position;
      currentLaltg = LatLng(position.latitude, position.longitude);
      print('currentLaltg: $currentLaltg');
      CameraPosition cameraPosition =
          CameraPosition(target: currentLaltg, zoom: 14);
      myController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      addmarkers(currentLaltg);
    }
  }

  Future<Set<Marker>> addmarkers(showLocation) async {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: showLocation,
          infoWindow: const InfoWindow(title: 'Driver'),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    return markers;
  }

  @override
  void initState() {
    // checkUserExist();
    locatePosition();
    // driverTripProvider = Provider.of<TripProvider>(context, listen: false);
    // _loadMapStyles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // color: Colors.amber,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(gmap),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: GoogleMap(
                mapType: MapType.terrain,
                rotateGesturesEnabled: true,
                zoomGesturesEnabled: true,
                trafficEnabled: false,
                tiltGesturesEnabled: false,
                scrollGesturesEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: initialLatLng,
                  // target: currentLaltg,
                  zoom: 14.47,
                ),
                onMapCreated: (GoogleMapController controller) {
                  myController = controller;
                  _controller.complete(controller);
                  // _setMapPins([LatLng(30.029585, 31.022356)]);
                  // _setMapStyle();
                  // _addPolyLines();
                },
              ),
            ),
            Positioned(
              top: 30.h,
              width: 351.w,
              height: 62.h,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: primaryreadGradient,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                      onTap: () {
                        AppRoutes.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 70.w,
                    ),
                    text(context, 'Route', 22.sp,
                        fontFamily: "Poppins",
                        boldText: FontWeight.w600,
                        color: white)
                  ],
                ),
              ),
            ),
            Positioned(
              top: 100.h,
              width: 351.w,
              // height: 75.h,
              child: Container(
                padding: EdgeInsets.only(
                    left: 10.w, top: 5.h, right: 5.w, bottom: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xff676060).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(context, 'Instructions:', 14.sp,
                        fontFamily: "Poppins", boldText: FontWeight.w600),
                    text(
                        context,
                        'Go to the office, pickup the printer and deliver it to the address.',
                        14.sp,
                        fontFamily: "Poppins",
                        boldText: FontWeight.w400),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              width: 335.w,
              height: 50.h,
              child: InkWell(
                onTap: () {
                  AppRoutes.push(context, PageTransitionType.topToBottom,
                      const MarkAttendance());
                },
                child: Container(
                    decoration: BoxDecoration(
                      gradient: primaryreadGradient,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: text(
                          context, 'Open location in Google Maps', 18.sp,
                          fontFamily: "Open Sans",
                          boldText: FontWeight.w600,
                          color: white),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = myController!;
    controller.dispose();
    super.dispose();
  }
}
