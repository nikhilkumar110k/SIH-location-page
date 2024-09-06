import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final String name;
  String pfp;

  HeroSection({required this.name, required this.pfp});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFFDEEEFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 70),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $name!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'How are you feeling today?',
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(pfp),
            ),
          ],
        ),
      ),
    );
  }
}
