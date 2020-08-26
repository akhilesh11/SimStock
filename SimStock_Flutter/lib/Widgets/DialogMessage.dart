import 'package:flutter/material.dart';

showmyDialog(context, {@required String title}) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Oops',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            title,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
              ),
            ),
          ],
        );
      });
}
