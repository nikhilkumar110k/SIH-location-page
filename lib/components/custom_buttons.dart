import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.destination,
  });

  final String text;
  final MaterialStateProperty<Color> backgroundColor;
  final Color textColor;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        //do something
        Navigator.pushNamed(context, destination);
      },
      child: Text(
        '$text',
        style: TextStyle(
          color: textColor,
          fontSize: 16.0,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: backgroundColor,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Adjust the border-radius as needed
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(140.0, 50.0),
        ),
      ),
    );
  }
}
