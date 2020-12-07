import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:get/get.dart';

class DisplayExpenseController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<List<ExpenseModel>> expensesList = Rx<List<ExpenseModel>>();
  RxDouble totalTripAmount = 0.0.obs;

  List<ExpenseModel> get expenses => expensesList.value;

  @override
  void onClose() {
    totalTripAmount.value = 0.0;
  }

  void getTripExpenses(tripId) async {
    expensesList.bindStream(expenseStream(tripId));

    // getAllExpenses();
    print(totalTripAmount.value);
  }

  void getAllExpenses() {
    if (expensesList != null) {
      expenses.forEach((expense) {
        totalTripAmount.value = totalTripAmount.value + expense.expenseAmount;
      });
    } else {
      print(totalTripAmount.value);
      return null;
    }
  }

  Stream<List<ExpenseModel>> expenseStream(String tripId) {
    return _db
        .collection("trip")
        .doc(tripId)
        .collection("expense")
        .orderBy("date", descending: true)
        .snapshots()
        .map((QuerySnapshot expense) {
      List<ExpenseModel> expenseFromJson = List();
      expense.docs.forEach((element) {
        expenseFromJson.add(ExpenseModel.fromMap(tripId, element));
      });

      expenseFromJson.forEach((exp) {
        totalTripAmount.value = totalTripAmount.value + exp.expenseAmount;
      });
      return expenseFromJson;
    });
  }
}
