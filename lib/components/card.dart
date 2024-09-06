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
        height: 220,
        width: 150,
        child: Card(
          elevation: 4,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (mood != null) ...[
                  mood!,
                  SizedBox(height: 10),
                ],
                Text(
                  subText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
