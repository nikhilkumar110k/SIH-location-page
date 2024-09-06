import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sih_spot_sync/components/bottom_bar.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
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
      loadedEntries= data["userID"];
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
