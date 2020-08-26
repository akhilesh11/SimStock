import 'dart:collection';

import 'package:flutter/cupertino.dart';

class StockList with ChangeNotifier{
  Map<String,Stock> _stocks = {
    'IN54' : Stock(title: 'Infosys',
        stockCode: 'IN54',
        close: 1800,
        high: 1850,
        low: 1800,
        open: 1820),
    'TC12' : Stock(title: 'TCS',
        stockCode : 'TC12',
        close: 140,
        high: 160,
        low: 120,
        open: 124),
  };

  Stock stockFromStockCode(String stockCode) => _stocks[stockCode];
}

class Stock with ChangeNotifier{
  final String title;
  final String stockCode;
  final double high;
  final double low;
  final double open;
  final double close;

  Stock({this.title,this.stockCode,this.open,this.close,this.low,this.high});

}