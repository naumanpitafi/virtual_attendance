import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_attendance/screens/login.dart';
import 'package:virtual_attendance/screens/supervisor/supervisorDashboard.dart';
import 'package:virtual_attendance/utils/app_routes.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                AppRoutes.push(context, PageTransitionType.fade, const Login());
              },
              child: const Text('Employ Screen')),
          ElevatedButton(
              onPressed: () {
                AppRoutes.push(context, PageTransitionType.fade,
                    const SupervisorDashboard());
              },
              child: const Text('Supervisor Screen')),
        ],
      )),
    );
  }
}
