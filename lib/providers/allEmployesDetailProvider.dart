import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/allEmployeDetailsforAttendancemodel.dart';

class AllEmployeDetailProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool allEmployeloading = false;

  setLoading(bool val) {
    allEmployeloading = val;
    notifyListeners();
  }

  List<AllEmployeDetailsforAttendancemodel> allEmployeDetails = [];
  List<AllEmployeDetailsforAttendancemodel> presentData = [];
  List<AllEmployeDetailsforAttendancemodel> absentData = [];
  List<AllEmployeDetailsforAttendancemodel> leaveData = [];
  List<AllEmployeDetailsforAttendancemodel> lateData = [];

  saveDataintoList(element) {
    log('All Done');
    allEmployeDetails
        .add(AllEmployeDetailsforAttendancemodel.fromJson(element));
         log(" All = ${ allEmployeDetails.length.toString()}");
      
    presentData = allEmployeDetails
        .where((element) => element.attendanceStatus.toString() == "P")
        .toList();
    log(" presentData = ${presentData.length.toString()}");
    absentData = allEmployeDetails
        .where((element) => element.attendanceStatus.toString() == "A")
        .toList();
        log(" absentData = ${absentData.length.toString()}");
    leaveData = allEmployeDetails
        .where((element) => element.employeDescr.toString() == "LEAVE")
        .toList();
    lateData = allEmployeDetails
        .where((element) => element.employeDescr.toString() == "LATE")
        .toList();

    notifyListeners();
  }
}
