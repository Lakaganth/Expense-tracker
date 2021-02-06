import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/controllers/user_controller.dart';
import 'package:get/get.dart';

class Authbinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}
