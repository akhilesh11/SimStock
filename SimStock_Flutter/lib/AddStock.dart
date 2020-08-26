import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simstock/Widgets/customButton.dart';
import 'package:simstock/Widgets/topHeading.dart';
import 'package:simstock/constants.dart';
import 'package:simstock/homeScreen.dart';
import 'package:simstock/Widgets/DialogMessage.dart';

import 'API/DatabaseHelpers.dart';
import 'UserData/User.dart';

class AddStock extends StatefulWidget {
  static const String id = 'AddStock';
  String stockCode;
  String stockName;
  double currentPrice;
  AddStock({this.currentPrice, this.stockCode, this.stockName});

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  int quantity;

  double target;

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    widget.stockCode = args['StockCode'];
    widget.stockName = args['StockName'];
    widget.currentPrice = args['CurrentValue'];
    return Scaffold(
      backgroundColor: kbackgroundBlue,
      body: CustomPaint(
        painter: appBarBackground(),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'Add Stock',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 100, 20.0, 10),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        widget.stockCode,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      widget.stockName,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        widget.currentPrice.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '₹' +
                            (widget.currentPrice * (quantity ?? 0)).toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'QTY',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {});
                                quantity = int.parse(value);
                              },
                              decoration: InputDecoration(hintText: '000'),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'Target',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {});
                                target = double.parse(value);
                              },
                              decoration: InputDecoration(hintText: '000'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Target Hit Profit ₹' +
                            (((target ?? 0.0) * (quantity ?? 0)) -
                                    widget.currentPrice * (quantity ?? 0))
                                .toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    CustomButton(
                      onPressed: () {
                        if (target != null || quantity != null) {
                          if (Provider.of<User>(context, listen: false)
                                      .userAccountBalance -
                                  (widget.currentPrice * quantity) <
                              0) {
                            showmyDialog(context,
                                title:
                                    'Buying Price Exceeds Account Balance :${Provider.of<User>(context, listen: false).userAccountBalance}');
                          } else {
                            User().addStock(UserStock(
                                stockCode: widget.stockCode,
                                volumeBought: quantity,
                                buyPrice: widget.currentPrice,
                                stockName: widget.stockName,
                                target: target,
                                timeofPurchase: DateTime.now().toString()));
                            FirebaseDatabase.instance
                                .reference()
                                .child('/UserStocks')
                                .child('/${widget.stockCode}')
                                .set({
                              'StockID': widget.stockCode,
                              'StockName': widget.stockName,
                            });
                            Navigator.popAndPushNamed(context, HomeScreen.id);
                          }
                        } else {
                          showmyDialog(context, title: '');
                        }
                      },
                      title: 'BUY',
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
