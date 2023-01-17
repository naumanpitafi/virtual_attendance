import 'package:flutter/material.dart';

class MarEmployeAttendanceLoadingProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool marEmployeAttendanceLoadingLoading = false;
  int colorvalue = 1;
  setColorValue(int val) {
    colorvalue = val;
    notifyListeners();
  }
  setLoading(bool val) {
    marEmployeAttendanceLoadingLoading = val;
    notifyListeners();
  }
}
