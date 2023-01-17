import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:virtual_attendance/providers/userProfileProvider.dart';
import 'package:virtual_attendance/utils/app_routes.dart';
import 'package:virtual_attendance/utils/color_constants.dart';
import 'package:virtual_attendance/widgets/default_text.dart';
import '../../utils/image_src.dart';
import '../employ With No Attendance Rights/home.dart';
import '../employ With No Attendance Rights/notifications.dart';
import '../employ With No Attendance Rights/profile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../supervisor/markEmployeAttendanc.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const Home(),
    const NotificationsScreen(),
    const Profile(),
  ];

  String version = "";

  @override
  void initState() {
    // TODO: implement initState
  }
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    GetUserDetailProvider prov = Provider.of<GetUserDetailProvider>(context);
    return Scaffold(
      key: _globalKey,
      appBar: _selectedIndex != 0
          ? null
          : AppBar(
              toolbarHeight: 78.h,
              elevation: 2,
              leading: _selectedIndex != 0
                  ? null
                  : prov.userProfileloading
                      ? null
                      : prov.empDetails1.isEmpty
                          ? null
                          : prov.empDetails1[0].employeHOD == 'Y'
                              ? IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: white,
                                    size: 35.r,
                                  ),
                                  onPressed: () =>
                                      _globalKey.currentState!.openDrawer())
                              : null,
              flexibleSpace: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(gradient: primaryreadGradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 55.47.h,
                            width: 234.36.w,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(logowithname),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      drawer: _selectedIndex != 0
          ? null
          : prov.userProfileloading
              ? null
              : prov.empDetails1.isEmpty
                  ? null
                  : prov.empDetails1[0].employeHOD == 'Y'
                      ? Drawer(
                          // backgroundColor: Colors.black,

                          elevation: 0.0,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: DrawerHeader(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 94.h,
                                          width: 110.w,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(logoupdate),
                                                fit: BoxFit.contain),
                                          ),
                                        )
                                        // Image(image: AssetImage(logoupdate)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    text(context, 'Kohistan Logistics', 14.sp,
                                        fontFamily: "Poppins-Medium",
                                        color: blackshade1)
                                  ],
                                )),
                              ),
                              Expanded(
                                flex: 9,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      onTap: () {
                                        _globalKey.currentState!.closeDrawer();
                                        AppRoutes.push(
                                            context,
                                            PageTransitionType.bottomToTop,
                                            const EmployessSpAttendance());
                                        // AppRoutes.pop(context);
                                      },
                                      leading: Container(
                                        height: 35.h,
                                        width: 35.w,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(presentimage),
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                                      title: text(context,
                                          'Mark Employees Attendance', 12.sp,
                                          fontFamily: "Poppins-Medium",
                                          color: blackshade1),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15.r),
                                      child: Text(
                                        "Version  1.0.0",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: "Poppins-Medium",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ))
                      : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: Center(
          child: widgetOptions[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        selectedItemColor: readcolor,
        selectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 12.sp),
        unselectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 12.sp),
        unselectedItemColor: Color(0xff2A2E32),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
