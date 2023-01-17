import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/allEmployeDetailsforAttendancemodel.dart';
import '../models/getAttendanceinformationofAUsera.dart';

class SingleUserAttendanceProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool singleUserAttendanceloading = false;

  setLoading(bool val) {
    singleUserAttendanceloading = val;
    notifyListeners();
  }

  List<SingleUserAttendanceModel> singleUserAttendanceDetails = [];
  List<SingleUserAttendanceModel> singleUserAttendanceDetails1 = [];
  List<SingleUserAttendanceModel> singleUserAbsentDetails = [];
  List<SingleUserAttendanceModel> singleUserPresentDetails1 = [];
  List<SingleUserAttendanceModel> singleUserPresentDetails = [];
  List<SingleUserAttendanceModel> singleUserLateDetails = [];
  List<SingleUserAttendanceModel> singleUserRESTDetails = [];
  List<SingleUserAttendanceModel> singleUserHOLIDAYDetails = [];
  List<SingleUserAttendanceModel> singleUserLeaveDetails = [];
  String? attendanceDate;
  String? attendanceDate2;
  String? attendanceFinalDate;
  String? attendanceStatusofUser;
  String? intimeofUser;
  String? outtimeofUser;
  saveDataintoList(element) {

    singleUserAttendanceDetails.add(SingleUserAttendanceModel.fromJson(element));

    singleUserAbsentDetails = singleUserAttendanceDetails
        .where((element) => element.employeDESCR == "ABSENT")
        .toList();
    singleUserPresentDetails = singleUserAttendanceDetails
        .where((element) => element.employeDESCR == "PRESENT")
        .toList();
    singleUserPresentDetails1 = singleUserAttendanceDetails
        .where((element) => element.attendanceStatus == "P")
        .toList();
    singleUserLateDetails = singleUserAttendanceDetails
        .where((element) => element.employeDESCR == "LATE")
        .toList();
    singleUserRESTDetails = singleUserAttendanceDetails
        .where((element) => element.employeDESCR == "REST")
        .toList();
    singleUserHOLIDAYDetails = singleUserAttendanceDetails
        .where((element) => element.employeDESCR == "HOLIDAY")
        .toList();

    singleUserLeaveDetails = singleUserAttendanceDetails
        .where((element) => element.employeDESCR == "LEAVE")
        .toList();

    notifyListeners();
  }

  saveDataintoToMapList(element) {
    singleUserAttendanceDetails1
        .add(SingleUserAttendanceModel.fromJson(element));
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    var dateTimenow = formatter.format(DateTime.now());

    intimeofUser = singleUserAttendanceDetails1[0].inTime!.isNotEmpty
        ? singleUserAttendanceDetails1[0].inTime
        : null;
    outtimeofUser = singleUserAttendanceDetails1[0].outTime!.isNotEmpty
        ? singleUserAttendanceDetails1[0].outTime
        : null;
    attendanceDate = singleUserAttendanceDetails1[0].attendanceDate;
    DateTime dateTime = DateTime.parse(attendanceDate.toString());
    var datadate = formatter.format(dateTime);
    attendanceDate2 = datadate;
    attendanceFinalDate = dateTimenow == attendanceDate2 ? 'true' : 'false';

    notifyListeners();
  }
}
