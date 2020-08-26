import 'package:flutter/material.dart';
import 'package:simstock/Widgets/DialogMessage.dart';
import 'package:simstock/Widgets/customButton.dart';
import 'package:simstock/homeScreen.dart';

import 'UserData/User.dart';
import 'Widgets/topHeading.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'LoginScreen';
  String userName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: appBarBackground(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TopHeading(
                title: 'Register',
              ),
              SizedBox(
                height: 200,
              ),
              TextField(
                onChanged: (value) {
                  userName = value;
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter User Name',
                ),
              ),
              SizedBox(
                height: 200,
              ),
              CustomButton(
                onPressed: () {
                  if (userName != '' || userName != null) {
                    User().updateUserName(userName);
                    Navigator.popAndPushNamed(context, HomeScreen.id);
                  } else {
                    showmyDialog(context, title: 'Please enter a UserName');
                  }
                },
                title: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
