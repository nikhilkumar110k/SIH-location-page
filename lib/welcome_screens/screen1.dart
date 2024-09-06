import 'package:flutter/material.dart';
import 'package:sih_spot_sync/loginandsigninredirector.dart';

import '../components/constants.dart';
import '../components/segmented_control.dart';
import '../custom_buttons.dart';
import 'screen2.dart';

class WelcomeScreen1 extends StatelessWidget {
  static String id = 'WelcomeScreen1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 2,
              child: Image(
                image: AssetImage('images/Illustration.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Welcome to SpotSync: Your Personalized Management Tool',
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
                } else if (details.delta.dx < -sensitivity) {
                  //Left Swipe
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen2()));
                }
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
                        child: SegmentedControl(index: 1,),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Manage Your Employees in one GO with this App",
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
                            child: SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child:
                            SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomeScreen2()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Next', style: TextStyle(color: Colors.black))),
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
