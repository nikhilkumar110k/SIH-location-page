import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  String _locationMessage = "Fetching location...";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _items = ['Online', 'Near Me', 'Request', 'Propose'];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 1;
  bool _isValueTrue = false;
  late PermissionStatus _status;
  String loadedEntries='User';

  Timer? _timer;

  void startSendingLocation() {
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      await _sendCurrentLocation();
    });
  }
  Future<void> _sendCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      const String employeeId = "uud2";
      await sendLocationToBackend(position.latitude, position.longitude, employeeId);
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  void stopSendingLocation() {
    Future<void> stopLocationUpdates() async {
    try {
    bool isServiceRunning = await Geolocator.isLocationServiceEnabled();
    if (isServiceRunning) {
    Geolocator.getPositionStream().listen(null).cancel();
    print("Location updates stopped successfully.");
    }
    } catch (e) {
    print('Error stopping location updates: $e');
    }
    }
  }


  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
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
    _positionStreamSubscription?.cancel();

    super.dispose();
  }

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;



  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      _startLocationStream();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionDialog();
    }
  }
  Future<void> sendLocationToBackend(
      double latitude,
      double longitude,
      String employeeId
      ) async {
    final String timestamp = DateTime.now().toUtc().toIso8601String();
    final url = Uri.parse('https://spotsync.tg-tool.tech/api/store');

    final Map<String, dynamic> locationData = {
      "point": {
        "lat": latitude,
        "lng": longitude,
      },
      "employeeId": employeeId,
      "timestamp": timestamp,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(locationData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isValueTrue=true;
        });
        print('Location sent successfully!');
      } else {
        throw Exception('Failed to send location. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error sending location: $error");
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Permission Required"),
          content: const Text("Please enable location permissions to access real-time location."),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  void _startLocationStream() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _locationMessage = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    });
  }



  Future<void> _loadData() async {
    final url = Uri.parse('https://team007-dc442.firebaseio.com/userdata.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(loadedEntries);

      setState(() {
        loadedEntries = data["employeeidfrombackend"] ?? [];
      });
    } else {
      throw Exception('Failed to load user data');
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
        title: Text("Welcome!, ${loadedEntries.isNotEmpty ? loadedEntries+(', ') : 'User'}"),
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
                      Text(_isValueTrue == true ? "Active" : "Inactive",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
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
