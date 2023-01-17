import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_attendance/screens/login.dart';
import 'package:virtual_attendance/screens/register.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/widgets/default_color_button.dart';

import '../widgets/default_white_button.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                vr,
                width: 200,
              ),
              const Spacer(),
              Column(
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: primaryColorDark),
                  ),
                  const SizedBox(
                      width: 200,
                      child: Text(
                        "Lorem ispum Lorem ispum Lorem ispum Lorem ispum",
                        style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: greyShade),
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        DefaultColorButton(
                            width: 335.w,
                            text: "Register",
                            press: () {
                              AppRoutes.push(context, PageTransitionType.fade,
                                  const Register());
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        DefaultWhiteButton(
                            text: "Login",
                            press: () {
                              AppRoutes.push(context, PageTransitionType.fade,
                                  const Login());
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Image.asset(
                ustiLogo,
                width: 301,
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
