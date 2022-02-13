import 'dart:math';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/DetaillMatierModel.dart';
import 'package:flutter_login_signup/src/HomePage.dart';
import 'package:flutter_login_signup/src/routing.dart';
import 'package:flutter_login_signup/src/utils/tools.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Matier.dart';
import 'package:flutter_login_signup/src/DetaillMatierPage.dart';

var COLORS = [
  Color(0xFF28527a),
  Color(0xFF8ac4d0),
  Color(0xFFf4d160),
  Color(0xFFfbeeac),
  Color(0xFF28527a),
];

class ListMatierePage extends StatefulWidget {
  /*  ListMatierePage({Key key, this.title}) : super(key: key);

  final String title; */

  @override
  _ListMatierePageState createState() => new _ListMatierePageState();
}

class _ListMatierePageState extends State<ListMatierePage> {
  var url = listMatiereEtudiant;
  List<Matier> _listMatiere = [];
  SharedPreferences loginData;
  String sp_idClasse;
  String sp_idEtudiant;

  @override
  void initState() {
    super.initState();
    getIdClasse();
  }

  void getIdClasse() async {
    loginData = await SharedPreferences.getInstance();
    sp_idEtudiant = (loginData.getString('id_etudiant'));
    sp_idClasse = (loginData.getString('id_classe'));
    if (await checkInternet()) {
      getMatiere(sp_idClasse, sp_idEtudiant);
    } else {
      Fluttertoast.showToast(msg: "Enable Internet");
    }
  }

  void getMatiere(String id_classe, String id_etudiant) async {
    try {
      var res = await Dio().post('$url',
          data: {'id_classe': '$id_classe', 'id_etudiant': '$id_etudiant'});

      final myres = (res.data as List).map((e) => Matier.fromJson(e)).toList();
      setState(() {
        _listMatiere = myres;
      });
    } catch (e) {
      print(e);
    }
  }

  String getSeuil(String chargeHoraire) {
    double res = ((int.parse(chargeHoraire) * 20) / 100) / 1.5;
    return res.toInt().toString();
  }

  Color getColorSeuil(String seuil, String nbAbs) {
    int res = int.parse(seuil);
    if (res / 2 > int.parse(nbAbs)) {
      //return Colors.green;
      //return Color(0xFF96BB7C);
      return Color(0xFF294a7D);
    }
    if (res <= int.parse(nbAbs)) {
      //return Colors.red;
      return Color(0xFFC64756);
    }
    if (res / 2 <= int.parse(nbAbs) && res > int.parse(nbAbs)) {
      //return Colors.orange;
      return Color(0xFFFAD586);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //backgroundColor: Colors.white,
      /* appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ), */
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              height: 400,
              child: ListView.builder(
                key: Key("list_matiere"),
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                scrollDirection: Axis.vertical,
                primary: true,
                itemCount: _listMatiere.length,
                itemBuilder: (BuildContext content, int index) {
                    
                  return GestureDetector(
                    key: Key('item_${index}'),
                    onTap: () {
                      
                      if (int.parse(_listMatiere[index].nb_abs) > 0) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetaillMatierPage(
                                    _listMatiere[index].id_matiere,
                                    _listMatiere[index].libelle)));
                      } else {
                        Fluttertoast.showToast(msg: "Aucune Absence");
                      }
                    },
                    child: AwesomeListItem(
                        title: _listMatiere[index].libelle,
                        content: _listMatiere[index].nb_abs +
                            '/' +
                            getSeuil(_listMatiere[index].charge_horaire),
                        colorSeuil: getColorSeuil(
                            getSeuil(_listMatiere[index].charge_horaire),
                            _listMatiere[index].nb_abs),
                        color: COLORS[new Random().nextInt(5)],
                        image: "https://picsum.photos/300?random"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
                Positioned(
                  top: 30,
                  left: 25,
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

class AwesomeListItem extends StatefulWidget {
  String title;
  String content;
  String id_matiere;
  String libelle;
  Color color;
  String image;
  Color colorSeuil;

  AwesomeListItem(
      {this.title,
      this.id_matiere,
      this.libelle,
      this.content,
      this.colorSeuil,
      this.color,
      this.image});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.circular(8),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,

                //spreadRadius: 2,
                color: Colors.black.withOpacity(0.6),
                offset: Offset(3, 3))
          ]),
      child: new Row(
        children: <Widget>[
          new Container(
            width: 40.0,
            height: 80.0,
            color: widget.colorSeuil,
            child: Center(
              child: new Text(
                widget.content,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          new Expanded(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: new Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: widget.colorSeuil,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              spreadRadius: 1,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(1, 3))
                        ]),
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.assignment_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
