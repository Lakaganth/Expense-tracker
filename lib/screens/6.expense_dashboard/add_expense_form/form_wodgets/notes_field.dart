import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regexpattern/regexpattern.dart';

class NotesField extends StatelessWidget {
  const NotesField({
    Key key,
    @required this.expense,
  }) : super(key: key);

  final ExpenseController expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: TextField(
          controller: expense.notesController,
          minLines: 5,
          maxLines: 10,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter notes",
            hintStyle:
                GoogleFonts.roboto(color: Color(0xFFFD4228), fontSize: 30.0),
            // errorText: expense.notesController.text.isEmpty ? "Empty" : "",
          ),
          showCursor: true,
          cursorColor: Color(0xFFFD4228),
          style: GoogleFonts.roboto(color: Color(0xFFFD4228), fontSize: 20.0),
        ),
      ),
    );
  }
}
