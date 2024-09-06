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
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                            'images/organishationpageitemimage.png',
                            width: double.infinity,
                            height: 200,
                          fit: BoxFit.cover,
                          ),
                        Positioned(
                          left: 0,
                          bottom: -20,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1)
                              ),
                              child: Image.asset(
                                  'images/spot_1.png',
                                  width: 80,
                                  height: 60,
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 16.0),child:
                    const Text(
                      'SpotSync',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),),
                    Row(children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 50.0),
                          child: Text(
                            'Mark your Attendance',
                            style: TextStyle(fontSize:14),

                          ),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {},
                          child: Flexible(child: const Text('Mark Attendance')),
                        ),
                      ),
                    ],),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'General Info >',
                            style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          iconAlignment: IconAlignment.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        'Get in Touch',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 193.0),
                          child: const Text('SpotSync'),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {},
                        child: Flexible(child: const Text('Message')),
                                            ),
                      ),],),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prasad Mitnapure',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          const Text('12 minutes ago'),
                          SizedBox(height: 10),
                          const Text(
                            'Welcome to "SpotSync". This is where you can check out our latest announcements.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottom_Bar(),
    );
  }
}