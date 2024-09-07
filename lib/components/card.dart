import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Color color;
  final String heading;
  String subText;
  final Image? mood;

  CardWidget({
    required this.color,
    required this.heading,
    required this.subText,
    this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25),
      child: SizedBox(
        height: 150,
        width: 150,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20)),
          child: Card(
            elevation: 4,
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (mood != null) ...[
                    mood!,
                    SizedBox(height: 10),
                  ],
                  Text(
                    subText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
