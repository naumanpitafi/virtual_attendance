import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:virtual_attendance/models/getEmployePlacesModel.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_src.dart';
import '../../utils/map_Service.dart';
import '../../widgets/default_text.dart';
import 'package:geolocator/geolocator.dart';

class PlaceDetailMap extends StatefulWidget {
  EmployePlacesModel? singleLocation;
  PlaceDetailMap({
    Key? key,
    @required this.singleLocation,
  }) : super(key: key);

  @override
  State<PlaceDetailMap> createState() => _PlaceDetailMapState();
}

class _PlaceDetailMapState extends State<PlaceDetailMap> {
  Iterable circless = [];
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  DateTime timenow = DateTime.now();

  final df = DateFormat('MM-dd-yyyy hh:mm a');
  var todayDateTime;
  DateTime currentDateTime = DateTime.now();
  GoogleMapController? _controller;
  late LatLng currentLaltg;
  final Set<Marker> _markers = {};

  locatePosition() async {
    log('i am in the location function');
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      log("Location is Off =======================>>");
    } else {
      log("Location is ON =======================>>");

      var latlong = LatLng(
          widget.singleLocation!.aLMLLAT!, widget.singleLocation!.aLMLLANG!);

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(widget.singleLocation!.aLMLLAT!,
              widget.singleLocation!.aLMLLANG!),
          zoom: 16);

      _controller!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      addmarkers(latlong, widget.singleLocation!.aLMLPLACENAME!);
    }
  }

  Future<Set<Marker>> addmarkers(
    LatLng showLocation,
    markerId,
  ) async {
    final Uint8List markerIcon =
        await MapServices.getMarkerWithSize(110, 140, mapMarker);
    setState(() {
      _markers.add(Marker(
        onTap: () {
          log('employe latitude = ${showLocation.latitude}');
          log('employe longitude = ${showLocation.longitude}');
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
                  "${widget.singleLocation!.aLMLPLACENAME}",
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

  DateTime? startDatetime;
  bool mapValue = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.getAppBar(
            title: "${widget.singleLocation!.aLMLPLACENAME}",
            isBack: true,
            context: context),
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
              mapToolbarEnabled: false,
              indoorViewEnabled: false,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.25),
              initialCameraPosition: const CameraPosition(
                target: LatLng(31.55067532257941, 74.35665174485734),
                zoom: 20.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _customInfoWindowController.googleMapController = controller;
                locatePosition();
              },
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              markers: _markers,
              circles: {
                Circle(
                  strokeWidth: 0,
                  fillColor: Color(0xffF03737).withOpacity(0.20),
                  circleId: CircleId(widget.singleLocation!.aLMLPLACENAME!),
                  center: LatLng(
                    widget.singleLocation!.aLMLLAT!,
                    widget.singleLocation!.aLMLLANG!,
                  ),
                  radius: 200,
                )
              },
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
                          backgroundColor: Colors.transparent,
                          foregroundColor: Color(0xffE01F27).withOpacity(0.4),
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
                              color: Color(0xffE01F27).withOpacity(0.4)),
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
                              color: Color(0xffE01F27).withOpacity(0.4)),
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
          ],
        ),
      ),
    );
  }
}
