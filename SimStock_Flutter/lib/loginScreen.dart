import 'package:flutter/material.dart';
import 'Widgets/topHeading.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'LoginScreen';
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: appBarBackground(),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            TopHeading(
              title: 'Stocks',
            )
          ],
        ),
      ),
    );
  }
}
