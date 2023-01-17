import 'dart:async';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/constantFile.dart';
import '../utils/image_src.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({Key? key}) : super(key: key);

  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class _MapTestPageState extends State<MapTestPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMapPins();
  }

  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  LatLng SOURCE_LOCATION = LatLng(31.563007, 74.346566);
  LatLng DEST_LOCATION = LatLng(31.708366, 74.447884);
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<PointLatLng> points = [];
  Future<void> setMapPins() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2), mapMarker);
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2), ownMarker);
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon!));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: destinationIcon!));

      addPolyLine();
      log('Marker Added');
    });
  }

  List<LatLng> polylineCoordinates = [];

  final Set<Polyline> _polylines = <Polyline>{};

  Map<PolylineId, Polyline> polylines = {};
  addPolyLine() {
    log("In the PoliLineFunction");
    polylineCoordinates.add(LatLng(31.563007, 74.346566));
    polylineCoordinates.add(LatLng(31.565102, 74.354604));
    polylineCoordinates.add(LatLng(31.568722, 74.358466));
    polylineCoordinates.add(LatLng(31.572532, 74.349173));
    polylineCoordinates.add(LatLng(31.575947, 74.348581));
    polylineCoordinates.add(LatLng(31.582747, 74.346702));
    polylineCoordinates.add(LatLng(31.589766, 74.355550));
    polylineCoordinates.add(LatLng(31.596492, 74.349673));
    polylineCoordinates.add(LatLng(31.604139, 74.352471));
    polylineCoordinates.add(LatLng(31.613101, 74.341487));
    polylineCoordinates.add(LatLng(31.619365, 74.352494));
    polylineCoordinates.add(LatLng(31.626520, 74.342266));
    polylineCoordinates.add(LatLng(31.633631, 74.360483));
    polylineCoordinates.add(LatLng(31.642129, 74.386477));
    polylineCoordinates.add(LatLng(31.660717, 74.368972));
    polylineCoordinates.add(LatLng(31.685962, 74.403950));
    polylineCoordinates.add(LatLng(31.708366, 74.447884));

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

  // setPolylines() async {
  //       polylineCoordinates.add(LatLng(31.5204, 74.3587));
  //   polylineCoordinates.add(LatLng(33.6844, 73.0479));
  //   List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
  //       ConstantFile.mapKey,
  //       SOURCE_LOCATION.latitude,
  //       SOURCE_LOCATION.longitude,
  //       DEST_LOCATION.latitude,
  //       DEST_LOCATION.longitude);
  //   if (result.isNotEmpty) {
  //     points = result;
  //     // loop through all PointLatLng points and convert them
  //     // to a list of LatLng, required by the Polyline
  //     result.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   setState(() {
  //     // create a Polyline instance
  //     // with an id, an RGB color and the list of LatLng pairs
  //     Polyline polyline = Polyline(
  //         polylineId: PolylineId("poly"),
  //         color: Color.fromARGB(255, 40, 122, 198),
  //         points: polylineCoordinates);

  //     // add the constructed polyline as a set of points
  //     // to the polyline set, which will eventually
  //     // end up showing up on the map
  //     _polylines.add(polyline);
  //   });
  // }

  int speed = 2;
  Timer? timer;
  int x = 0;
  data() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 3.2), markerRound);
    log('1');
    // if (timer != null) {
    //   setState(() {
    //     timer!.cancel();
    //     timer = null;
    //   });
    // }
    // log('2');
    // Future.delayed(Duration(milliseconds: 100), () {
    //   log('3');
    //    log("points = ${polylineCoordinates}");
    //    log("points[x].latitude = ${polylineCoordinates[x].latitude}");
    //   setState(() {
    //     log("points[x].latitude = ${polylineCoordinates[x].latitude}");
    //     _markers.add(Marker(
    //         markerId: MarkerId('my'),
    //         position: LatLng(polylineCoordinates[x].latitude, polylineCoordinates[x].longitude),
    //         icon: sourceIcon!));
    //     log('4');
    //   });
    // });
    if (timer != null) {
      setState(() {
        timer!.cancel();
        timer = null;
      });
    }

    setState(() {
      timer = Timer.periodic(Duration(seconds: speed), (timer) {
        print(
            "$speed Helii: ${LatLng(polylineCoordinates[x].latitude, polylineCoordinates[x].longitude)}");
        setState(() {
          _markers.add(Marker(
              markerId: MarkerId('my'),
              position: LatLng(polylineCoordinates[x].latitude,
                  polylineCoordinates[x].longitude),
              icon: sourceIcon!));
        });
        x++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            // backgroundColor: Colors.transparent,
            flexibleSpace: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Map Test'),
                    SizedBox(
                      width: 15.h,
                    ),
                    Text(
                      'Speed = ${speed.toString()}',
                      style: TextStyle(
                          color: speed == 0 ? Colors.red : Colors.white),
                    ),
                    SizedBox(
                      width: 15.h,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Timer(Duration(seconds: 5), () {
                          data();
                        });
                      },
                      child: Text('start'),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  speed = 2;
                                });

                                data();
                              },
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "2x",
                                    style: TextStyle(
                                        color: speed == 10
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ))),
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  speed = 3;
                                });
                                data();
                              },
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "3x",
                                    style: TextStyle(
                                        color: speed == 10
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ))),
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  speed = 4;
                                });
                                data();
                              },
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "4x",
                                    style: TextStyle(
                                        color: speed == 10
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ))),
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  speed = 5;
                                });
                                data();
                              },
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "5x",
                                    style: TextStyle(
                                        color: speed == 10
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ))),
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  speed = 6;
                                });
                                data();
                              },
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "6x",
                                    style: TextStyle(
                                        color: speed == 10
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ))),
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  speed = 7;
                                });
                                data();
                              },
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "7x",
                                    style: TextStyle(
                                        color: speed == 10
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: GoogleMap(
            mapType: MapType.terrain,
            rotateGesturesEnabled: true,
            trafficEnabled: false,
            tiltGesturesEnabled: false,
            scrollGesturesEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            indoorViewEnabled: true,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.25),
            initialCameraPosition: const CameraPosition(
              // target: LatLng(31.55067532257941, 74.35665174485734),
              target: LatLng(31.563007, 74.346566),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },

            markers: _markers,
            // circles: Set.from(circless),
            polylines: Set<Polyline>.of(polylines.values),
          ),
        ),
      ),
    );
  }
}
