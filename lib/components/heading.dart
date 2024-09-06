import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  String heading;
  Heading({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
      child: Text(
        heading,
        style: TextStyle(
          color: Color(0xFFB1B1B2),
          fontSize: 16,
        ),
      ),
    );
  }
}
