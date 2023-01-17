import 'package:flutter/widgets.dart';

import '../models/getEmployePlacesModel.dart';

class GetAllPlacesProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool allPlacesDetailsloading = false;

  setLoading(bool val) {
    allPlacesDetailsloading = val;
    notifyListeners();
  }

  List<EmployePlacesModel> allPlacesDetails = [];

  saveDataintoList(element) {
    allPlacesDetails.add(EmployePlacesModel.fromJson(element));
    // notifyListeners();
  }
}
