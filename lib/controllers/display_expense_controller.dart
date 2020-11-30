import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:get/get.dart';

class DisplayExpenseController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<List<ExpenseModel>> expensesList = Rx<List<ExpenseModel>>();

  List<ExpenseModel> get expenses => expensesList.value;

  // @override
  // void onInit() {
  //   String tripId = Get.find<TripController>().currentTripId.value;
  //   getTripExpenses(tripId);
  // }

  void getTripExpenses(tripId) {
    print("Hello");
    // String id = Get.find<TripController>().currentTripId.value;

    expensesList.bindStream(expenseStream(tripId));
  }

  Stream<List<ExpenseModel>> expenseStream(String tripId) {
    return _db
        .collection("trip")
        .doc(tripId)
        .collection("expense")
        .snapshots()
        .map((QuerySnapshot expense) {
      List<ExpenseModel> expenseFromJson = List();
      expense.docs.forEach((element) {
        expenseFromJson.add(ExpenseModel.fromMap(tripId, element));
      });
      return expenseFromJson;
    });
  }
}
