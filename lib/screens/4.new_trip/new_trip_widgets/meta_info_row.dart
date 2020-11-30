import 'package:fleming_expense_tracker/controllers/newtrip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MetaInfoRow extends StatelessWidget {
  final NewtripController trip;
  MetaInfoRow({@required this.trip});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        BuildNewTripRow(
          label: "Name",
          labelColor: Color(0xFFD6E28A),
          controller: trip.tripnameController,
          hintText: "Enter name for the trip",
        ),
        SizedBox(
          height: 30.0,
        ),
        BuildNewTripRow(
          label: "Destination",
          labelColor: Color(0xFFD6E28A),
          controller: trip.destinationController,
          hintText: "eg: New York",
        ),
        SizedBox(
          height: 30.0,
        ),
        BuildNewTripRow(
          label: "Origin",
          labelColor: Color(0xFFD6E28A),
          controller: trip.originController,
          hintText: "eg: Toronto",
        ),
      ],
    );
  }
}

class BuildNewTripRow extends StatelessWidget {
  const BuildNewTripRow({
    @required this.label,
    @required this.labelColor,
    @required this.controller,
    @required this.hintText,
  });

  final String label;
  final Color labelColor;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 20.0,
            color: labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: Get.width / 2.0,
          child: TextField(
            controller: controller,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 20.0,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan),
              ),
              filled: true,
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            autocorrect: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
        )
      ],
    );
  }
}
