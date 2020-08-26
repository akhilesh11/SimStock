import 'package:flutter/material.dart';
import 'Stocks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStocks extends StatelessWidget with ChangeNotifier {
  List<Stock> _liveStocks = [];

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void updateStocks() async {}
}
