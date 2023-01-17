import 'package:flutter/material.dart';
import '../models/allEmployeDetailsforAttendancemodel.dart';
import '../models/employeLeaveRequestDetailsModel.dart';

class EmployeLeavesRequestDetailProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool employeLeavesloading = false;

  setLoading(bool val) {
    employeLeavesloading = val;
    notifyListeners();
  }

  List<EmployeLeavesRequestDetailsemodel> employeLeaveRequestDetails = [];
  List<EmployeLeavesRequestDetailsemodel> appreovedLeavesData = [];
  List<EmployeLeavesRequestDetailsemodel> rejectedLeavesData = [];
  List<EmployeLeavesRequestDetailsemodel> pendingLeavesData = [];

  saveDataintoList(element) {
    // employeLeaveRequestDetails.clear();
    employeLeaveRequestDetails
        .add(EmployeLeavesRequestDetailsemodel.fromJson(element));
    appreovedLeavesData = employeLeaveRequestDetails
        .where((element) => element.employeApproved == "Y")
        .toList();
    rejectedLeavesData = employeLeaveRequestDetails
        .where((element) => element.employeRejected.toString() == "Y")
        .toList();
    pendingLeavesData = employeLeaveRequestDetails
    .where((element) => element.employeRejected == "N" && element.employeApproved  == "N")
    .toList();

    notifyListeners();
  }
}
