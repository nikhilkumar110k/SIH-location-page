import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../components/custom_buttons.dart';
import '../components/segmented_control.dart';
import '../loginandsigninredirector.dart';
import 'screen1.dart';
import 'screen3.dart';

class WelcomeScreen2 extends StatelessWidget {
  static String id = 'WelcomeScreen2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Image(
                image: AssetImage('images/Illustration.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Find Balance with SpotSync',
                textAlign: TextAlign.center,
                style: kWelcomeHeadingText,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dx > sensitivity) {
                  // Right Swipe
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen1()));
                } else if (details.delta.dx < -sensitivity) {
                  //Left Swipe
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen3()));                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: Container(
                  height: 250.0,
                  decoration: kBottomContainer,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: SegmentedControl(index: 2,),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Empowering You to Thrive Amidst Corporate challenges.",
                          textAlign: TextAlign.center,
                          style: kWelcomeText,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 15.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginandSignPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('skip', style: TextStyle(color: Colors.white))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child:SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomeScreen3()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Next', style: TextStyle(color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
