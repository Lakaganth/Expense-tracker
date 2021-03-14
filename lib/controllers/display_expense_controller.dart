import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';

import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class DisplayExpenseController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<List<ExpenseModel>> expensesList = Rx<List<ExpenseModel>>();
  RxDouble totalTripAmount = 0.0.obs;
  String filePath = "";

  List<ExpenseModel> get expenses => expensesList.value;

  @override
  void onClose() {
    totalTripAmount.value = 0.0;
  }

  void getTripExpenses(tripId) async {
    expensesList.bindStream(expenseStream(tripId));
    // getCsv(tripId);
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

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/expenses.csv';
    return File('$path/expenses.csv').create();
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body: 'PFA the csv for the requested Trip',
      subject: 'Expenses CSV ${DateTime.now().toString()}',
      recipients: [],
      isHTML: true,
      attachmentPaths: [filePath],
    );
    // print(email);
    await FlutterEmailSender.send(email);
  }

  getCsv(String tripId) async {
    List<List<dynamic>> rows = List<List<dynamic>>();

    QuerySnapshot expenseData = await _db
        .collection("trip")
        .doc(tripId)
        .collection("expense")
        .orderBy("date")
        .get();

    rows.add([
      "Date",
      "Expense",
      "Amount",
      "Type",
      "Business Type",
      "Notes",
      "Bill URL"
    ]);
    if (!expenseData.isNull) {
      for (int i = 0; i < expenseData.docs.length; i++) {
        List<dynamic> row = List<dynamic>();
        row.add(
            DateTime.parse(expenseData.docs[i]["date"].toDate().toString()));
        row.add(expenseData.docs[i]["name"]);
        row.add(expenseData.docs[i]["expenseAmount"]);
        row.add(expenseData.docs[i]["expenseType"]);
        row.add(expenseData.docs[i]["businessType"]);
        row.add(expenseData.docs[i]["notes"]);
        row.add(expenseData.docs[i]["billUrl"]);
        rows.add(row);
      }
    }

    print(rows);
    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    sendMailAndAttachment();
    // print(f);
    // filePath = f.uri.path;
  }
}
