import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simstock/API/DatabaseHelpers.dart';

List<UserStock> _userStocks = [];
Map<String, dynamic> _userPersonalData = {};

class User with ChangeNotifier {
  User() {
    updateList();
  }

  updateList() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    _userStocks.clear();
    _userStocks = await helper.queryStocks();
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  updateUserName(String userName) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateUserName(userName);
    notifyListeners();
  }

  void removeStock(
      {String stockCode,
      String time,
      double currentPrice,
      int volumeBought,
      double buyPrice}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.remove(stockCode, time);
    _userStocks.clear();
    _userStocks = await helper.queryStocks();
    await helper.addUserMoney(
        amount: (currentPrice * volumeBought),
        profit: ((volumeBought * buyPrice) - (volumeBought * currentPrice)));
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  void addStock(UserStock userStock) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.insert(userStock);
    _userStocks.clear();
    _userStocks = await helper.queryStocks();
    await helper.updateUserDataAfterStockPurchase(
      spent: (userStock.volumeBought * userStock.buyPrice),
    );
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  updateAccountBalance({double amount}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.addUserMoney(amount: amount);
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  updateRecurrData({double recuAmt}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateUserData(recAmt: recuAmt);
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  updateRecurrTime({String recurTime}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateRecurrTime(recurDur: recurTime);
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  logoutUser() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.logoutUser();
    _userPersonalData = await helper.queryUserData() ?? {};
    notifyListeners();
  }

  updateUserData() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.insertUserData(UserData(
      accountBalance: 10000,
      recurringAmount: 5000,
      recurringTime: '1 month',
      profit: 0,
      userName: userName ?? 'User',
    ));
    _userPersonalData = await helper.queryUserData();
    notifyListeners();
  }

  UnmodifiableListView<UserStock> get stocks =>
      UnmodifiableListView(_userStocks);

  get userAccountBalance => _userPersonalData[columnAccountBalance] ?? 0;
  get userProfit => _userPersonalData[columnProfit] ?? 0;
  get userRecurTime => _userPersonalData[columnRecurringTime] ?? '1 month';
  double get userRecurAmount =>
      _userPersonalData[columnRecurringAmount] ?? 5000.0;

  int get length => _userStocks.length;

  String get userName {
    if (_userPersonalData != null)
      return _userPersonalData[columnUserName];
    else
      return 'User';
  }
}

class UserStockData {
  final String stockCode;
  final double buyPrice;
  final int volumeBought;
  final String stockName;
  final DateTime timeofPurchase;

  UserStockData(
      {this.buyPrice,
      this.volumeBought,
      this.stockCode,
      this.stockName,
      this.timeofPurchase});
}
