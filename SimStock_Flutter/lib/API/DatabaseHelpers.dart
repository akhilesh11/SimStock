import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//database table and columnNames for the StockDataCache
final String tableLiveStocks = 'stocks';
final String columnLiveStockCode = 'stockcode';
final String columnLiveStockNames = 'stockname';
final String columnLiveHigh = 'high';
final String columnLiveLow = 'low';
final String columnLiveLastUpdated = 'lastUpdated';

// database table and column names for userData
final String tableUserData = 'user';
final String columnUserName = 'userName';
final String columnAccountBalance = 'AccountBalance';
final String columnProfit = 'Profit';
final String columnRecurringAmount = 'RecurringAmount';
final String columnRecurringTime = 'RecurringTime';

// database table and column names
final String tableStocks = 'stocks';
final String columnStockCode = 'stockcode';
final String columnStockNames = 'stockname';
final String columnVolume = 'volume';
final String columnTimeofPurchase = 'timeofpurchase';
final String columnBuyPrice = 'buyprice';
final String columnTarget = 'target';

class UserData {
  String recurringTime;
  double accountBalance;
  double profit;
  double recurringAmount;
  String userName;

  UserData({
    this.recurringAmount,
    this.accountBalance,
    this.profit,
    this.recurringTime,
    this.userName,
  });

  UserData.fromMap(Map<String, dynamic> map) {
    recurringTime = map[columnRecurringTime];
    recurringAmount = map[columnRecurringAmount];
    profit = map[columnProfit];
    accountBalance = map[accountBalance];
    userName = map[columnUserName];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnProfit: profit,
      columnRecurringAmount: recurringAmount,
      columnRecurringTime: recurringTime,
      columnAccountBalance: accountBalance,
      columnUserName: userName,
    };
    return map;
  }
}

// data model class
class UserStock {
  String stockCode;
  double buyPrice;
  int volumeBought;
  String stockName;
  String timeofPurchase;
  double target;

  UserStock(
      {this.stockCode,
      this.stockName,
      this.timeofPurchase,
      this.buyPrice,
      this.volumeBought,
      this.target});

  // convenience constructor to create a Word object
  UserStock.fromMap(Map<String, dynamic> map) {
    stockCode = map[columnStockCode];
    stockName = map[columnStockNames];
    timeofPurchase = map[columnTimeofPurchase];
    buyPrice = map[columnBuyPrice];
    volumeBought = map[columnVolume];
    target = map[columnTarget];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnVolume: volumeBought,
      columnBuyPrice: buyPrice,
      columnTimeofPurchase: timeofPurchase,
      columnStockNames: stockName,
      columnTarget: target,
    };
    if (stockCode != null) {
      map[columnStockCode] = stockCode;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "UserStocks.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableStocks (
                $columnStockCode TEXT NOT NULL,
                $columnBuyPrice REAL NOT NULL,
                $columnVolume INTEGER NOT NULL,
                $columnTimeofPurchase TEXT PRIMARY KEY,
                $columnStockNames TEXT NOT NULL,
                $columnTarget REAL NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableUserData (
                $columnUserName TEXT NOT NULL,
                $columnAccountBalance REAL NOT NULL,
                $columnRecurringTime TEXT NOT NULL,
                $columnRecurringAmount REAL NOT NULL,
                $columnProfit REAL NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE IF NOT EXISTS $tableStocks (
                $columnStockCode TEXT NOT NULL,
                $columnBuyPrice REAL NOT NULL,
                $columnVolume INTEGER NOT NULL,
                $columnTimeofPurchase TEXT PRIMARY KEY,
                $columnStockNames TEXT NOT NULL,
                $columnTarget REAL NOT NULL
              )
              ''');
  }

  Future<void> logoutUser() async {
    Database db = await database;
    await db.execute('Delete from $tableUserData ');
    await db.execute('Delete from $tableStocks ');
  }

  Future<String> userName() async {
    Database db = await database;
    List<Map> maps = await db.query(tableUserData, columns: [columnUserName]);
    if (maps.isNotEmpty) return maps[0][columnUserName];

    return 'User';
  }

  Future<void> updateUserName(String userName) async {
    Database db = await database;
    await db.execute('Update $tableUserData set $columnUserName = "$userName"');
  }

  Future<int> insertUserData(UserData data) async {
    Database db = await database;
    int id = await db.insert(tableUserData, data.toMap());
    return id;
  }

  Future<void> addUserMoney({double amount, double profit = 0.0}) async {
    Database db = await database;
    await db.execute(
        'Update $tableUserData set $columnAccountBalance = $columnAccountBalance + $amount , $columnProfit = $columnProfit + $profit');
  }

  Future<void> updateUserDataAfterStockPurchase({double spent}) async {
    Database db = await database;
    await db.execute(
        'Update $tableUserData set $columnAccountBalance = $columnAccountBalance - $spent');
  }

  Future<void> updateUserData({double recAmt}) async {
    Database db = await database;
    await db
        .execute("Update $tableUserData set $columnRecurringAmount = $recAmt");
  }

  Future<void> updateRecurrTime({String recurDur = '14 days'}) async {
    Database db = await database;
    await db.execute(
        "Update $tableUserData set $columnRecurringTime = '$recurDur'");
  }

  Future<int> remove(String stockCode, String time) async {
    Database db = await database;
    int id = await db.delete(tableStocks,
        where:
            "$columnStockCode='$stockCode' and $columnTimeofPurchase = '$time'");
    return id;
  }

  // Database helper methods:

  Future<int> insert(UserStock stock) async {
    Database db = await database;
    int id = await db.insert(tableStocks, stock.toMap());
    return id;
  }

  Future<List<UserStock>> queryStocks() async {
    Database db = await database;
    List<Map> maps = await db.query(tableStocks, columns: [
      columnStockNames,
      columnTimeofPurchase,
      columnBuyPrice,
      columnStockCode,
      columnVolume,
      columnTarget,
    ]);
    List<UserStock> userStocks = [];
    for (Map map in maps) {
      userStocks.add(UserStock.fromMap(map));
    }
    return userStocks;
  }

  Future<Map<String, dynamic>> queryUserData() async {
    Database db = await database;
    List<Map> maps = await db.query(tableUserData, columns: [
      columnRecurringAmount,
      columnAccountBalance,
      columnProfit,
      columnRecurringTime,
      columnUserName
    ]);
    print(maps);

    if (maps != null && maps.isNotEmpty) return maps[0];
    return null;
  }
}
