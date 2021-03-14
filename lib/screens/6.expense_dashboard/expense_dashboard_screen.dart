import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/controllers/display_expense_controller.dart';
import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/model/trip_model.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/expense_components/bar_chart.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/expense_components/expense_panel.dart';
import 'package:fleming_expense_tracker/screens/7.chat_screen/chat_screen.dart';
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
  final AuthController authcontroller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    tripController.setcurrentTrip(trip);
    tripController.setcurrentTripId(tripId);
    print(authcontroller.firestoreUser.value.uid);
    print(tripController.currentTrip.value.tripAdminId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFFFF0044),
              size: 25.0,
            ),
            onPressed: () => Get.back()),
        actions: <Widget>[
          authcontroller.firestoreUser.value.uid ==
                  tripController.currentTrip.value.tripAdminId
              ? IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: Color(0xFFFF0044),
                    size: 25.0,
                  ),
                  onPressed: () => expenseController.getCsv(tripId),
                )
              : Text(""),
          IconButton(
              icon: Icon(
                Icons.chat,
                color: Color(0xFFFF0044),
                size: 25.0,
              ),
              onPressed: () => Get.to(ChatScreen()))
        ],
      ),
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
        ),
        BarChartExpense(
          tripId: tripId,
        ),
      ],
    );
  }
}
