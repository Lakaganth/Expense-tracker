import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/model/trip_model.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/user_trips.dart';
import 'package:fleming_expense_tracker/screens/6.expense_dashboard/expense_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTrips extends StatelessWidget {
  const AdminTrips({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<TripController>(
      init: Get.put(TripController()),
      builder: (TripController tripController) {
        if (tripController != null && tripController.trips != null) {
          return ListView.builder(
            itemCount: tripController.adminTrips.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                  onTap: () {
                    Get.to(ExpenseDashboardScreen(
                        tripId: tripController.adminTrips[index].tripId,
                        trip: tripController.adminTrips[index]));
                  },
                  child: TripCard(trip: tripController.adminTrips[index]));
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class TripCard extends StatelessWidget {
  const TripCard({Key key, @required this.trip}) : super(key: key);

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.deepPurple,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15.0,
            offset: Offset(0.0, 0.75),
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                trip.tripName.capitalize,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    trip.origin.capitalize,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 26.0,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Image.asset('assets/images/right-arrom.png'),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    trip.destination.capitalize,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 26.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Current Spending : ",
                    style:
                        GoogleFonts.roboto(fontSize: 16.0, color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Rate: ",
                    style:
                        GoogleFonts.roboto(fontSize: 16.0, color: Colors.white),
                  ),
                  Text(
                    trip.conversionRate.toString().capitalize,
                    style: GoogleFonts.roboto(
                      color: Color(0xffFD4228),
                      fontSize: 26.0,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
