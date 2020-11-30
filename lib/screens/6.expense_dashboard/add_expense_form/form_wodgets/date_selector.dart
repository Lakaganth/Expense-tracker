import 'package:calendar_strip/calendar_strip.dart';
import 'package:fleming_expense_tracker/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateSelector extends StatelessWidget {
  DateSelector({@required this.expense});

  final ExpenseController expense;

  final DateTime startDate = DateTime.now().subtract(Duration(days: 30));

  final DateTime endDate = DateTime.now().add(Duration(days: 30));

  final DateTime selectedDate = DateTime.now().subtract(Duration(days: 0));

  onSelect(data) {
    expense.setDate(data);
    print("Selected Date -> ${expense.date}");
  }

  onWeekSelect(data) {
    print("Selected week starting at -> $data");
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white);
    TextStyle dayNameStyle = TextStyle(
        fontSize: 14.5, color: !isSelectedDate ? fontColor : Colors.white);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Color(0xFFFD4228),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Text(
          "Date",
          style: GoogleFonts.roboto(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75),
              ),
            ],
          ),
          child: CalendarStrip(
            startDate: startDate,
            endDate: endDate,
            selectedDate: selectedDate,
            onDateSelected: onSelect,
            onWeekSelected: onWeekSelect,
            dateTileBuilder: dateTileBuilder,
            iconColor: Colors.black87,
            monthNameWidget: _monthNameWidget,
            containerDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            addSwipeGesture: true,
          ),
        )
      ],
    );
  }
}
