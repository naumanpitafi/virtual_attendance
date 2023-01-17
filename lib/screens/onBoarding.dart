import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_attendance/screens/login.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/lottie_src.dart';
import 'package:virtual_attendance/utils/sheared_pref_Service.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  _storeOnboardInfo() async {
    SharedPref.saveIntroScreenState("true");
  }

  void _onIntroEnd(context) {
    _storeOnboardInfo();
    AppRoutes.pushAndRemoveUntil(
        context, PageTransitionType.bottomToTop, const Login()
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (_) => const Login()),
        );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Lottie.asset(assetName, height: 317.h, width: 317.w);
  }

  @override
  Widget build(BuildContext context) {
    var pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 18.0,
        fontFamily: 'DM Sans',
        fontWeight: FontWeight.w700,
        color: readcolor,
      ),
      bodyTextStyle: TextStyle(
        fontFamily: 'Open Sans',
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xff7A7A7A),
      ),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      key: introKey,
      pages: [
        PageViewModel(
          title: "Use Geofence Location",
          body:
              "We provide you with peace of mind, giving up to the minute information on the location of your vehicle",
          image: _buildImage(geofence),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Employee Records",
          body:
              "We provide you variety of packages for your ease. Upgrade anytime.",
          image: _buildImage(employee),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Contact HR",
          body: "24/7 call center for your help. ",
          image: _buildImage(hrImage),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      skip: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16.sp,
          color: bbColor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      next: Text(
        'Next',
        style: TextStyle(
          fontSize: 16.sp,
          color: bbColor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      done: Text('Done',
          style: TextStyle(
            fontSize: 16.sp,
            color: bbColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          )),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 20.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFC4C4C4),
        activeColor: readcolor,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
