

import 'package:flutter/cupertino.dart';

import '../models/getSupervisorStatusModel.dart';

class GetSupervisorStatusProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool getSuperVisorStatusloading = false;

  setLoading(bool val) {
    getSuperVisorStatusloading = val;
    notifyListeners();
  }

  List<GetSupervisorStatusModel> superVisorStattusDetails = [];

  saveDataintoList(element) {
    superVisorStattusDetails.add(GetSupervisorStatusModel.fromJson(element));
    notifyListeners();
  }  
}