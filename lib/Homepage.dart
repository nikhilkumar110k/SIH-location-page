import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProfilePage.dart';
import 'components/bottom_bar.dart';
import 'loginandsigninredirector.dart';
import 'components/card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String employeeId='';
  String _locationMessage = "Fetching location...";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _items = ['Online', 'Near Me', 'Request', 'Propose'];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 1;
  bool _isValueTrue = false;
  late PermissionStatus _status;
  String loadedEntries = 'User';
  Timer? _timer;
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _sendCurrentLocation();
    _requestLocationPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 10),
    );
    _animationController.repeat();
    startSendingLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _positionStreamSubscription?.cancel();
    stopSendingLocation();
    super.dispose();
  }

  void startSendingLocation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _sendCurrentLocation();
    });
  }

  void stopSendingLocation() {
    _timer?.cancel();
  }

  Future<void> _sendCurrentLocation() async {
    if (employeeId == null) {
      print("Employee ID is not set. Cannot send location.");
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await sendLocationToBackend(position.latitude, position.longitude, employeeId);
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      _startLocationStream();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionDialog();
    }
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

  Future<String?> sendLocationToBackend(
      double latitude, double longitude, String initialEmployeeId) async {
    final String timestamp = DateTime.now().toLocal().toIso8601String();
    final url = Uri.parse('https://spotsync.tg-tool.tech/api/store');
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.email == null) {
      print("No user is currently signed in or email is missing.");
      return null;
    }

    print("Current User Email: ${currentUser.email}");

    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await databaseRef.child('userdata').get();

    String? employeeId;

    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> allUsers = snapshot.value as Map<dynamic, dynamic>;

      for (var userData in allUsers.values) {
        if (userData is Map && userData['email'] == currentUser.email) {
          employeeId = userData['employeeidfrombackend'];
          print("Employee ID found: $employeeId");
          break;
        }
      }

      if (employeeId == null) {
        print("No matching user data found for email: ${currentUser.email}");
        return null;
      }
    } else {
      print("No user data found in the database.");
      return null;
    }

    final Map<String, dynamic> locationData = {
      "point": {
        "lat": latitude,
        "lng": longitude,
      },
      "employeeId": employeeId, // Use the retrieved employee ID
      "timestamp": timestamp,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(locationData),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isValueTrue = true;
          });
        }
        print('Location sent successfully!');
      } else {
        throw Exception('Failed to send location. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error sending location: $error");
    }

    return null;
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
        title: Text("Welcome!, ${loadedEntries.isNotEmpty ? loadedEntries : 'User'}"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Welcome!, User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "How is the Day!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const ProfileEdit1()));
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoginandSignPage()));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar:  Bottom_Bar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _isValueTrue
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
                child: Text(
                  _isValueTrue ? "Active" : "Inactive",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      _sendCurrentLocation();
                      setState(() {
                        _isValueTrue = !_isValueTrue;
                      });
                    },
                    child: const Text("Change the colour")),
              ),
              _isValueTrue
                  ? Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: CardWidget(
                            color: Color.fromRGBO(80, 193, 84, 100),
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
                            color: Color.fromRGBO(80, 193, 84, 100),
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
            ],
          ),
        ),
      ),
    );
  }
}
