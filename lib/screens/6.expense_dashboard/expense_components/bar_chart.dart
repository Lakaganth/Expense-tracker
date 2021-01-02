import 'package:fl_chart/fl_chart.dart';
import 'package:fleming_expense_tracker/controllers/display_expense_controller.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class BarChartExpense extends StatefulWidget {
  const BarChartExpense({
    Key key,
    @required this.tripId,
  }) : super(key: key);

  final String tripId;

  @override
  _BarChartExpenseState createState() => _BarChartExpenseState();
}

class _BarChartExpenseState extends State<BarChartExpense> {
  final DisplayExpenseController expenseController =
      Get.put(DisplayExpenseController());

  final List<double> expenses = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  double maxExpense = 0.0;

  int touchedIndex;

  void segreggateExpenses(List<ExpenseModel> expensesList) {
    double acc = 0.0;
    double meals = 0.0;
    double gifts = 0.0;
    double hospitality = 0.0;
    double travel = 0.0;
    double mileage = 0.0;
    double personal = 0.0;

    expensesList.forEach((expense) {
      if (expense.expenseType == 'ExpenseType.business') {
        switch (expense.businessType) {
          case 'BusinessType.accomodation':
            acc = acc + expense.expenseAmount;
            return acc;
          case 'BusinessType.meals':
            meals = meals + expense.expenseAmount;
            return meals;
          case 'BusinessType.gifts':
            gifts = gifts + expense.expenseAmount;
            return gifts;
          case 'BusinessType.hospitality':
            hospitality = hospitality + expense.expenseAmount;
            return hospitality;
          case 'BusinessType.travel':
            travel = travel + expense.expenseAmount;
            return travel;
          case 'BusinessType.mileage':
            mileage = mileage + expense.expenseAmount;
            return mileage;
        }
      } else {
        return personal = personal + expense.expenseAmount;
      }
    });

    expenses[0] = meals;
    expenses[1] = acc;
    expenses[2] = gifts;
    expenses[3] = hospitality;
    expenses[4] = travel;
    expenses[5] = mileage;
    maxExpense = expenses.reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (expenseController != null && expenseController.expenses != null) {
        segreggateExpenses(expenseController.expenses);
        return Center(
          child: Container(
            height: 300,
            width: Get.width / 1.05,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.55),
                ),
              ],
            ),
            child: Center(
              child: BarChart(
                mainBarData(),
              ),
            ),
          ),
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      titlesData: _buildAxes(),
      borderData: FlBorderData(show: false),
      barGroups: _buildAllBars(),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String expense;
          switch (group.x.toInt()) {
            case 0:
              expense = 'Meals';
              break;
            case 1:
              expense = 'Accomodation';
              break;
            case 2:
              expense = 'Gifts';
              break;
            case 3:
              expense = 'Hospitality';
              break;
            case 4:
              expense = 'Travel';
              break;
            case 5:
              expense = 'Mileage';
              break;
          }
          return BarTooltipItem(
            expense + '\n' + (rod.y).toString(),
            TextStyle(color: Colors.yellow),
          );
        },
      ),
      touchCallback: (barTouchResponse) {
        setState(() {
          if (barTouchResponse.spot != null &&
              barTouchResponse.touchInput is! FlPanEnd &&
              barTouchResponse.touchInput is! FlLongPressEnd) {
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          } else {
            touchedIndex = -1;
          }
        });
      },
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) {
            return TextStyle(
                color: const Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 12);
          },
          margin: 20,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Meals';
              case 1:
                return 'Acc';
              case 2:
                return 'Gifts';
              case 3:
                return 'Hosp';
              case 4:
                return 'Travel';
              case 5:
                return 'Milage';

              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
            showTitles: false,
            getTitles: (double value) {
              return value.toString();
            }));
  }

  List<BarChartGroupData> _buildAllBars() {
    return List.generate(
      expenses.length,
      (index) =>
          _buildBar(index, expenses[index], isTouched: index == touchedIndex),
    );
  }

  BarChartGroupData _buildBar(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: selectColor(x, isTouched),
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxExpense > 0.0 ? maxExpense + 30 : 200,
            colors: bgColor(x),
          ),
        ),
      ],
    );
  }

  List<Color> selectColor(int x, bool isTouched) {
    switch (x) {
      case 0:
        return [!isTouched ? Color(0xFF4B92D3) : Colors.white];
      case 1:
        return [!isTouched ? Color(0xFF4BD371) : Colors.white];
      case 2:
        return [!isTouched ? Color(0xFFDCCC42) : Colors.white];
      case 3:
        return [!isTouched ? Color(0xFFFF7D1F) : Colors.white];
      case 4:
        return [!isTouched ? Color(0xFFC638EA) : Colors.white];
      case 5:
        return [!isTouched ? Color(0xFFFC3E3E) : Colors.white];
      default:
        return [!isTouched ? Colors.green : Colors.white];
    }
  }

  List<Color> bgColor(int x) {
    switch (x) {
      case 0:
        return [Color(0xFF244564)];
      case 1:
        return [Color(0xFF115A18)];
      case 2:
        return [Color(0xFF988B12)];
      case 3:
        return [Color(0xFF984A12)];
      case 4:
        return [Color(0xFF600D75)];
      case 5:
        return [Color(0xFF891F1F)];
      default:
        return [Colors.green];
    }
  }
}
