import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  final int initialIndex;
  const SegmentedControl({super.key, this.initialIndex = 0});

  @override
  _SegmentedControlState createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 10,
            width: 30,
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? Colors.white // Selected button color
                  : Colors.white.withOpacity(0.3), // Unselected button color
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}
