import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      datasets: {
        DateTime(2024, 2, 20): 3,
        DateTime(2024, 2, 22): 7,
        DateTime(2024, 2, 25): 10,
        DateTime(2024, 2, 28): 13,
        DateTime(2024, 3, 1): 6,
        DateTime(2024, 3, 1): 6,
      },
      colorMode: ColorMode.opacity,
      startDate: DateTime(2024, 2, 1),
      endDate: DateTime.now().add(Duration(days: 60)),
      showText: false,
      scrollable: false,
      colorsets: {
        1: Color.fromARGB(20, 2, 19, 8),
        2: Color.fromARGB(40, 2, 19, 8),
        3: Color.fromARGB(60, 2, 19, 8),
        4: Color.fromARGB(80, 2, 19, 8),
        5: Color.fromARGB(100, 2, 19, 8),
        6: Color.fromARGB(120, 2, 19, 8),
        7: Color.fromARGB(150, 2, 19, 8),
        8: Color.fromARGB(180, 2, 19, 8),
        9: Color.fromARGB(220, 2, 19, 8),
        10: Color.fromARGB(255, 2, 19, 8),
      },
    );
  }
}