import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';

import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

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
    getCsv(tripId);
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

//Filepath

  String filePath;

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }

  getCsv(String tripId) async {
    List<List<dynamic>> rows = List<List<dynamic>>();

    QuerySnapshot expenseData = await _db
        .collection("trip")
        .doc(tripId)
        .collection("expense")
        .orderBy("date")
        .get();

    rows.add(["Date", "Expense", "Amount", "Type", "Business Type", "Notes"]);
    if (!expenseData.isNull) {
      List<dynamic> row = List<dynamic>();
      expenseData.docs.forEach((data) => {
            row.add(DateTime.parse(data["date"].toDate().toString())),
            row.add(data["name"]),
            row.add(data["expenseAmount"]),
            row.add(data["expenseType"]),
            row.add(data["businessType"]),
            row.add(data["notes"]),
          });
      rows.add(row);
    }

    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    print(f);
    // filePath = f.uri.path;
  }
}
