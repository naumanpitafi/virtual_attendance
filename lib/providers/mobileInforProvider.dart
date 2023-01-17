import 'package:flutter/material.dart';

class MobileInfoProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool makeMobileAuthRequestloading = false;
  bool userLoginLogsSaveloading = false;
  setLoading(bool val) {
    userLoginLogsSaveloading = val;
    notifyListeners();
  }

  var deviceToken;
  var devAppId; // androidInfo.androidId
  var devImEINumber; //androidInfo.id
  var attendanceMode; //androidInfo.model!;
  var pMobileDevice; //androidInfo.brand;
  var pmobileDevicename; //androidInfo.device;
  var mobileVersion; //androidInfo.version;
  var mobileidentifier; //androidInfo.product;
  var isPhysicalDevice; //androidInfo.isPhysicalDevice;
  var latitude; //MobileInfoScreen
  var longitude; //MobileInfoScreen
  var employelocation = ''; //MobileInfoScreen
  var userLoginSuccesfully; //MobileInfoScreen
  var employeLoginDateTime; //MobileInfoScreen

  var username;
  var userPassword;
  var userId;
}
