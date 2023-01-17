import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/getEmployesAttendanceSummeryModel.dart';

class AllEmployeAttendanceSummeryProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool allEmployeAttendanceSummeryDetailsloading = false;

  setLoading(bool val) {
    allEmployeAttendanceSummeryDetailsloading = val;
    notifyListeners();
  }

  setvaluesto0(bool val) {
    // allEmployeAttendanceSummeryDetailsloading = val;
    if (val == true) {
      allEmployeAttendanceSummeryDetails.clear();
      absent = '0.0';
      present = '0.0';
      leave = '0.0';
      late = '0.0';
      restday = '0.0';
      holiday = '0.0';
    }
    notifyListeners();
  }

  List<GetEmployeAttendanceSummeryModel> allEmployeAttendanceSummeryDetails =
      [];
  String absent = '0.0';
  String present = '0.0';
  String leave = '0.0';
  String late = '0.0';
  String restday = '0.0';
  String holiday = '0.0';

  saveDataintoList(element) {
    allEmployeAttendanceSummeryDetails.clear();
    log('Function reunning correctly');
    allEmployeAttendanceSummeryDetails
        .add(GetEmployeAttendanceSummeryModel.fromJson(element));

    for (var singleElement in allEmployeAttendanceSummeryDetails) {
      if (singleElement.employedecription.toString() == 'ABSENT') {
        absent = singleElement.employeTotal.toString();
        log('absent = $absent');
      } else if (singleElement.employedecription == 'PRESENT') {
        present = singleElement.employeTotal.toString();
        log('present = $present');
      } else if (singleElement.employedecription.toString() == 'LATE') {
        late = singleElement.employeTotal.toString();
        log('late = $late');
      } else if (singleElement.employedecription.toString() == 'LEAVE') {
        leave = singleElement.employeTotal.toString();
        log('leave = $leave');
      } else if (singleElement.employedecription.toString() == 'REST') {
        restday = singleElement.employeTotal.toString();
        log('REST = $restday');
      } else if (singleElement.employedecription.toString() == 'HOLIDAY') {
        holiday = singleElement.employeTotal.toString();
        log('holiday = $holiday');
      }
    }
    notifyListeners();
  }
}
