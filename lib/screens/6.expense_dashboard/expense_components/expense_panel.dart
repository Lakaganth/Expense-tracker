import 'dart:math';

import 'package:fleming_expense_tracker/controllers/display_expense_controller.dart';
import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:fleming_expense_tracker/model/trip_model.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/expense_components/add_expense_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensePanel extends StatefulWidget {
  const ExpensePanel({
    Key key,
    @required this.tripId,
    @required this.trip,
  }) : super(key: key);

  final String tripId;
  final TripModel trip;

  @override
  _ExpensePanelState createState() => _ExpensePanelState();
}

class _ExpensePanelState extends State<ExpensePanel> {
  final DisplayExpenseController expenseController =
      Get.put(DisplayExpenseController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expenseController.getTripExpenses(widget.tripId);
  }

  double totalExpenses;

  void getTotalSpending(List<ExpenseModel> expenses) {
    totalExpenses = 0.0;

    expenses.forEach((exp) {
      totalExpenses = exp.expenseAmount + totalExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        color: Color(0xFF070811),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Image.asset('assets/images/panel_slider.png'),
              SizedBox(
                height: 10.0,
              ),
              AddExpenseButton(
                tripId: widget.tripId,
                totalExpenseAmount: expenseController.totalTripAmount.value,
                homeCurrency: widget.trip.homeCurrency,
                destCurrency: widget.trip.destinationCurrency,
                rate: widget.trip.conversionRate,
              ),
              Obx(
                () {
                  if (expenseController != null &&
                      expenseController.expenses != null) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: expenseController.expenses.length,
                            itemBuilder: (_, index) {
                              getTotalSpending(expenseController.expenses);
                              return ExpenseRow(
                                expenseController: expenseController,
                                expense: expenseController.expenses[index],
                                trip: widget.trip,
                              );
                            }));
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          )),
    );
  }
}

class ExpenseRow extends StatefulWidget {
  const ExpenseRow({
    Key key,
    @required this.expenseController,
    @required this.expense,
    @required this.trip,
  }) : super(key: key);

  final DisplayExpenseController expenseController;
  final ExpenseModel expense;
  final TripModel trip;

  @override
  _ExpenseRowState createState() => _ExpenseRowState();
}

class _ExpenseRowState extends State<ExpenseRow> {
  String imagepath;
  String expenseType;

  DisplayExpenseController get expenseController => widget.expenseController;
  ExpenseModel get expense => widget.expense;
  TripModel get trip => widget.trip;

  selectExpensetype() {
    if (expense.expenseType == "ExpenseType.business") {
      switch (expense.businessType) {
        case "BusinessType.meals":
          return expenseType = "Meals";
        case "BusinessType.accomodation":
          return imagepath = "Accomodation";
        case "BusinessType.gifts":
          return imagepath = "Gifts";
        case "BusinessType.hospitality":
          return imagepath = "Hospitality";
        case "BusinessType.travel":
          return imagepath = "Travel";
        case "BusinessType.mileage":
          return imagepath = "Mileage";
      }
    } else {
      return imagepath = "Personal";
    }
  }

  selectExpenseImage() {
    if (expense.expenseType == "ExpenseType.business") {
      switch (expense.businessType) {
        case "BusinessType.meals":
          return imagepath = "assets/images/meals.png";
        case "BusinessType.accomodation":
          return imagepath = "assets/images/meals.png";
        case "BusinessType.gifts":
          return imagepath = "assets/images/gifts.png";
        case "BusinessType.hospitality":
          return imagepath = "assets/images/hospitality.png";
        case "BusinessType.travel":
          return imagepath = "assets/images/travel.png";
        case "BusinessType.mileage":
          return imagepath = "assets/images/mileage.png";
      }
    } else {
      return imagepath = "assets/images/personal.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(expense.date.toString(),
              style: GoogleFonts.roboto(
                color: Color(0XFfEEE6EE),
                fontSize: 18.0,
                fontWeight: FontWeight.w100,
              )),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 70.0,
                width: 70.0,
                decoration: BoxDecoration(
                  color: Color(0XFFEEE6EE),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(
                  selectExpenseImage(),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  expense.name.capitalizeFirst,
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    color: Color(0XFFEEE6EE),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  selectExpensetype(),
                  style: GoogleFonts.roboto(
                    fontSize: 16.0,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w300,
                  ),
                )
              ]),
              Column(
                children: <Widget>[
                  Text(
                    "-\$${expense.expenseAmount.toString()} ${trip.destinationCurrency}",
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "-\$${((expense.expenseAmount / trip.conversionRate).floor()).toString()} ${widget.trip.homeCurrency}",
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
