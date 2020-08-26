import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simstock/API/DatabaseHelpers.dart';
import 'package:simstock/homeScreen.dart';
import 'package:simstock/registerScreen.dart';
import 'UserData/User.dart';
import 'Widgets/customButton.dart';
import 'Widgets/topHeading.dart';
import 'constants.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';
  final DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundBlue,
      body: CustomPaint(
        painter: appBarBackground(),
        size: Size.infinite,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              TopHeading(
                title: "SimStock",
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(
                width: 250.0,
                child: TypewriterAnimatedTextKit(
                    speed: Duration(milliseconds: 250),
                    totalRepeatCount: 1,
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "Welcome To SimStock",
                    ],
                    textStyle: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    alignment:
                        AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomButton(
                    title: 'Login',
                    onPressed: () async {
                      await Provider.of<User>(context, listen: false)
                          .updateUserData();
                      Navigator.pushNamed(context, HomeScreen.id);
                    },
                  ),
                  CustomButton(
                      title: 'Register',
                      onPressed: () async {
                        await Provider.of<User>(context, listen: false)
                            .updateUserData();
                        Navigator.pushNamed(context, RegisterScreen.id);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
