import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/src/ListMatierePage.dart';
import 'package:flutter_login_signup/src/routing.dart';
import 'package:flutter_login_signup/src/utils/tools.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCode = 'Unknown';
  String _locationMessage = "";
  SharedPreferences loginData;
  var url = scanneQrCode;
  var urlLocation = checkGPS;
  String sp_idEtudiant;
  bool statusInternet = false;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  Future<String> _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // print("abbes ${position.latitude},${position.longitude}");
    return postCurrentLocation("${position.latitude},${position.longitude}");
  }

  void getIdEtudiant() async {
    loginData = await SharedPreferences.getInstance();
    sp_idEtudiant = (loginData.getString('id_etudiant'));
    setState(() {
      sp_idEtudiant = sp_idEtudiant;
    });
  }

  @override
  void initState() {
    super.initState();
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); */
    getIdEtudiant();
  }

  /*Future<bool> checkInternet() async {
    /*var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    }*/

    switch (await Connectivity().checkConnectivity()) {
      case ConnectivityResult.mobile:
        return true;
        break;
      case ConnectivityResult.wifi:
        return true;
        break;
      default:
        return false;
    }
  }*/

  Future<String> postCurrentLocation(String location) async {
    try {
      var res =
          await Dio().post('$urlLocation', data: {'location': '$location'});
      /*     var res = await Dio().post('$urlLocation',
          data: {"location": "36.759965937529905,10.269411878571459"});  */
      return res.toString();
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future<String> postScannerQrCode(String id_etudiant, String qr) async {
    try {
      var res = await Dio().post('$url',
          data: {'id_etudiant': '$id_etudiant', 'dataQrCode': '$qr'});

      return res.toString();
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  void main(context) async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled) {
      if (await checkInternet()) {
        Fluttertoast.showToast(
            msg: "GPS Location", toastLength: Toast.LENGTH_LONG);

        if (await _getCurrentLocation() == "Valid Location") {
          String resultScan = await scanQRCode();
          if (resultScan == "error code") {
            _showAlertDialog(context, "Alert", "Do you want To Rescan ?");
          }
          Fluttertoast.showToast(msg: resultScan);
        } else {
          Fluttertoast.showToast(msg: "Error Location");
        }
      } else {
        Fluttertoast.showToast(msg: "Enable Internet");
      }
    } else {
      Fluttertoast.showToast(msg: "Enable GPS");
    }
  }

  Widget _historiqueButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListMatierePage()));
      },
      child: Container(
        key: Key("Historique"),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xFF0D47A1).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Historique',
          style: TextStyle(
              fontFamily: 'Frijole', fontSize: 20, color: Color(0xFF0D47A1)),
        ),
      ),
    );
  }

  Future _showAlertDialog(
      BuildContext context, String title, String message) async {
    AlertDialog alertDialog = AlertDialog(
      // title: Text(title),
      title: Icon(
        Icons.warning_amber,
        size: 40,
        color: Color(0xFFf4d160),
      ),
      content: Text(message),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () async {
                String resultScan = await scanQRCode();
                Fluttertoast.showToast(msg: resultScan);
              },
              child: Text('YES'),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: Color(0xFF294a7D),
                  fixedSize: Size(100, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topRight: Radius.circular(20)))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('NO'),
              key: Key("noButton"),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: Color(0xFF294a7D),
                  fixedSize: Size(100, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)))),
            ),
          ],
        )
      ],
    );
    return await showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  Widget _scanneButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          main(context);
        },
        child: new Container(
            child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,

                          //spreadRadius: 2,
                          color: Colors.black.withOpacity(0.6),
                          offset: Offset(3, 4))
                    ]),
                child: Icon(
                  Icons.qr_code,
                  size: 90,
                  color: Colors.black,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Code QR',
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontSize: 13,
                fontFamily: 'Frijole',
                //decoration: TextDecoration.underline,
              ),
            ),
          ],
        )));
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
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'SET ',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            TextSpan(
              text: 'RADES',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  Future<String> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) {
        return "error";
      }

      setState(() {
        this.qrCode = qrCode;
      });
      var res = await postScannerQrCode(sp_idEtudiant, qrCode);

      return res;
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
      Fluttertoast.showToast(msg: this.qrCode);
      return qrCode;
    }
  }

  String displayQr() {
    return qrCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _header(context),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          //height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              _historiqueButton(),
              SizedBox(
                height: 60,
              ),
              /* _signUpButton(),
              SizedBox(
                height: 20,
              ),*/
              _scanneButton(context),
            ],
          ),
        ),
      ]),
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

Stack _header(BuildContext context) {
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
                /*  Positioned(
                  top: 20,
                  left: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ), */
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
