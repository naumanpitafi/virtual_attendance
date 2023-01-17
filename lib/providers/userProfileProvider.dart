
import 'package:flutter/material.dart';
import 'package:virtual_attendance/models/userProfileDetails.dart';

class GetUserDetailProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }
  bool userProfileloading = false;


  setLoading(bool val) {
    userProfileloading = val;
    notifyListeners();
  }


  List<EmployeProfileModel> empDetails1 = [];

  saveDataintoList(element) {
    empDetails1.add(EmployeProfileModel.fromJson(element));
    notifyListeners();
  }
}
