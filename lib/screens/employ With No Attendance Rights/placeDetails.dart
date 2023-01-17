import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/models/getEmployePlacesModel.dart';
import 'package:virtual_attendance/providers/getEmployePlacesProvider.dart';
import 'package:virtual_attendance/screens/employ%20With%20No%20Attendance%20Rights/placeDetailMap.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/utils/lottie_src.dart';
import 'package:virtual_attendance/widgets/EmptyScreenWidget.dart';
import 'package:virtual_attendance/widgets/appBarWidget.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({Key? key}) : super(key: key);

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  String address = "";
  Future<String> GetAddressFromLatLong(lat, lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    // print(placemarks);
    Placemark place = placemarks[0];

    String address = '${place.street}, ${place.subLocality}, ${place.locality}';
    return address;
  }

  Widget _buildImage(
      {required String assetName, double? height, double? width}) {
    return Lottie.asset(assetName, height: height, width: width);
  }

  @override
  Widget build(BuildContext context) {
    GetAllPlacesProvider getAllPlacesProvider =
        Provider.of<GetAllPlacesProvider>(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: ReusableWidgets.getAppBar(
              title: 'My Places', isBack: true, context: context),
          body: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 15.r),
            child: Column(
              children: [
                getAllPlacesProvider.allPlacesDetails.isEmpty
                    ? Expanded(
                        child: EmptyScreenWidget(),
                      )
                    : Expanded(
                        child: AnimationLimiter(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  getAllPlacesProvider.allPlacesDetails.length,
                              itemBuilder: (context, index) {
                                String address = "";
                                EmployePlacesModel placeData =
                                    getAllPlacesProvider
                                        .allPlacesDetails[index];
                                log('placeData = $placeData');
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: placesWidget(placeData)),
                                  ),
                                );
                              }),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget placesWidget(EmployePlacesModel placeData) {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(
            context,
            PageTransitionType.bottomToTop,
            PlaceDetailMap(
              singleLocation: placeData,
            ));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 17.r),
        child: Container(
          height: 90.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 7.r, color: black.withOpacity(0.25))
            ],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.r),
                    child: Image.asset(markerRound, height: 60.h, width: 60.w),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.r),
                        child: Text("${placeData.aLMLPLACENAME ?? " "}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 190.w,
                        child: FutureBuilder<String>(
                          initialData:
                              "", // You can set initial data or check snapshot.hasData in the builder
                          future: GetAddressFromLatLong(
                              placeData.aLMLLAT,
                              placeData
                                  .aLMLLANG), // Run check for a single queryRow
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Text(snapshot.data!,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 12.sp, fontFamily: "Poppins"));
                            } else {
                              return Text("",
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 12.sp, fontFamily: "Poppins"));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
