import 'package:firebase_core/firebase_core.dart';
import 'package:fleming_expense_tracker/constants/app_routes.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/controllers/bindings/authBinding.dart';

// import 'package:fleming_expense_tracker/screens/2.authenitication/login_screen.dart';
// import 'package:fleming_expense_tracker/utilities/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Authbinding(),
      initialRoute: "/",
      getPages: AppRoutes.routes,
    );
  }
}
