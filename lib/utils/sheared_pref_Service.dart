import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
//==============================  Biomatric  ============================//

  static saveBiometricInfo(bool number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometricInfo', number);
    log(number.toString());
  }

  static getBiometricInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeId = prefs.getBool('biometricInfo');
    return employeId;
  }

//remember me
  static saverememberMe(bool number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMeInfo', number);
    log(number.toString());
  }

  static getrememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeId = prefs.getBool('rememberMeInfo');
    return employeId;
  }

  static saveUserrememberMe(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userNamerememberMe', value);
  }

  static getUserNameRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userNamerememberMe');
    return userName;
  }

  static saveUserPasswordRememberMe(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userPasswordRememberMe', value);
  }

  static getUserPasswordRememeberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPassword = prefs.getString('userPasswordRememberMe');
    return userPassword;
  }

//==============================  Biomatric  ============================//

  static saveEmployeemail(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('employeEmail', number);
    log(number.toString());
  }

  static getEmployeemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeId = prefs.getString('employeEmail');
    return employeId;
  }

  static saveEmployeId(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('employeID', number);
    log(number.toString());
  }

  static getEmployeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeId = prefs.getString('employeID');
    return employeId;
  }

  static saveEmployeCode(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('employeCode', username);
    log(username.toString());
  }

  static getEmployeCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var employeCode = prefs.getString('employeCode');
    return employeCode;
  }

  static saveAttendancePermission(String attendancePermission) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('attendancePermission', attendancePermission);
  }

  static getAttendancePermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('attendancePermission');
    return value;
  }

  static saveIsSuperVisor(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isSupervisor', value);
  }

  static getisSupervisor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isSupervisor = prefs.getString('isSupervisor');
    return isSupervisor;
  }

  static saveIntroScreenState(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log(value);
    prefs.setString('remember_me', value);
  }

  static getIntroScreenState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var remember = prefs.getString('remember_me');
    return remember;
  }

  static saveUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', value);
  }

  static getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    return userName;
  }

  static saveUserPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userPassword', value);
  }

  static getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPassword = prefs.getString('userPassword');
    return userPassword;
  }
}
