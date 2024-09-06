import 'package:flutter/material.dart';

import 'components/bottom_bar.dart';

class OrganisationPage extends StatefulWidget {
  const OrganisationPage({Key? key}) : super(key: key);

  @override
  State<OrganisationPage> createState() => _OrganisationPageState();
}

class _OrganisationPageState extends State<OrganisationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Company Name'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Mark your Attendance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                    shadowColor: Colors.black,
                    elevation: 5,
                  ),
                  onPressed: () {},
                  child: const Text('Mark Attendance'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'General Info',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('General Info'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Get in Touch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('SpotSync'),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      onPressed: () {},
                      child: const Text('Message'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.play_circle),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tiktok),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Prasad Mitnapure',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('12 minutes ago'),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to "SpotSync". This is where you can check out our latest announcements.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar: Bottom_Bar()
    );
  }
}