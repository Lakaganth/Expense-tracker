import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BillUpload extends StatelessWidget {
  const BillUpload({
    Key key,
    @required this.expense,
  }) : super(key: key);

  final ExpenseController expense;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Text(
          "Upload bills",
          style: GoogleFonts.roboto(
            fontSize: 36.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: expense.handleTakePhoto,
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.white,
                child: Image.asset("assets/images/camera.png"),
              ),
            ),
            GestureDetector(
              onTap: expense.handleGalleryPhoto,
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.white,
                child: Image.asset("assets/images/gallery.png"),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Obx(() {
          return expense.imageDownloadUrl.value != ""
              ? Text("Image Uploaded Successfully!",
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    color: Colors.white,
                  ))
              : Text("");
        })
      ],
    );
  }
}
