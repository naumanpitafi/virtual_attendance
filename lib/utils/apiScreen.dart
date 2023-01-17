import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_attendance/providers/getEmployePlacesProvider.dart';
import 'package:virtual_attendance/providers/loadingProvider.dart';
import 'package:virtual_attendance/providers/userProfileProvider.dart';
import 'package:virtual_attendance/screens/bottombar/bottomnavigationbar.dart';
import 'package:virtual_attendance/screens/login.dart';
import 'package:virtual_attendance/utils/apis_Url.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/utils/constantFile.dart';
import 'package:virtual_attendance/utils/customToast.dart';
import '../providers/allEmployesDetailProvider.dart';
import '../providers/employeAttendanceSummery.dart';
import '../providers/getEmployeesLeaveRequestDetail.dart';
import '../providers/getSupervisorStatusProvider.dart';
import '../providers/markEmployeAttendanceProvider.dart';
import '../providers/mobileInforProvider.dart';
import '../providers/singleUserAttendanceProvider.dart';
import '../screens/employ With No Attendance Rights/mobileInfoScreen.dart';
import '../screens/supervisor/markEmployeAttendanc.dart';
import 'sheared_pref_Service.dart';

class Apis {
  var username = "";
  var password = "";
  var surveyorId = "";
  List empDetails = [];
  List allEmpDetails = [];
  List allplacesInfo = [];
  List superVisorStatusInfo = [];
  List leaveRequestDetails = [];
  List singleEmployeAttendanceDetails = [];
  List singleEmployeAttendanceDetails1 = [];
  getUserNamePassword() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    username = _prefs.getString("username")!;
    password = _prefs.getString("password")!;
  }

  // User Login Api
  Future<void> userLogin(
      BuildContext context,
      String userEmail,
      String userPassword,
      String deviceImeiNumber,
      String deviceTokenNumber,
      String developerappId,
      String userTerm,
      bool rememberMe,
      bool isBioLogin) async {
    try {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
      print(
        '${ApiURls.baseURL}${ApiURls.authenticationUrl}puser_name=$userEmail&ppassword=$userPassword&pcuserterm=$userTerm&pauthtokenkey=$deviceTokenNumber&pimei_number=$deviceImeiNumber&pdevappid=$developerappId',
      );
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.authenticationUrl}puser_name=$userEmail&ppassword=$userPassword&pcuserterm=$userTerm&pauthtokenkey=$deviceTokenNumber&pimei_number=$deviceImeiNumber&pdevappid=$developerappId',
        ),
        headers: ConstantFile.loginHeaders,
      );
      var apiRemponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (apiRemponse['presponse_code'] == '0') {
          log('response Description -= ${apiRemponse['presponse_code']}');
          log('response Description -= ${apiRemponse['presponse_desc']}');
          log(apiRemponse['pemployeecode']);
          log(apiRemponse['pis_supervisor']);
          log(apiRemponse['pemp_id']);
          log(apiRemponse['pallow_mark_atten']);
          SharedPref.saveEmployeCode(apiRemponse['pemployeecode']);
          SharedPref.saveEmployeId(apiRemponse['pemp_id']);
          SharedPref.saveAttendancePermission(apiRemponse['pallow_mark_atten']);
          SharedPref.saveIsSuperVisor(apiRemponse['pis_supervisor']);
          SharedPref.saveUserName(userEmail);
          SharedPref.saveUserPassword(userPassword);
          if (rememberMe == true) {
            SharedPref.saveUserrememberMe(userEmail);
            SharedPref.saveUserPasswordRememberMe(userPassword);
          } else {
            if (rememberMe == true) {
              SharedPref.saveUserrememberMe(userEmail);
              SharedPref.saveUserPasswordRememberMe(userPassword);
            } else {
              SharedPref.saveUserrememberMe("");
              SharedPref.saveUserPasswordRememberMe("");
            }
          }

          SharedPref.saverememberMe(rememberMe);

          SharedPref.saveBiometricInfo(isBioLogin);
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          log('LoginSuccesfully');

          AppRoutes.pushAndRemoveUntil(
              context, PageTransitionType.bottomToTop, const MyNavigationBar());
          ToastUtils.showCustomToast(
            context,
            'Login Succesfully',
            Colors.green,
          );
        }
        if (apiRemponse['presponse_code'] == '1') {
          log('response Description -= ${apiRemponse['presponse_code']}');
          log('response Description -= ${apiRemponse['presponse_desc']}');
          log('Account Not Exist');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            'Invalid password',
            Colors.red,
          );
        }
        if (apiRemponse['presponse_code'] == '2') {
          log('response Code -= ${apiRemponse['presponse_code']}');
          log('response Description -= ${apiRemponse['presponse_desc']}');
          // log('${apiRemponse['presponse_desc']}');
          // final df = DateFormat('MM-dd-yyyy hh:mm a');
          // DateTime selectedDateTime = DateTime.now();
          // log('formated date time = ' + df.format(selectedDateTime));
          // var todayDateTime = df.format(selectedDateTime);
          // Provider.of<MobileInfoProvider>(context, listen: false)
          //     .employeLoginDateTime = todayDateTime;
          // log(apiRemponse['pemployeecode']);
          // log(apiRemponse['pis_supervisor']);
          // log(apiRemponse['pemp_id']);
          // log(apiRemponse['pallow_mark_atten']);
          // log(apiRemponse['puser_expiry']);
          // log(apiRemponse['pfree_zone']);
          // SharedPref.saveEmployeemail(userEmail);
          // SharedPref.saveEmployeCode(apiRemponse['pemployeecode']);
          // SharedPref.saveEmployeId(apiRemponse['pemp_id']);
          // SharedPref.saveAttendancePermission(apiRemponse['pallow_mark_atten']);
          // SharedPref.saveIsSuperVisor(apiRemponse['pis_supervisor']);
          // SharedPref.saveUserName(userEmail);
          // SharedPref.saveUserPassword(userPassword);
          Provider.of<MobileInfoProvider>(context, listen: false).userId =
              apiRemponse['pemp_id'];
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          Provider.of<MobileInfoProvider>(context, listen: false).username =
              userEmail;
          Provider.of<MobileInfoProvider>(context, listen: false).userPassword =
              userPassword;

          AppRoutes.pushAndRemoveUntil(context, PageTransitionType.bottomToTop,
              const MobileInfoScreen());
          ToastUtils.showCustomToast(
            context,
            '${apiRemponse['presponse_desc']}',
            Colors.yellow,
          );
        }
        if (apiRemponse['presponse_code'] == '3') {
          log('response Code -= ${apiRemponse['presponse_code']}');
          log('response Description -= ${apiRemponse['presponse_desc']}');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            '${apiRemponse['presponse_desc']}',
            Colors.red,
          );
        }
        if (apiRemponse['presponse_code'] == '4') {
          log('response Code -= ${apiRemponse['presponse_code']}');
          log('response Description -= ${apiRemponse['presponse_desc']}');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);

          ToastUtils.showCustomToast(
            context,
            'Un Authorized Device',
            Colors.red,
          );
        }
        if (apiRemponse['presponse_code'] == '5') {
          log('response Code -= ${apiRemponse['presponse_code']}');
          log('response Description -= ${apiRemponse['presponse_desc']}');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          Provider.of<MobileInfoProvider>(context, listen: false).userId =
              apiRemponse['pemp_id'];

          Provider.of<MobileInfoProvider>(context, listen: false).username =
              userEmail;
          Provider.of<MobileInfoProvider>(context, listen: false).userPassword =
              userPassword;

          AppRoutes.pushAndRemoveUntil(context, PageTransitionType.bottomToTop,
              const MobileInfoScreen());
          ToastUtils.showCustomToast(
            context,
            '${apiRemponse['presponse_desc']}',
            Colors.red,
          );
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'Entered username or password is incorrect',
          Colors.red,
        );
        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      }
    } catch (e) {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Make Mobile Auth Request Api
  Future<void> makeMobileAuthRequest(
    BuildContext context,
    String userEmail,
    String userPassword,
    String employeId,
    String mobileDevice,
    String mobileDevicename,
    String deviceTokenNumber,
    String deviceImeiNumber,
    String remark,
  ) async {
    try {
      log(
        '${ApiURls.baseURL}/${ApiURls.makeMobileAuthRequest}pusername=$userEmail&ppassword=$userPassword&pemp_id= $employeId&pmobiledevice=$mobileDevice&pmobilename=$mobileDevicename&pauthtokenkey=$deviceTokenNumber&pimei_number=$deviceImeiNumber&premarks=This is Make makeMobileAuthRequest',
      );
      Provider.of<MobileInfoProvider>(context, listen: false).setLoading(true);
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}/${ApiURls.makeMobileAuthRequest}pusername=$userEmail&ppassword=$userPassword&pemp_id=$employeId&pmobiledevice=$mobileDevice&pmobilename=$mobileDevicename&pauthtokenkey=$deviceTokenNumber&pimei_number=$deviceImeiNumber&premarks=$remark',
        ),
        headers: ConstantFile.loginHeaders,
      );
      var apiRemponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (apiRemponse['presponse_code'] == '0') {
          log('===================== Yaho Start =============');
          Provider.of<MobileInfoProvider>(context, listen: false)
              .setLoading(false);
          log('makeMobileAuthRequest is Succesfully');
          log(' response Code =       ${apiRemponse['presponse_code']}');
          log('Second Api Is Done Succesfully');
          log("apiRemponse presponse_code = $apiRemponse['presponse_code']");
          AppRoutes.pushAndRemoveUntil(
              context, PageTransitionType.bottomToTop, const Login());

          ToastUtils.showCustomToast(
            context,
            'Request Send Succesfully',
            Colors.green,
          );
          log('===================== Yaho End =============');
        }
        if (apiRemponse['presponse_code'] == '2') {
          log('===================== Yaho Start =============');
          Provider.of<MobileInfoProvider>(context, listen: false)
              .setLoading(false);
          log('makeMobileAuthRequest is Succesfully');
          log('Second Api Is Done Succesfully');
          log("apiRemponse presponse_code = $apiRemponse['presponse_code']");

          // AppRoutes.pushAndRemoveUntil(
          //     context, PageTransitionType.bottomToTop, const Login());

          ToastUtils.showCustomToast1(
            context,
            '${apiRemponse['presponse_desc']}',
            Colors.redAccent,
          );
          log('===================== Yaho End =============');
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'Request Not Send ',
          Colors.red,
        );
        Provider.of<MobileInfoProvider>(context, listen: false)
            .setLoading(false);
      }
    } catch (e) {
      Provider.of<MobileInfoProvider>(context, listen: false).setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User UserLoginLogsSave Api
  Future<void> userLoginLogsSave(
    BuildContext context,
    String pusername,
    String ppassword,
    String pemp_id,
    String pmobiledevice,
    String plogindatetime,
    String pissuccessful,
    String pisphysicaldevice,
    String pmobilename,
    String pmobileversion,
    String pmobileidentifier,
    String preleaseversion,
    String pmiscinfo,
    String pisshow,
    String pdevappid,
    String platitude,
    String plongitude,
    String plocation,
    String pauthtokenkey,
    String pimei_number,
  ) async {
    Provider.of<MobileInfoProvider>(context, listen: false).setLoading(true);
    log('${ApiURls.baseURL}${ApiURls.userLoginLogsSave}pusername=$pusername&ppassword=$ppassword&pemp_id=$pemp_id&pmobiledevice=$pmobiledevice&plogindatetime=$plogindatetime&pissuccessful=$pissuccessful&pisphysicaldevice=$pisphysicaldevice&pmobilename=$pmobilename&pmobileversion=$pmobileversion&pmobileidentifier=$pmobileidentifier&preleaseversion=$preleaseversion&pmiscinfo=$pmiscinfo&pisshow=$pisshow&pdevappid=$pdevappid&platitude=$platitude&plongitude=$plongitude&plocation=$plocation&pauthtokenkey=$pauthtokenkey&pimei_number=$pimei_number');
    try {
      var response = await http.get(
        Uri.parse(
            '${ApiURls.baseURL}${ApiURls.userLoginLogsSave}pusername=$pusername&ppassword=$ppassword&pemp_id=$pemp_id&pmobiledevice=$pmobiledevice&plogindatetime=$plogindatetime&pissuccessful=$pissuccessful&pisphysicaldevice=$pisphysicaldevice&pmobilename=$pmobilename&pmobileversion=$pmobileversion&pmobileidentifier=$pmobileidentifier&preleaseversion=$preleaseversion&pmiscinfo=$pmiscinfo&pisshow=$pisshow&pdevappid=$pdevappid&platitude=$platitude&plongitude=$plongitude&plocation=$plocation&pauthtokenkey=$pauthtokenkey&pimei_number=$pimei_number'),
        headers: ConstantFile.loginHeaders,
      );
      var apiRemponse = jsonDecode(response.body);
      log("response statusCode = ${response.statusCode.toString()}");
      if (response.statusCode == 200) {
        log('${apiRemponse['presponse_code']} = 200');
        if (apiRemponse['presponse_code'] == 'Successfull') {
          log('First Api Hit Successfull');
          log('userLoginLogsSave');

          // ToastUtils.showCustomToast(
          //   context,
          //   'Request Send Succesfully',
          //   Colors.green,
          // );
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'Request Not Send ',
          Colors.red,
        );
        Provider.of<MobileInfoProvider>(context, listen: false)
            .setLoading(false);
      }
    } catch (e) {
      Provider.of<MobileInfoProvider>(context, listen: false).setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Change Password Api
  Future<void> changeUserPassword(
    BuildContext context,
    String oldpassword,
    String confirmPassword,
    String review,
    String username,
    String userPasword,
    var employecode,
    var employeId,
    var deviceInformation,
  ) async {
    log('oldpassword = ' + oldpassword);
    log('confirmPassword = ' + confirmPassword);
    log('review = ' + review);
    log('username = ' + username);
    log("userPasword = " + userPasword);
    log("employecode = " + employecode);
    log("employeId = " + employeId);
    log("deviceInformation = " + deviceInformation);
    log('${ApiURls.baseURL}${ApiURls.changePassword}pemp_Id=$employeId&Puser_Name=$username&Ppassword=$oldpassword&Pnew_Password=$confirmPassword&Pcuserid=$username&Pcuserterm=$deviceInformation&PRemarks=$review');

    try {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
      var response = await http.post(
        Uri.parse(
            '${ApiURls.baseURL}${ApiURls.changePassword}pemp_Id=$employeId&Puser_Name=$username&Ppassword=$oldpassword&Pnew_Password=$confirmPassword&Pcuserid=$username&Pcuserterm=$deviceInformation&PRemarks=$review'),
        headers: ConstantFile.loginHeaders,
      );
      var apiRemponse = jsonDecode(response.body);
      // log(apiRemponse);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        if (apiRemponse['presponse_code'] == '0') {
          SharedPref.saveUserPassword(confirmPassword);

          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          log('Password Updated Successfully');
          AppRoutes.pushAndRemoveUntil(
              context, PageTransitionType.bottomToTop, const MyNavigationBar());
          ToastUtils.showCustomToast(
            context,
            'Password Updated Successfully',
            Colors.green,
          );
        }
        if (apiRemponse['presponse_code'] == '1') {
          log('Account Not Exist');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            'Invalid User',
            Colors.red,
          );
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'Entered password is incorrect',
          Colors.red,
        );
        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      }
    } catch (e) {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Leave Request Api
  Future<bool> leaveRequestApi(
    BuildContext context,
    var employeId,
    startDate,
    endDate,
    leaveId,
    description,
    employCode,
    deviceInfo,
  ) async {
    bool result = false;
    try {
      print(" in the response");
      var response = await http.post(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.leaveRequest}pemp_Id=$employeId&pfrom_Date=$startDate&pto_Date=$endDate&pleave_Id=$leaveId&pdescription=$description&pcuserid=$employCode&pcuserterm=$deviceInfo',
        ),
        headers: ConstantFile.loginHeaders,
      );
      print(response.statusCode);
      Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body));
      if (response.statusCode == 200) {
        print(data['presponse_desc'].toString());
        if (data['presponse_desc'] == 'Leave Submitted successfully') {
          result = true;
          ToastUtils.showCustomToast(
            context,
            data['presponse_desc'].toString(),
            Colors.green,
          );
        } else {
          ToastUtils.showCustomToast(
            context,
            data['presponse_desc'].toString(),
            Colors.red,
          );
        }
      } else {
        result = false;
      }
    } catch (e) {
      log(e.toString());
      result = false;
    }

    return result;
  }

  // User MarkAttedndance Employe Api
  Future<void> markAttendanceApi(
    BuildContext context,
    employeUserNmae,
    employeUserPassword,
    // var _employeID,
    _employeUserId,
    attendancedate,
    attendanceMode,
    attendanceserialNo,
    attendanceVersionNo,
    employelatidude,
    employeLongitude,
    employeRemark,
    pcuserid,
  ) async {
    Provider.of<MarEmployeAttendanceLoadingProvider>(context, listen: false)
        .setLoading(true);
    log(
      '===${ApiURls.baseURL}${ApiURls.markAttendance}pemp_Id=$pcuserid&pattendance_date=$attendancedate&pattendance_mode=$attendanceMode&pmob_serial_no=$attendanceserialNo&pmob_version=$attendanceVersionNo&platitude=$employelatidude&plongitude=$employeLongitude&premarks=$employeRemark&pcuserid=$employeUserNmae&pcuserterm=$attendanceMode',
    );
    try {
      log(
        '${ApiURls.baseURL}${ApiURls.markAttendance}pemp_Id=$pcuserid&pattendance_date=$attendancedate&pattendance_mode=$attendanceMode&pmob_serial_no=$attendanceserialNo&pmob_version=$attendanceVersionNo&platitude=$employelatidude&plongitude=$employeLongitude&premarks=$employeRemark&pcuserid=$employeUserNmae&pcuserterm=$attendanceMode',
      );

      Provider.of<MarEmployeAttendanceLoadingProvider>(context, listen: false)
          .setLoading(true);
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.markAttendance}pemp_Id=$pcuserid&pattendance_date=$attendancedate&pattendance_mode=$attendanceMode&pmob_serial_no=$attendanceserialNo&pmob_version=$attendanceVersionNo&platitude=$employelatidude&plongitude=$employeLongitude&premarks=$employeRemark&pcuserid=$employeUserNmae&pcuserterm=$attendanceMode',
        ),
        headers: ConstantFile.loginHeaders,
      );
      Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body));
      log('api anser = ' + data.toString());
      if (response.statusCode == 200) {
        log('status 200');
        if (data['presponse_code'] == 'Attendance marked successfully') {
          log('i am in if else');

          Provider.of<MarEmployeAttendanceLoadingProvider>(context,
                  listen: false)
              .setLoading(false);
          // AppRoutes.push(context, PageTransitionType.bottomToTop,
          //     const EmployessSpAttendance());
          // AppRoutes.pop(context);
          // AppRoutes.push(context, PageTransitionType.bottomToTop,
          //     const EmployessSpAttendance());

          ToastUtils.showCustomToast(
            context,
            'Attendance marked successfully',
            Colors.green,
          );
        }
        if (data['presponse_desc'] == '1') {
          Provider.of<MarEmployeAttendanceLoadingProvider>(context,
                  listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            '${data['presponse_code']}',
            Colors.red,
          );
        }

        if (data['presponse_code'] == '05') {
          Provider.of<MarEmployeAttendanceLoadingProvider>(context,
                  listen: false)
              .setLoading(false);
          log('Rouster Not Genereted');
          Provider.of<MarEmployeAttendanceLoadingProvider>(context,
                  listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            'Attendance Not Marked',
            Colors.red,
          );
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'An unexpected error occured',
          Colors.red,
        );
        Provider.of<MarEmployeAttendanceLoadingProvider>(context, listen: false)
            .setLoading(false);
      }
    } catch (e) {
      Provider.of<MarEmployeAttendanceLoadingProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get Employee Detail Api
  Future<void> getpersonalEmployeeDetail(
    BuildContext context,
    _employeID,
    _employeUsername,
    _employeUserpassword,
    _employeTdate,
  ) async {
    try {
      log('Single user data is hitting');
      Provider.of<GetUserDetailProvider>(context, listen: false)
          .setLoading(true);
      log(
        '${ApiURls.baseURL}${ApiURls.getEmplyeDetail}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtDate=$_employeTdate',
      );
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.getEmplyeDetail}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtDate=$_employeTdate',
        ),
        headers: ConstantFile.loginHeaders,
      );
      log(' response.statusCode = ${response.statusCode.toString()}');
      if (response.statusCode == 200) {
        // log(response.body);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        List data2 = data['Table'];
        // log('data 2 = $data2');
        log('api anser = ' + data.toString());
        // log('status 200');
        empDetails = data['Table'];
        log('This is my updated Function');
        for (var element in empDetails) {
          Provider.of<GetUserDetailProvider>(context, listen: false)
              .saveDataintoList(element);
          Provider.of<GetUserDetailProvider>(context, listen: false)
              .setLoading(false);
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'An unexpected error occured',
          Colors.red,
        );
      }
    } catch (e) {
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get All EmployeesDetail for Attendance Api
  Future<void> getALLEmployeeDetail(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
    var dtDate,
  ) async {
    try {
      Provider.of<AllEmployeDetailProvider>(context, listen: false)
          .setLoading(true);
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.getallEmplyeDetail}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtDate=$dtDate',
        ),
        headers: ConstantFile.loginHeaders,
      );
      // log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Provider.of<AllEmployeDetailProvider>(context, listen: false)
            .allEmployeDetails
            .clear();
        Provider.of<AllEmployeDetailProvider>(context, listen: false)
            .setLoading(false);
        // log(response.body);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        List data2 = data['Table'];
        // log('getALLEmployeeDetail = $data2');
        // log('api getALLEmployeeDetail = ' + data.toString());
        // log('status 200');
        allEmpDetails = data['Table'];

        log('getALLEmployeeDetail = $allEmpDetails');
        for (var element in allEmpDetails) {
          Provider.of<AllEmployeDetailProvider>(context, listen: false)
              .saveDataintoList(element);
        }
      } else {
        Provider.of<AllEmployeDetailProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'An unexpected error occured',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<AllEmployeDetailProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get All places Api
  Future<void> getALLplaces(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
  ) async {
    try {
      Provider.of<GetAllPlacesProvider>(context, listen: false)
          .allPlacesDetails
          .clear();
      Provider.of<AllEmployeDetailProvider>(context, listen: false)
          .setLoading(true);
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.getEmployeePlaces}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID',
        ),
        headers: ConstantFile.loginHeaders,
      );
      // log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Provider.of<GetAllPlacesProvider>(context, listen: false)
            .setLoading(false);
        // log(response.body);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        List data2 = data['Table'];
        log('data 2 = $data2');
        log('api anser = ' + data.toString());
        log('status 200');
        allplacesInfo = data['Table'];
        log('allplacesInfo = $allplacesInfo');
        for (var element in allplacesInfo) {
          Provider.of<GetAllPlacesProvider>(context, listen: false)
              .saveDataintoList(element);
        }
      } else {
        Provider.of<GetAllPlacesProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'An unexpected error occured',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<GetAllPlacesProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get SuperVisor Status Api
  Future<void> getSupervisorStatus(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
  ) async {
    try {
      Provider.of<AllEmployeDetailProvider>(context, listen: false)
          .setLoading(true);
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.getSupervisorStatus}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID',
        ),
        headers: ConstantFile.loginHeaders,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Provider.of<GetSupervisorStatusProvider>(context, listen: false)
            .setLoading(false);
        log(response.body);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        // List data2 = data['Table'];
        // log('data 2 = $data2');
        // log('api anser = ' + data.toString());
        // log('status 200');
        superVisorStatusInfo = data['Table'];

        log('superVisorStatusInfo = $superVisorStatusInfo');
        for (var element in superVisorStatusInfo) {
          Provider.of<GetSupervisorStatusProvider>(context, listen: false)
              .saveDataintoList(element);
        }
      } else {
        Provider.of<GetSupervisorStatusProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'An unexpected error occured',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<GetSupervisorStatusProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

//  Get Employees Attendance Summary Detail
  Future<void> getALLEmployeeAttendanceSummeryDetail(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
    var dtfromDate,
    var dtToDate,
  ) async {
    try {
      Provider.of<AllEmployeAttendanceSummeryProvider>(context, listen: false)
          .setLoading(true);

      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.getEmployeesAttendanceSummaryDetail}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtToDate=$dtToDate',
        ),
        headers: ConstantFile.loginHeaders,
      );
      if (response.statusCode == 200) {
        log('Response = ${response.statusCode}');

        Provider.of<AllEmployeAttendanceSummeryProvider>(context, listen: false)
            .setLoading(false);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        allEmpDetails = data['Table'];
        for (var element in allEmpDetails) {
          Provider.of<AllEmployeAttendanceSummeryProvider>(context,
                  listen: false)
              .saveDataintoList(element);
        }
      } else {
        Provider.of<AllEmployeAttendanceSummeryProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'Rouster Not Generated',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<AllEmployeAttendanceSummeryProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Mark Self Employe Attedndance Api
  Future markSelfAttendanceApi(
    BuildContext context,
    var dialogNumer,
    _employeUserId,
    attendancedate,
    attendanceMode,
    attendanceserialNo,
    attendanceVersionNo,
    employelatidude,
    employeLongitude,
    employeRemark,
    pcuserid,
  ) async {
    log(
      '${ApiURls.baseURL}${ApiURls.markAttendance}pemp_Id=$_employeUserId&pattendance_date=$attendancedate&pattendance_mode=$attendanceMode&pmob_serial_no=$attendanceserialNo&pmob_version=$attendanceVersionNo&platitude=$employelatidude&plongitude=$employeLongitude&premarks=$employeRemark&pcuserid=$_employeUserId&pcuserterm=$attendanceMode',
    );
    try {
      log(
        '${ApiURls.baseURL}${ApiURls.markAttendance}pemp_Id=$_employeUserId&pattendance_date=$attendancedate&pattendance_mode=$attendanceMode&pmob_serial_no=$attendanceserialNo&pmob_version=$attendanceVersionNo&platitude=$employelatidude&plongitude=$employeLongitude&premarks=$employeRemark&pcuserid=$_employeUserId&pcuserterm=$attendanceMode',
      );

      Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.markAttendance}pemp_Id=$_employeUserId&pattendance_date=$attendancedate&pattendance_mode=$attendanceMode&pmob_serial_no=$attendanceserialNo&pmob_version=$attendanceVersionNo&platitude=$employelatidude&plongitude=$employeLongitude&premarks=$employeRemark&pcuserid=$_employeUserId&pcuserterm=$attendanceMode&pcuserid=$pcuserid&pcuserterm=$employeRemark',
        ),
        headers: ConstantFile.loginHeaders,
      );
      Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body));
      log('api anser = ' + data.toString());
      if (response.statusCode == 200) {
        log('status 200');
        if (data['presponse_code'] == 'Attendance marked successfully') {
          log('i am in if else');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          // Future.delayed(const Duration(seconds: 3), () async {
          //   AppRoutes.push(context, PageTransitionType.bottomToTop,
          //       const MyNavigationBar());
          // });
          dialogNumer == 1
              ? ToastUtils.showCustomDialog(
                  context, 'Your attendace is Marked Successfully', greenShade)
              : ToastUtils.showCustomDialog(context,
                  'You checkout has been marked successfully.', greenShade);

          // ToastUtils.showCustomToast(
          //   context,
          //   'Attendance marked successfully',
          //   Colors.green,
          // );
        }
        if (data['presponse_desc'] == '1') {
          log('Rouster Not Genereted');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            '${data['presponse_code']}',
            Colors.red,
          );
        }

        if (data['presponse_desc'] == '5') {
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          log('Rouster Not Genereted');
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);
          ToastUtils.showCustomToast(
            context,
            '${data['presponse_code']}',
            Colors.red,
          );
        }
      } else {
        ToastUtils.showCustomToast(
          context,
          'An unexpected error occured',
          Colors.red,
        );
        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      }
    } catch (e) {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get EmployeesDetail Leave Api
  Future<void> getEmployeeLeavesDetail(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
    var dtfromDate,
    var dtToDate,
  ) async {
    try {
      Provider.of<EmployeLeavesRequestDetailProvider>(context, listen: false)
          .setLoading(true);
      log(
        '${ApiURls.baseURL}${ApiURls.getEmployeesLeaveRequestDetail}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtToDate=$dtToDate',
      );
      var response = await http.get(
        Uri.parse(
          '${ApiURls.baseURL}${ApiURls.getEmployeesLeaveRequestDetail}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtToDate=$dtToDate',
          //  '${ApiURls.baseURL}${ApiURls.getEmployeesAttendanceSummaryDetail}puser_name=test&ppassword=112233&pemp_id=533&dtfromDate=01-apr-2022&dtToDate=25-apr-2022'
        ),
        headers: ConstantFile.loginHeaders,
      );
      if (response.statusCode == 200) {
        Provider.of<EmployeLeavesRequestDetailProvider>(context, listen: false)
            .employeLeaveRequestDetails
            .clear();
        Provider.of<EmployeLeavesRequestDetailProvider>(context, listen: false)
            .setLoading(false);
        // log(response.body);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        List data2 = data['Table'];
        log('leaveRequestDetails = $data2');
        leaveRequestDetails = data['Table'];

        log('leaveRequestDetails  = $leaveRequestDetails');
        for (var element in leaveRequestDetails) {
          Provider.of<EmployeLeavesRequestDetailProvider>(context,
                  listen: false)
              .saveDataintoList(element);
        }
      } else {
        Provider.of<EmployeLeavesRequestDetailProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'Rouster Not Generated',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<EmployeLeavesRequestDetailProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get getSingleUserAttendanceDetail  Api
  Future<void> getSingleUserAttendanceDetail(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
    var dtfromDate,
    var dtToDate,
  ) async {
    try {
      Provider.of<SingleUserAttendanceProvider>(context, listen: false)
          .setLoading(true);
      log('${ApiURls.baseURL}${ApiURls.getEmployeesDetailforAttendance}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtDate=$dtToDate');
      var response = await http.get(
        Uri.parse(
            '${ApiURls.baseURL}${ApiURls.getEmployeesDetailforAttendance}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtToDate=$dtToDate'),
        headers: ConstantFile.loginHeaders,
      );
      if (response.statusCode == 200) {
        Provider.of<SingleUserAttendanceProvider>(context, listen: false)
            .singleUserAttendanceDetails
            .clear();
        // Provider.of<SingleUserAttendanceProvider>(context, listen: false)
        // .singleUserPresentDetails
        // .clear();
        // Provider.of<SingleUserAttendanceProvider>(context, listen: false)
        // .singleUserLateDetails
        // .clear();
        // Provider.of<SingleUserAttendanceProvider>(context, listen: false)
        // .singleUserRESTDetails
        // .clear();
        // Provider.of<SingleUserAttendanceProvider>(context, listen: false)
        // .singleUserHOLIDAYDetails
        // .clear();
        Provider.of<SingleUserAttendanceProvider>(context, listen: false)
            .setLoading(false);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        List data2 = data['Table'];
        log('singleEmployeAttendanceDetails = $data2');
        singleEmployeAttendanceDetails = data['Table'];

        log('singleEmployeAttendanceDetails  = $singleEmployeAttendanceDetails');
        for (var element in singleEmployeAttendanceDetails) {
          Provider.of<SingleUserAttendanceProvider>(context, listen: false)
              .saveDataintoList(element);
        }
      } else {
        Provider.of<SingleUserAttendanceProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'Rouster Not Generated',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<SingleUserAttendanceProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }

  // User Get getSingleUserAttendanceDetail  Api
  Future<void> getSingleUserAttendanceForMapScreenDetail(
    BuildContext context,
    var _employeID,
    var _employeUsername,
    var _employeUserpassword,
    var dtfromDate,
    var dtToDate,
  ) async {
    try {
      Provider.of<SingleUserAttendanceProvider>(context, listen: false)
          .setLoading(true);
      log('${ApiURls.baseURL}${ApiURls.getEmployeesDetailforAttendance}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtDate=$dtToDate');
      var response = await http.get(
        Uri.parse(
            '${ApiURls.baseURL}${ApiURls.getEmployeesDetailforAttendance}puser_name=$_employeUsername&ppassword=$_employeUserpassword&pemp_id=$_employeID&dtfromDate=$dtfromDate&dtToDate=$dtToDate'),
        headers: ConstantFile.loginHeaders,
      );
      if (response.statusCode == 200) {
        Provider.of<SingleUserAttendanceProvider>(context, listen: false)
            .singleUserAttendanceDetails1
            .clear();

        Provider.of<SingleUserAttendanceProvider>(context, listen: false)
            .setLoading(false);
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        List data2 = data['Table'];
        log('singleEmployeAttendanceDetails = $data2');
        singleEmployeAttendanceDetails1 = data['Table'];

        log('singleEmployeAttendanceDetails1  = $singleEmployeAttendanceDetails1');
        for (var element in singleEmployeAttendanceDetails1) {
          Provider.of<SingleUserAttendanceProvider>(context, listen: false)
              .saveDataintoToMapList(element);
        }
      } else {
        Provider.of<SingleUserAttendanceProvider>(context, listen: false)
            .setLoading(false);
        ToastUtils.showCustomToast(
          context,
          'Rouster Not Generated',
          Colors.red,
        );
      }
    } catch (e) {
      Provider.of<SingleUserAttendanceProvider>(context, listen: false)
          .setLoading(false);
      ToastUtils.showCustomToast(
          context, 'An unexpected error occured', Colors.red);
      log(e.toString());
    }
  }
}
