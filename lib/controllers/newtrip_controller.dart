import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/controllers/currency_controller.dart';
import 'package:fleming_expense_tracker/model/trip_model.dart';
import 'package:fleming_expense_tracker/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewtripController extends GetxController {
  static NewtripController to = Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CurrencyController currency = Get.put(CurrencyController());
  final AuthController auth = Get.put(AuthController());

  Rx<TripModel> tripModel = Rx<TripModel>();
  RxString homeCurrency = "CAD".obs;
  RxString destCurrency = "USD".obs;

  RxDouble travelBudget = 0.0.obs;
  RxDouble foodBudget = 0.0.obs;
  RxDouble projectBudget = 0.0.obs;
  RxDouble totalBudget = 0.0.obs;
  var searchUsers;
  var tempTeamMember = [];
  RxString searchQuery = ''.obs;

  List<String> teamMembers = [];

  TripModel get newTrip => tripModel.value;

  setHomeCurrencyValue(val) => homeCurrency.value = val;
  setdestCurrency(val) => destCurrency.value = val;

  setTravelBudget(val) {
    travelBudget.value = val;
    return setTotalBudget();
  }

  setFoodBudget(val) {
    foodBudget.value = val;
    return setTotalBudget();
  }

  setProjectBudget(val) {
    projectBudget.value = val;
    return setTotalBudget();
  }

  setTotalBudget() {
    return totalBudget.value =
        travelBudget.value + foodBudget.value + projectBudget.value;
  }

  TextEditingController tripnameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController homeCurrencyController = TextEditingController();
  TextEditingController destinationCurrencyController = TextEditingController();
  TextEditingController travelBudgetController = TextEditingController();
  TextEditingController foodBudgetController = TextEditingController();
  TextEditingController projBudgetController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  setSearchValue(val) => searchQuery.value = val;

  void addNewTrip(String adminId) async {
    tempTeamMember.forEach((ele) {
      teamMembers.add(ele.uid);
    });
    try {
      //Create new trip
      TripModel tripModel = TripModel(
        tripAdminId: adminId,
        tripName: tripnameController.text,
        destination: destinationController.text,
        origin: originController.text,
        homeCurrency: homeCurrency.value,
        destinationCurrency: destCurrency.value,
        conversionRate: currency.currentRate.value,
        travelBudget: travelBudget.value,
        foodBudget: foodBudget.value,
        projBudget: projectBudget.value,
        teamMembers: teamMembers,
      );

      // Add to DB

      var newtripId = await _db.collection("trip").add(tripModel.toJson());

      // Get Users Admin TripID List

      // print(auth.firestoreUser.value.adminTripId.length);
      var tempId = auth.firestoreUser.value.adminTripId;
      // print(newtripId.id);
      tempId.add(newtripId.id);

      await _db
          .collection("users")
          .doc(adminId)
          .update({"adminTripId": FieldValue.arrayUnion(tempId)});

      Get.snackbar(
          'Success', 'New Trip to ${tripModel.destination} has been created');
    } catch (err) {
      print(err);
      Get.snackbar("Unable to Create New Trip", err,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

// Serach Firestore for Users
  handleSearchUser(String query) {
    try {
      Future<QuerySnapshot> userResults = _db
          .collection("users")
          .where("searchKey", isEqualTo: query.substring(0, 1).toLowerCase())
          .get();

      searchUsers = userResults;
      update();
    } catch (err) {
      Get.snackbar("No Users", err);
    }
  }

  clearSearch() {
    searchController.clear();
    searchUsers = null;
    update();
  }

  // Add User To temp SearchList

  addTempTeamMember(UserModel user) {
    print(tempTeamMember.length);
    bool checkUser = false;
    tempTeamMember.forEach((doc) {
      if (doc.uid == user.uid) {
        checkUser = true;
      }
    });
    if (!checkUser) {
      tempTeamMember.add(user);
    } else {
      print("User already added");
      Get.snackbar("Team member already Added", "",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }

    clearSearch();
    Get.back();
  }

  removeTempUser(UserModel user) {
    int index;
    for (int i = 0; i < tempTeamMember.length; i++) {
      // print(tempTeamMember[i].uid);
      if (tempTeamMember[i].uid == user.uid) {
        index = i;
      }
    }
    tempTeamMember.removeAt(index);
    update();
  }
}
