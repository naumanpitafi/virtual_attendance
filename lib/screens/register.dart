import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/image_src.dart';
import 'package:virtual_attendance/widgets/default_color_button.dart';
import 'package:virtual_attendance/widgets/default_text_field.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController no = TextEditingController();
  TextEditingController cnic = TextEditingController();
  TextEditingController id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Image.asset(
                  vr,
                  width: 200.w,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.sp,
                            color: primaryColorDark),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextField(
                        controller: email,
                        text: "Email",
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextField(
                        controller: pass,
                        text: 'Password',
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextField(
                        controller: no,
                        text: "Number",
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextField(
                        controller: cnic,
                        text: "CNIC Number",
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextField(
                        controller: id,
                        text: "Emp ID",
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        children: [
                          DefaultColorButton(
                              width: 335.w, text: "Send Code", press: () {}),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Already have an Account? ",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: greyShade),
                  ),
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: primaryColorDark),
                  ),
                ])),
                SizedBox(
                  height: 10.h,
                ),
                Image.asset(
                  ustiLogo,
                  width: 301.w,
                  height: 32.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
