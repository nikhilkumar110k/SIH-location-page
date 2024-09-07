import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sih_spot_sync/ProfilePage.dart';
import 'package:sih_spot_sync/components/bottom_bar.dart';
import 'package:sih_spot_sync/loginandsigninredirector.dart';

import 'components/card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> data = ['John Pope J'];
  final DateTime _focusDate = DateTime.now();
  final List<String> _items = ['Online', 'Near Me', 'Request', 'Propose'];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 1;
  double progressValue = 87;
  double successrate = 87;
  bool _isValueTrue = true;
  late PermissionStatus _status;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionDialog();
    } else {
      setState(() {
        _status = status;
      });
    }
  }

  void _showPermissionDialog() {
    AlertDialog alertbox = AlertDialog(
      title: const Text("Please provide the necessary permissions"),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await openAppSettings();
          },
          child: const Text("OK"),
        ),
        TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text("Leave the App"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertbox;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat();

    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> loadedEntries = [];

  Future<void> _loadData() async {
    final url = Uri.parse('https://team007-dc442.firebaseio.com/userdata.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        loadedEntries = data["userID"] ?? [];
      });
    } else {
      throw Exception('Failed to load diary entries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text("Welcome!, ${loadedEntries.isNotEmpty ? loadedEntries.join(', ') : 'User'}"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                const Text(
                  "Welcome!,User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: const Text(
                    "How is the Day!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],)
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileEdit1()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                openAppSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginandSignPage()));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottom_Bar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Center(
                    child: _isValueTrue == true
                        ? Lottie.asset(
                      'images/0lodmNbkGD.json',
                      controller: _animationController,
                      height: 400,
                      width: 400,
                      fit: BoxFit.fill,
                    )
                        : Lottie.asset(
                        'images/Animation - 1725657761664 (1).json',
                        controller: _animationController,
                        height: 400,
                        width: 400,
                        fit: BoxFit.fill),
                  ),
                  Center(
                      child:
                      Text(_isValueTrue == true ? "Active" : "Inactive")),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isValueTrue = !_isValueTrue;
                        });
                      },
                      child: Text("Change the colour")),
                  SizedBox(
                    child: _isValueTrue == true
                        ? Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: CardWidget(
                                  color:
                                  Color.fromRGBO(80, 193, 84, 100),
                                  heading: "Report",
                                  subText: "See Report"),
                            ),
                            CardWidget(
                                color: Color.fromRGBO(80, 193, 84, 100),
                                heading: "Leave",
                                subText: "Take Leave"),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: CardWidget(
                                  color:
                                  Color.fromRGBO(80, 193, 84, 100),
                                  heading: "Tasks",
                                  subText: "Tasks"),
                            ),
                            CardWidget(
                                color: Color.fromRGBO(80, 193, 84, 100),
                                heading: "About us",
                                subText: "Details"),
                          ],
                        ),
                      ],
                    )
                        : Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: CardWidget(
                                  color: Color.fromRGBO(255, 142, 58, 100),
                                  heading: "Report",
                                  subText: "See Report"),
                            ),
                            CardWidget(
                                color: Color.fromRGBO(255, 142, 58, 100),
                                heading: "Leave",
                                subText: "Take Leave"),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: CardWidget(
                                  color: Color.fromRGBO(255, 142, 58, 100),
                                  heading: "Tasks",
                                  subText: "Tasks"),
                            ),
                            CardWidget(
                                color: Color.fromRGBO(255, 142, 58, 100),
                                heading: "About us",
                                subText: "Details"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
