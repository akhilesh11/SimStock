import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simstock/AddStock.dart';
import 'package:simstock/Screens/userProfile.dart';
import 'package:simstock/Widgets/topHeading.dart';
import 'package:simstock/constants.dart';
import 'UserData/User.dart';
import 'Widgets/StockTile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Widgets/UserStocksPage.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var recentJobsRef = FirebaseDatabase.instance.reference().child('Stocks');

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  bool dataAvailable = true;
  bool emptySearch = true;

  List<String> searchedKeys = [];
  List<String> keys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(
          indicatorColor: kleatherBrown,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            new Tab(
              text: 'Market',
            ),
            new Tab(
              text: 'My Stocks',
            ),
            new Tab(
              text: 'My Profile',
            ),
          ],
          controller: _tabController),
      backgroundColor: kbackgroundBlue,
      body: CustomPaint(
        painter: appBarBackground(),
        child: SafeArea(
            child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            StreamBuilder(
                stream: recentJobsRef
                    .onValue, // Live Stream of Data from Firebase Database
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
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                title: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: TextField(
                                          onChanged: (value) {
                                            searchedKeys.clear();
                                            setState(() {
                                              if (value != '') {
                                                emptySearch = false;
                                                for (String key in _list.keys) {
                                                  if ((key.toLowerCase())
                                                      .contains(
                                                          value.toLowerCase()))
                                                    searchedKeys.add(key);
                                                }
                                              } else {
                                                emptySearch = true;
                                              }
                                            });

                                            //print(searchedKeys);
                                          },
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              hintText: 'Search',
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      Expanded(child: Icon(Icons.search))
                                    ],
                                  ),
                                ),
                                centerTitle: true,
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 75, horizontal: 10),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (searchedKeys.isEmpty && emptySearch) {
                                      return dataAvailable
                                          ? StockTile(
                                              stockCode: _list[keys[index]]
                                                      ['StockID']
                                                  .toString(),
                                              high: double.parse(
                                                  _list[keys[index]]['High']),
                                              low: double.parse(
                                                  _list[keys[index]]['Low']),
                                              close: double.parse(
                                                  _list[keys[index]]['Value']),
                                              title: _list[keys[index]]
                                                  ['StockName'],
                                              stockInfo: _list[keys[index]]
                                                      ['StockInfo'] ??
                                                  'NA',
                                              stockInfoColor: _list[keys[index]]
                                                  ['Color'],
                                              lastUpdated: _list[keys[index]]
                                                  ['LastUpdated'],

                                              // On Tap Function
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, AddStock.id,
                                                    arguments: {
                                                      'StockCode':
                                                          _list[keys[index]]
                                                              ['StockID'],
                                                      'CurrentValue':
                                                          double.parse(
                                                              _list[keys[index]]
                                                                  ['Value']),
                                                      'StockName':
                                                          _list[keys[index]]
                                                              ['StockName'],
                                                    });
                                              },
                                            )//To display the individual stock Info
                                          : Shimmer.fromColors(
                                              child: Container(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 100,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    child: Center(
                                                      child: Text(
                                                        'Fetching Data',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              baseColor: Colors.grey,
                                              highlightColor: Colors.grey[400]);
                                    } else if (!emptySearch &&
                                        searchedKeys.isNotEmpty) {
                                      return dataAvailable
                                          ? StockTile(
                                              stockCode: _list[searchedKeys[index]]
                                                      ['StockID']
                                                  .toString(),
                                              high: double.parse(
                                                  _list[searchedKeys[index]]
                                                      ['High']),
                                              low: double.parse(
                                                  _list[searchedKeys[index]]
                                                      ['Low']),
                                              close: double.parse(
                                                  _list[searchedKeys[index]]
                                                      ['Value']),
                                              title: _list[searchedKeys[index]]
                                                  ['StockName'],
                                              stockInfo:
                                                  _list[searchedKeys[index]]
                                                          ['StockInfo'] ??
                                                      'NA',
                                              stockInfoColor: _list[searchedKeys[index]]['Color'],
                                          lastUpdated: _list[searchedKeys[index]]
                                          ['LastUpdated'],
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, AddStock.id,
                                                    arguments: {
                                                      'StockCode': _list[
                                                              searchedKeys[
                                                                  index]]
                                                          ['StockID'],
                                                      'CurrentValue':
                                                          double.parse(_list[
                                                                  searchedKeys[
                                                                      index]]
                                                              ['Value']),
                                                      'StockName': _list[
                                                              searchedKeys[
                                                                  index]]
                                                          ['StockName'],
                                                    });
                                              })
                                          : Shimmer.fromColors(
                                              child: Container(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 100,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    child: Center(
                                                      child: Text(
                                                        'Fetching Data',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              baseColor: Colors.grey,
                                              highlightColor: Colors.grey[400]);
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
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
                                  childCount: searchedKeys.isEmpty
                                      ? emptySearch ? keys.length : 1
                                      : searchedKeys.length,
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
                }),
            UserStocksPage(
              firebaseData: recentJobsRef.onValue,
            ),
            UserProfile(
              dropdownvalue:
                  Provider.of<User>(context, listen: false).userRecurTime,
              recurringAmount:
                  Provider.of<User>(context, listen: false).userRecurAmount,
            ),
          ],
        )),
      ),
    );
  }
}
