import 'package:flutter/material.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({super.key, required this.barValues});
  final List<double> barValues;
  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  List<String> emojis = [
    "small_very_happy.png",
    "small_happy.png",
    "small_normal.png",
    "small_sad.png",
    "small_worried.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.all(Radius.elliptical(20, 20))),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 265,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                const Row(children: [
                  Text(
                    "Mood History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 70),
                    child: Text(
                      "2 Weeks report",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ]),
                Row(
                  children: emojis
                      .map((e) => Padding(
                            padding:
                                EdgeInsets.only(right: 10, top: 8, bottom: 20),
                            child: Container(
                                child: Image.asset(
                              "assets/images/emoji/" + e,
                              width: 20,
                              height: 20,
                            )),
                          ))
                      .toList(),
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.barValues
                        .map((e) => (Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                width: 30,
                                height: e * 130,
                                decoration: const BoxDecoration(
                                    color: Color(0xff82A0C0),
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(5, 5))),
                              ),
                            )))
                        .toList()),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const Text(
                              "17 June",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration:
                                      const BoxDecoration(color: Colors.black)),
                            ),
                            Text(
                              "30 June",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        )))
              ],
            )));
  }
}
