import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum ExpenseType { business, personel }
enum BusinessType { meals, accomodation, gifts, hospitality, travel, mileage }

class ExpenseModel {
  final DateTime date;
  final String name;
  final String expenseType;
  final String businessType;
  final double expenseAmount;
  final String mileageFrom;
  final String mileageTo;
  final double mileageDistance;
  final String notes;
  final String paymentMethod;
  final String tripId;
  final String expenseId;
  final String billUrl;

  ExpenseModel({
    @required this.tripId,
    @required this.date,
    @required this.name,
    @required this.expenseAmount,
    @required this.expenseType,
    this.businessType,
    this.mileageFrom,
    this.mileageTo,
    this.mileageDistance,
    @required this.notes,
    this.paymentMethod,
    this.expenseId,
    this.billUrl,
  });

  factory ExpenseModel.fromMap(String id, DocumentSnapshot json) =>
      ExpenseModel(
        date: DateTime.parse(json["date"].toDate().toString()),
        name: json["name"],
        expenseType: json["expenseType"],
        businessType: json["businessType"],
        expenseAmount: double.parse(json["expenseAmount"].toString()),
        mileageFrom: json["mileageFrom"],
        mileageTo: json["mileageTo"],
        // mileageDistance: double.parse(json["mileageDistance"].toString()),
        notes: json["notes"],
        paymentMethod: json["paymentMethod"],
        tripId: json["tripId"],
        expenseId: json["expenseId"],
        billUrl: json["billUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "expenseType": expenseType.toString(),
        "businessType": businessType.toString(),
        "expenseAmount": expenseAmount,
        "mileageFrom": mileageFrom != null ? mileageFrom : null,
        "mileageTo": mileageTo,
        "mileageDistance": mileageDistance,
        "notes": notes,
        "paymentMethod": paymentMethod,
        "tripId": tripId,
        "expenseId": expenseId,
        "billUrl": billUrl,
      };
}
