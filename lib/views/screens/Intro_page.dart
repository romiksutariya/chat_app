import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/theme.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: initialIndex,
      children: [
        //intro page
        SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "WELCOME",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: boldText,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/signUp_page');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Get Started ",
                        ),
                        CupertinoButton(
                          onPressed: () {},
                          child: Icon(
                            CupertinoIcons.arrow_right_square,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        //todo; intro 1

        //todo: intro 2

        //todo: intro 3
      ],
    );
  }
}
