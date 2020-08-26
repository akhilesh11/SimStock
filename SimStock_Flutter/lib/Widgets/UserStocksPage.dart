import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simstock/UserData/User.dart';
import 'UserStockTile.dart';

class UserStocksPage extends StatelessWidget {
  static const String id = 'UserStockPage';
  Stream<Event> firebaseData;

  UserStocksPage({this.firebaseData});

  List<String> keys = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseData, // Live Stream of Data from Firebase Database
        builder: (context, snap) {
          //List of all the stocks
          //Map of objects fetched from firebase
          Map _list = {};

          if (snap.hasData) {
            DataSnapshot snapshot = snap.data.snapshot;

            _list = snapshot.value;
            keys.clear();

            for (var key in _list.keys) {
              keys.add(key.toString());
            }
          }

          return snap.hasData
              ? CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: 100,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'My Stocks',
                          style: TextStyle(color: Colors.white),
                        ),
                        centerTitle: true,
                      ),
                    ),
                    SliverPadding(
                      padding:
                          EdgeInsets.symmetric(vertical: 75, horizontal: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (Provider.of<User>(context)
                                .stocks
                                .isNotEmpty) {
                              return UserStockTile(
                                stockCode: _list[
                                        Provider.of<User>(context)
                                            .stocks[index]
                                            .stockName]['StockID']
                                    .toString(),
                                high: double.parse(_list[
                                    Provider.of<User>(context)
                                        .stocks[index]
                                        .stockName]['High']),
                                low: double.parse(_list[
                                    Provider.of<User>(context)
                                        .stocks[index]
                                        .stockName]['Low']),
                                close: double.parse(_list[
                                    Provider.of<User>(context)
                                        .stocks[index]
                                        .stockName]['Value']),
                                title: _list[Provider.of<User>(context)
                                    .stocks[index]
                                    .stockName]['StockName'],
                                stockInfo: _list[
                                        Provider.of<User>(context)
                                            .stocks[index]
                                            .stockName]['StockInfo'] ??
                                    'NA',
                                stockInfoColor: _list[
                                    Provider.of<User>(context)
                                        .stocks[index]
                                        .stockName]['Color'],
                                onTap: () {
                                  Provider.of<User>(context, listen: false).removeStock(
                                      stockCode: _list[
                                          Provider.of<User>(context, listen: false)
                                              .stocks[index]
                                              .stockName]['StockID'],
                                      time: Provider.of<User>(context,
                                              listen: false)
                                          .stocks[index]
                                          .timeofPurchase,
                                      volumeBought:
                                          Provider.of<User>(context,listen: false)
                                              .stocks[index]
                                              .volumeBought,
                                      currentPrice: double.parse(
                                          _list[Provider.of<User>(context,listen: false).stocks[index].stockName]
                                              ['Value']),
                                      buyPrice: Provider.of<User>(context,listen: false)
                                      .stocks[index]
                                      .buyPrice);
                                },
                                buyPrice: Provider.of<User>(context)
                                    .stocks[index]
                                    .buyPrice,
                                quantity: Provider.of<User>(context)
                                    .stocks[index]
                                    .volumeBought,
                                timeofPurchase: Provider.of<User>(context,
                                        listen: false)
                                    .stocks[index]
                                    .timeofPurchase,
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(20)),
                                  width: double.infinity,
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      'No Matching Stocks Found :(',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          // Or, uncomment the following line:
                          childCount: Provider.of<User>(context)
                                  .stocks
                                  .isNotEmpty
                              ? Provider.of<User>(context).stocks.length
                              : 1,
                        ),
                      ),
                    )
                  ],
                )
              : Shimmer.fromColors(
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                          child: Text(
                        'Fetching Data',
                        textAlign: TextAlign.center,
                      )),
                    ),
                  )),
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey[400]);
        });
  }
}
