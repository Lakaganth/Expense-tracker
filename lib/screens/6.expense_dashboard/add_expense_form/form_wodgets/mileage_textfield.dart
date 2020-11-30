import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MileageTextField extends StatelessWidget {
  const MileageTextField({
    Key key,
    @required this.expense,
  }) : super(key: key);

  final ExpenseController expense;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return expense.businessExpenseType.value == BusinessType.mileage
          ? Column(
              children: <Widget>[
                TextField(
                  controller: expense.mileageFromController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: "From",
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white54,
                    ),
                    labelText: "From",
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  controller: expense.mileageToController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.start,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: "To",
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white54,
                    ),
                    labelText: "To",
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  controller: expense.mileagedistanceController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: "Travelled Distance",
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Colors.white54,
                    ),
                    labelText: "Distance",
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            )
          : Text("");
    });
  }
}
