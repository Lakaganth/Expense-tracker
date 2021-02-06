import 'package:cached_network_image/cached_network_image.dart';
import 'package:fleming_expense_tracker/constants/constants.dart';
import 'package:fleming_expense_tracker/controllers/user_controller.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/admin_trips.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/sidebar_screen.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/user_trips.dart';
import 'package:fleming_expense_tracker/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final userController = Get.put(UserController());
  final authController = Get.put(AuthController());

  Animation<Offset> sidebarAnimation;
  Animation<double> fadeAnimation;
  AnimationController sidebarAnimationController;

  var sidebarHidden = true;
  @override
  void initState() {
    super.initState();
    sidebarAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    sidebarAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: sidebarAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: sidebarAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    sidebarAnimationController.dispose();
  }

  void triggerAnimation() {
    setState(() {
      sidebarHidden = !sidebarHidden;
    });

    sidebarAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      init: AuthController(),
      builder: (_) => _?.firestoreUser?.value?.uid == null
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              backgroundColor: kBackgroundColor,
              body: Stack(
                // overflow: Overflow.visible,
                children: [
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Navbar(triggerAnimation),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                "Welcome back, \n${authController.firestoreUser.value.name.capitalizeFirst}",
                                style: kLargeHeading,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 18.0),
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: authController
                                            .firestoreUser.value.photoUrl ==
                                        ""
                                    ? AssetImage(
                                        'assets/images/default_avatar.png')
                                    : CachedNetworkImageProvider(authController
                                        .firestoreUser.value.photoUrl),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Your Trips,",
                            style: GoogleFonts.roboto(fontSize: 28.0),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        UserTrips(),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Admin Trips,",
                            style: GoogleFonts.roboto(fontSize: 28.0),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AdminTrips(),
                      ],
                    ),
                  ),
                  IgnorePointer(
                    ignoring: sidebarHidden,
                    child: Stack(
                      children: [
                        FadeTransition(
                          opacity: fadeAnimation,
                          child: GestureDetector(
                            child: Container(
                              color: Color.fromRGBO(36, 38, 41, 0.4),
                              height: Get.height,
                              width: Get.width,
                            ),
                            onTap: () {
                              setState(() {
                                sidebarHidden = !sidebarHidden;
                              });
                              sidebarAnimationController.reverse();
                            },
                          ),
                        ),
                        SlideTransition(
                          position: sidebarAnimation,
                          child: SafeArea(
                            child: SidebarScreen(),
                            bottom: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
