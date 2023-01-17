import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/allEmployesDetailProvider.dart';
import 'package:virtual_attendance/providers/employeAttendanceSummery.dart';
import 'package:virtual_attendance/providers/getEmployeesLeaveRequestDetail.dart';
import 'package:virtual_attendance/providers/loadingProvider.dart';
import 'package:virtual_attendance/providers/singleUserAttendanceProvider.dart';

import 'getEmployePlacesProvider.dart';
import 'getSupervisorStatusProvider.dart';
import 'markEmployeAttendanceProvider.dart';
import 'mobileInforProvider.dart';
import 'userProfileProvider.dart';

var allProvider = [
  ChangeNotifierProvider<LoadingProvider>(
    create: (_) => LoadingProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<GetUserDetailProvider>(
    create: (_) => GetUserDetailProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<AllEmployeDetailProvider>(
    create: (_) => AllEmployeDetailProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<GetAllPlacesProvider>(
    create: (_) => GetAllPlacesProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<GetSupervisorStatusProvider>(
    create: (_) => GetSupervisorStatusProvider(),
    lazy: true,
  ),
   ChangeNotifierProvider<MobileInfoProvider>(
    create: (_) => MobileInfoProvider(),
    lazy: true,
  ),

  ChangeNotifierProvider<AllEmployeAttendanceSummeryProvider>(
    create: (_) => AllEmployeAttendanceSummeryProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<EmployeLeavesRequestDetailProvider>(
    create: (_) => EmployeLeavesRequestDetailProvider(),
    lazy: true,
  ),

   ChangeNotifierProvider<SingleUserAttendanceProvider>(
    create: (_) => SingleUserAttendanceProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<MarEmployeAttendanceLoadingProvider>(
    create: (_) => MarEmployeAttendanceLoadingProvider(),
    lazy: true,
  ),
];
