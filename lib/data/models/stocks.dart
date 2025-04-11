import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  final String itemname;
  final String brandname;
  final String suppliername;
  final double quantity;
  final double rate;
  final Timestamp? lastUpdated; // Add this field
  final String unit;

  StockModel({
    required this.itemname,
    required this.brandname,
    required this.suppliername,
    required this.quantity,
    required this.rate,
    required this.unit,
    this.lastUpdated
  });
}
