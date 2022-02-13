import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/UserModel.dart';
import 'package:flutter_login_signup/src/routing.dart';

import 'package:flutter_login_signup/src/HomePage.dart';
import 'package:flutter_login_signup/src/utils/tools.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  /* LoginPage({Key key, this.title}) : super(key: key);

  final String title; */

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _login = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  SharedPreferences loginData;
  String id_etudiant;
  String id_classe;
  UserModel myuser;
  var url = checkEtudiant;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      id_etudiant = loginData.getString('id_etudiant');
      id_classe = loginData.getString('id_classe');
    });
  }

  void getUser(String login, String password) async {
    if (await checkInternet()) {
      try {
        var res = await Dio()
            .post('$url', data: {'email': '$login', 'password': '$password'});
        var myres =
            (res.data as List).map((e) => UserModel.fromJson(e)).toList().first;

        if (myres.id_etudiant != null && myres.id_classe != null) {
          loginData.setBool('login', true);
          loginData.setString('id_etudiant', myres.id_etudiant);
          loginData.setString('id_classe', myres.id_classe);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } catch (e) {
        print(e);
      }
    } else {
      Fluttertoast.showToast(msg: "Enable Internet");
    }
  }

  Widget _entryField(String title, TextEditingController controllerInput,
      {bool isPassword = false}) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
          BoxShadow(
              blurRadius: 1,
              color: Colors.black,
              //spreadRadius: 1,
              offset: Offset(0, 1))
        ]),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        //child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        //  children: <Widget>[
        child: TextField(
            key: Key(title),
            controller: controllerInput,
            obscureText: isPassword,
            decoration: InputDecoration(
                hintText: title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
                fillColor: Color(0xfff3f3f4),
                filled: true))
        // ],
        //),
        );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () => getUser(_login.text, _password.text),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF294a7D),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 3),
              blurRadius: 2,
            )
          ],
          /*     gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF01579B), Color(0xFF00ACC1)]), */
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'I',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFBC02D),
          ),
          children: [
            TextSpan(
              text: 'SET',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'RADES',
              style: TextStyle(color: Color(0xFFFBC02D), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", _login, isPassword: false),
        _entryField("Password", _password, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            _header(),
            /* Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()), */
            /*   SizedBox(
              height: 20,
            ), */
            Expanded(
              child: Container(
                // height: 190,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(height: height * .2),
                      // _title(),
                      //SizedBox(height: 50),
                      _emailPasswordWidget(),
                      //SizedBox(height: 20),
                      _submitButton(),
                      /*  Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: height * .055), */
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

  Text _telWidget() {
    return new Text(
      "Presence",
      style: new TextStyle(
          fontFamily: 'Frijole',
          color: Colors.white,
          fontSize: 13.0,
          letterSpacing: 2.0),
    );
  }

  Text _nameIsetWidget() {
    return new Text(
      "ISET Rades",
      style: new TextStyle(
          fontFamily: 'Frijole',
          color: Colors.white,
          fontSize: 20.0,
          letterSpacing: 2.0),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 70);
    var controlPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

Stack _header() {
  return Stack(
    children: [
      ClipPath(
        clipper: MyClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF60C2CB),
          ),
          height: 145,
        ),
      ),
      ClipPath(
        clipper: MyClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF294a7D),
          ),
          height: 140,
        ),
      ),
      ClipPath(
        clipper: MyClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFB64D),
          ),
          height: 135,
        ),
      ),
      ClipPath(
        clipper: MyClipper(),
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/isetRades.jpg"),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      spreadRadius: 10,
                      offset: Offset(3, 4))
                ]),
            height: 130,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Container(color: Color(0xFF28527a)),
                ),
                Positioned(
                  top: 40,
                  left: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.white,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/img/logo.jpg"),
                      radius: 25,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 130,
                  child: _nameIsetWidget(),
                ),
                Positioned(top: 70, left: 130, child: _telWidget())
              ],
            )),
      ),
    ],
  );
}

Text _telWidget() {
  return new Text(
    "Presence",
    style: new TextStyle(
      fontFamily: 'Frijole',
      color: Colors.white,
      fontSize: 13.0,
      letterSpacing: 2.0,
    ),
  );
}

Text _nameIsetWidget() {
  return new Text(
    "ISET Rades",
    style: new TextStyle(
      fontFamily: 'Frijole',
      color: Colors.white,
      fontSize: 20.0,
      letterSpacing: 2.0,
    ),
  );
}
