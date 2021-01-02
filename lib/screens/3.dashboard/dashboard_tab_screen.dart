import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/admin_trips.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/sidebar_screen.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/user_trips.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardTabScreen extends StatefulWidget {
  @override
  _DashboardTabScreenState createState() => _DashboardTabScreenState();
}

class _DashboardTabScreenState extends State<DashboardTabScreen>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(AuthController());

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
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
              appBar: AppBar(
                // backgroundColor: Colors.transparent,
                elevation: 0,

                bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.red,
                    unselectedLabelColor: Colors.white54,
                    labelColor: Colors.white,
                    indicatorWeight: 3.0,
                    tabs: [
                      Tab(
                        text: "Your Trips",
                        icon: Icon(Icons.card_travel),
                      ),
                      Tab(
                        text: "Admin Trips",
                        icon: Icon(Icons.supervised_user_circle),
                      ),
                    ]),
              ),
              drawer: Drawer(
                child: SidebarScreen(),
              ),
              body: TabBarView(controller: _tabController, children: [
                UserTrips(),
                AdminTrips(),
              ]),
            ),
    );
  }
}
