import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simstock/API/Stocks.dart';
import 'package:simstock/UserData/User.dart';

class StockTile extends StatelessWidget {
  String title;
  String stockCode;
  double high;
  double low;
  double open;
  double close;
  String stockInfo;
  String stockInfoColor;
  String lastUpdated;
  Function onTap;

  StockTile(
      {this.title,
      this.stockCode,
      this.high,
      this.low,
      this.close,
      this.open,
      this.stockInfo,
      this.stockInfoColor,
      this.lastUpdated,
      this.onTap});

  StockTile.usingStock(UserStockData userStock) {
    Stock stock = StockList().stockFromStockCode(userStock.stockCode);
    this.title = stock.title ?? 'NA';
    this.stockCode = userStock.stockCode ?? 'NA';
    this.high = stock.high ?? 0.0;
    this.low = stock.low ?? 0.0;
    this.open = stock.open ?? 0.0;
    this.close = stock.close ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                color: Colors.white.withOpacity(0.1),
                icon: Icons.add,
                caption: 'Add',
                onTap: onTap,
              ),
            ],
            child: ExpandablePanel(
              hasIcon: true,
              expanded: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Column(
                    children: <Widget>[
                      Text(
                        'LOW',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(low.toStringAsFixed(2) ?? 'NA'),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('HIGH',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )),
                      Text(high.toStringAsFixed(2) ?? 'NA'),
                    ],
                  ),
                  subtitle: Text(lastUpdated ?? 'No Time Available Yet'),
                ),
              ),
              header: ListTile(
                trailing: Column(
                  children: <Widget>[
                    Text(
                      '${close.toStringAsFixed(2) ?? 'NA'} INR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      stockInfo ?? 'NA',
                      style: TextStyle(
                          color: stockInfo != 'NA'
                              ? stockInfoColor == 'Red'
                                  ? Colors.red
                                  : Colors.green
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
                title: Text(
                  title ?? 'NA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  stockCode ?? 'NA',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
      ),
    );
  }
}
