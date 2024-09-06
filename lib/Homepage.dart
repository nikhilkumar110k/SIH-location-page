import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:sih_spot_sync/components/bottom_bar.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {


  PermissionStatus _status = PermissionStatus.denied;

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationAlways.request();
    if (status.isDenied) {
      AlertDialog alertbox = AlertDialog(
        title: const Text("Please provide the necessary permissions"),
        actions:
        <Widget>[
          TextButton(onPressed: () async {
            await openAppSettings();
          }, child: const Text("OK"),),
          TextButton(onPressed: () {
            exit(0);
          }, child: const Text("Leave the App"))
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertbox;
        },
      );
    }
    setState(() {
      _status = status;
    });
  }

  List<Map<String, dynamic>> loadedEntries = [];

  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final url = Uri.parse('https://team007-dc442.firebaseio.com/userdata.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      loadedEntries = data["userID"];
      setState(() {

      });
    } else {
      throw Exception('Failed to load diary entries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:
        Text("Welcome!, ${loadedEntries}"),),
        bottomNavigationBar: Bottom_Bar()
    );
  }

}
