import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simstock/AddStock.dart';
import 'package:simstock/UserData/User.dart';
import 'package:simstock/constants.dart';
import 'package:simstock/homeScreen.dart';
import 'package:simstock/loginScreen.dart';
import 'package:simstock/registerScreen.dart';
import 'package:simstock/welcomeScreen.dart';
import 'API/Stocks.dart';
import 'Widgets/UserStocksPage.dart';

void main() {
  runApp(StockApp());
}

class StockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(
          create: (context) => User(),
        ),
        ChangeNotifierProvider<StockList>(
          create: (context) => StockList(),
        ),
      ],
      child: MaterialApp(
        title: 'SimStock',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: kleatherBrown,
          primaryColorDark: Colors.brown[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'OpenSans',
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AddStock.id: (context) => AddStock(),
          UserStocksPage.id: (context) => UserStocksPage(),
        },
      ),
    );
  }
}
