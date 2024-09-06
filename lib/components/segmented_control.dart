import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  const SegmentedControl({super.key,required index});
  @override
  _SegmentedControlState createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex==index;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 10,
            width: 30,
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}
