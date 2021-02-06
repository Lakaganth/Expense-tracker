import 'package:fleming_expense_tracker/model/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _user = UserModel().obs;

  UserModel get currentUser => _user.value;

  set currentUser(UserModel value) => this._user.value = value;

  void clear() {
    _user.value = UserModel();
  }
}
