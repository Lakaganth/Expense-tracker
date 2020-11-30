import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseSelector extends StatelessWidget {
  const ExpenseSelector({
    Key key,
    @required this.expense,
  }) : super(key: key);

  final ExpenseController expense;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          Text(
            "Expense Type",
            style: GoogleFonts.roboto(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  print("Business");
                  expense.setBusinessExpenseType();
                },
                child: Container(
                  height: 50.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: expense.isBusinessExpense.value
                        ? Colors.white
                        : Colors.grey[350],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Business",
                      style: GoogleFonts.roboto(
                          color: Color(0xFFFD4228), fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print("Personal");
                  expense.setPersonalExpenseType();
                },
                child: Container(
                  height: 50.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: !expense.isBusinessExpense.value
                        ? Colors.white
                        : Colors.grey[350],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Personal",
                      style: GoogleFonts.roboto(
                          color: Color(0xFFFD4228), fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      );
    });
  }
}
