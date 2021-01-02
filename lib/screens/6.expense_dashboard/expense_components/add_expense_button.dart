import 'package:fleming_expense_tracker/controllers/display_expense_controller.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/add_expense_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({
    Key key,
    @required this.tripId,
  }) : super(key: key);

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          color: Color(0xFFFD4228),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Get.to(AddExpenseForm(tripId: tripId)),
          color: Colors.white,
          iconSize: 55.0,
        ),
      ),
    );
  }
}
