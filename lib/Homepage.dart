import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sih_spot_sync/components/bottom_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<String> data = ['John Pope J'];
  final DateTime _focusDate = DateTime.now();
  final List<String> _items = ['Online', 'Near Me', 'Request', 'Propose'];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 1;
  double progressValue = 87;
  double successrate = 87;
  bool _isValueTrue =true;
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
      appBar: AppBar(
        title: Text("Welcome!, ${loadedEntries.isNotEmpty ? loadedEntries.join(', ') : 'User'}"),
      ),
      bottomNavigationBar: Bottom_Bar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Center(
                child: _isValueTrue==true
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
                  fit: BoxFit.fill
                ),
              ),
              Center(
                  child: Text(_isValueTrue==true ? "Active" : "Inactive")),
              ElevatedButton(onPressed: (){
                setState(() {
                  if(_isValueTrue==true){
                  _isValueTrue=false;}
                  else{
                    _isValueTrue=true;
                  }
                });
              }, child: Text("Change the colour"))
            ],
          ),
        ],
      ),
    );
  }
}
