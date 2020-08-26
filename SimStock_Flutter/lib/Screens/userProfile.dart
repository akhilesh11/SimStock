import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simstock/UserData/User.dart';
import 'package:simstock/constants.dart';
import 'package:simstock/welcomeScreen.dart';

class UserProfile extends StatelessWidget {
  String dropdownvalue;
  double recurringAmount = 0.0;
  UserProfile({this.dropdownvalue, this.recurringAmount});
  double userBalance = 0;

  double userProfit = 0;

  showmyDialog(context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Are you sure?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'You will loose all your data if you logout.',
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
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Provider.of<User>(context, listen: false).logoutUser();
                  Navigator.popAndPushNamed(context, WelcomeScreen.id);
                },
                child: Text('Logout'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/person.png'),
                    radius: 50,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    Provider.of<User>(context).userName ?? 'User',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Account Balance',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    Provider.of<User>(context)
                        .userAccountBalance
                        .toStringAsFixed(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Add every :',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: DropdownButton<String>(
                      value: dropdownvalue ?? '1 month',
                      onChanged: (value) {
                        dropdownvalue = value;
                        Provider.of<User>(context, listen: false)
                            .updateRecurrTime(recurTime: dropdownvalue);
                      },
                      dropdownColor: kleatherBrown,
                      items: <String>['1 month', '14 days']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList()),
                ),
                ListTile(
                  title: Text(
                    'Amount to add :',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value != null)
                          recurringAmount = double.parse(value);
                      },
                      onSubmitted: (value) {
                        recurringAmount = double.parse(value);
                        Provider.of<User>(context, listen: false)
                            .updateRecurrData(recuAmt: double.parse(value));
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        hintText: Provider.of<User>(context, listen: false)
                            .userRecurAmount
                            .toString(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Provider.of<User>(context, listen: false)
                            .updateAccountBalance(amount: recurringAmount);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kleatherBrown.withOpacity(0.75),
                        ),
                        child: Center(
                          child: Text(
                            'Add ₹${recurringAmount} \nto account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kleatherBrown.withOpacity(0.75),
                      ),
                      child: Center(
                        child: Text(
                          'Overall Profit\n${Provider.of<User>(context).userProfit >= 0 ? '+' : '-'}${Provider.of<User>(context).userProfit}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      showmyDialog(context);
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    ]);
  }
}
