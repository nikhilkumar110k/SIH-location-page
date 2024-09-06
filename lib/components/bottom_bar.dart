import 'package:flutter/material.dart';
import 'package:sih_spot_sync/Homepage.dart';
import 'package:sih_spot_sync/OrganisationPage.dart';

class Bottom_Bar extends StatefulWidget {
  @override
  State<Bottom_Bar> createState() => _Bottom_BarState();
}
class _Bottom_BarState extends State<Bottom_Bar> {
    @override
      Widget build(BuildContext context) {
        return BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             InkWell(
onTap: () => {
 Navigator.push(context, MaterialPageRoute(builder: (context)=> Homepage()))
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.home_outlined, color: Colors.grey),
     Text("Home",style: TextStyle(color: Colors.black),)
  ]
 )
)
            ,
             InkWell(
onTap: () => {
  Navigator.push(context, MaterialPageRoute(builder: (context)=> Homepage()))
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.bubble_chart, color: Colors.grey),
     Text("Colleague",style: TextStyle(color: Colors.black),)
  ]
 )
)
            ,            InkWell(
onTap: () => {
  Navigator.push(context, MaterialPageRoute(builder: (context)=> const OrganisationPage()))
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.people_outline, color: Colors.grey),
     Text("Organisation",style: TextStyle(color: Colors.black),)
  ]
 )
)
            ,            InkWell(
onTap: () => {
  Navigator.push(context, MaterialPageRoute(builder: (context)=> Homepage()))
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.person, color: Colors.grey),
     Text("Profile",style: TextStyle(color: Colors.black),)
  ]
 )
)
            ,        
          ],
        ),
      );
      }
}