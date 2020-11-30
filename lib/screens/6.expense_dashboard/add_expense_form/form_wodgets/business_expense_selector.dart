import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessExpenseSelector extends StatelessWidget {
  const BusinessExpenseSelector({
    Key key,
    @required this.expense,
    @required this.businessExpenses,
  }) : super(key: key);

  final ExpenseController expense;
  final List<BusinessType> businessExpenses;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return expense.isBusinessExpense.value
          ? LimitedBox(
              maxHeight: 480.0,
              child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 0.80,
                  shrinkWrap: true,
                  primary: false,
                  children: List.generate(businessExpenses.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        print(
                            businessExpenses[index].toString().split('.').last);
                        expense.setBusinessType(businessExpenses[index]);
                      },
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40.0,
                            backgroundColor:
                                expense.businessExpenseType.value.toString() ==
                                        businessExpenses[index].toString()
                                    ? Colors.greenAccent
                                    : Colors.white,
                            child: Image.asset(
                                "assets/images/${businessExpenses[index].toString().split('.').last}.png"),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            businessExpenses[index]
                                .toString()
                                .split('.')
                                .last
                                .capitalize,
                            style: GoogleFonts.roboto(
                                fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    );
                  })),
            )
          : Text("Hello");
    });
  }
}
