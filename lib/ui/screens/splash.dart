import 'package:aliftech_test/db/todo_database.dart';
import 'package:aliftech_test/ui/screens/main.dart';
import 'package:aliftech_test/ui/screens/screens.dart';
import 'package:aliftech_test/util/env.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static const routeName = 'splashScreen';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Main(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          //alif tech
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: 'alif',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' tech TODO',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const CircularProgressIndicator(),
              ],
            ),
          ),
          //powered by
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('powered by'),
                SizedBox(width: 10),
                //Logo
                Center(
                  child: Image(
                    image: AssetImage('images/logo.png'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
