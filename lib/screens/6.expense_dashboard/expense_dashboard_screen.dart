import 'package:fleming_expense_tracker/controllers/display_expense_controller.dart';
import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/model/trip_model.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/add_expense_form/add_expense_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ExpenseDashboardScreen extends StatelessWidget {
  final TripModel trip;
  final String tripId;

  ExpenseDashboardScreen({@required this.tripId, @required this.trip});

  final TripController tripController = Get.put(TripController());
  final DisplayExpenseController expenseController =
      Get.put(DisplayExpenseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SlidingUpPanel(
          maxHeight: Get.height * .80,
          minHeight: 195.0,
          parallaxEnabled: true,
          parallaxOffset: .5,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
          body: ExpenseBody(
            tripId: tripId,
            trip: trip,
          ),
          panel: ExpensePanel(
            tripId: tripId,
            trip: trip,
          ),
        ),
      ),
    );
  }
}

class ExpenseBody extends StatelessWidget {
  const ExpenseBody({
    Key key,
    @required this.tripId,
    @required this.trip,
  }) : super(key: key);

  final String tripId;
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Container(
            width: Get.width / 1.25,
            decoration: BoxDecoration(
                color: Color(0xFFFF0044),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75),
                  ),
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    trip.tripName,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "Destination Currency: ${trip.destinationCurrency}",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Current Rate: ${trip.conversionRate}",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            AddExpenseButton(tripId: widget.tripId),
            Obx(
              () {
                // displayExpense.getTripExpenses(tripId);
                if (expenseController != null &&
                    expenseController.expenses != null) {
                  print(expenseController.expenses.length);
                  return Expanded(
                      child: ListView.builder(
                          itemCount: expenseController.expenses.length,
                          itemBuilder: (_, index) {
                            return Text(expenseController
                                .expenses[index].expenseType
                                .toString());
                          }));
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ));
  }
}

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({
    Key key,
    @required this.tripId,
  }) : super(key: key);

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(""),
        Padding(
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
        )
      ],
    );
  }
}
