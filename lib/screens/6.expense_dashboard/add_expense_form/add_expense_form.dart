import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/form_wodgets/bill_uploads.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/form_wodgets/business_expense_selector.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/form_wodgets/date_selector.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/form_wodgets/expense_selector.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/form_wodgets/mileage_textfield.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/form_wodgets/notes_field.dart';
import 'package:fleming_expense_tracker/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({@required this.tripId});
  final String tripId;

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  ExpenseController expense = Get.put(ExpenseController());

  List<BusinessType> businessExpenses = [
    BusinessType.meals,
    BusinessType.accomodation,
    BusinessType.gifts,
    BusinessType.hospitality,
    BusinessType.travel,
    BusinessType.mileage
  ];

  @override
  Widget build(BuildContext context) {
    // print(widget.tripId);
    return Scaffold(
      backgroundColor: Color(0xFFFD4228),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Add Expense",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: 35.0,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                )
              ],
            ),
            NameField(expense: expense),
            SizedBox(
              height: 40.0,
            ),
            AmountField(expense: expense),
            DateSelector(expense: expense),
            ExpenseSelector(expense: expense),
            BusinessExpenseSelector(
                expense: expense, businessExpenses: businessExpenses),
            MileageTextField(expense: expense),
            NotesField(expense: expense),
            BillUpload(expense: expense),
            CustomRaisedButtton(
              onPressed: () => expense.submitExpense(widget.tripId),
              buttonText: "Submit",
              buttonColor: Colors.white,
              buttonTextColor: Color(0xFFFD4228),
            )
          ]),
        ),
      ),
    );
  }
}

class AmountField extends StatelessWidget {
  const AmountField({
    Key key,
    @required this.expense,
  }) : super(key: key);

  final ExpenseController expense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: expense.amountController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        filled: false,
        hintText: "Enter amount spent",
        hintStyle: GoogleFonts.roboto(
          fontSize: 16.0,
          color: Colors.white54,
        ),
        labelText: "Amount Spent",
        labelStyle: GoogleFonts.roboto(
          fontSize: 24.0,
          color: Colors.white,
        ),
      ),
      style: GoogleFonts.roboto(
        fontSize: 20.0,
        color: Colors.white,
      ),
    );
  }
}

class NameField extends StatelessWidget {
  const NameField({
    Key key,
    @required this.expense,
  }) : super(key: key);

  final ExpenseController expense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: expense.nameController,
      keyboardType: TextInputType.text,
      textAlign: TextAlign.start,
      onChanged: (value) => expense.setName(value),
      decoration: InputDecoration(
        filled: false,
        hintText: "Enter name of the expense",
        hintStyle: GoogleFonts.roboto(
          fontSize: 16.0,
          color: Colors.white54,
        ),
        labelText: "Name",
        labelStyle: GoogleFonts.roboto(
          fontSize: 24.0,
          color: Colors.white,
        ),
      ),
      style: GoogleFonts.roboto(
        fontSize: 20.0,
        color: Colors.white,
      ),
    );
  }
}
