import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/src/loginPage.dart';
import 'package:flutter_login_signup/src/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SharedPreferences loginData;
  bool newuser;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _mockCheckForSession().then((status) {
      check_if_already_login();
    });
  }

  void check_if_already_login() async {
    loginData = await SharedPreferences.getInstance();
    newuser = (loginData.getBool('login'));
    print(newuser);
    if (newuser == true) {
      _navigateToHome();
    } else {
      _navigateToLogin();
    }
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});

    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontFamily: 'Frijole', fontSize: 26),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(0, 3),
                ),
              ]),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/img/logo.jpg'),
                radius: 60,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              "Loading ...",
              style: TextStyle(fontFamily: 'Frijole'),
            )
          ],
        ),
      ),
    );
  }
}
