import 'package:flutter/material.dart';
import 'package:sih_spot_sync/components/card.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.transparent,

      ),
      body:
      Column(
        children: [
          CardWidget(color: Colors.grey, heading: "Contacts", subText: "Call someone"),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.transparent,width : 2),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey,
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Column(
                        children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contacts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Hello",
                              style: TextStyle(fontSize: 20,color: Colors.white),
                              softWrap: true,),
                          ],
                        ),
                      ],),
                    ),),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
