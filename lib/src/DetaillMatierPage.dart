import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/DetaillMatierModel.dart';
import 'package:flutter_login_signup/src/HomePage.dart';
import 'package:flutter_login_signup/src/ListMatierePage.dart';
import 'package:flutter_login_signup/src/routing.dart';
import 'package:flutter_login_signup/src/utils/tools.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Matier.dart';

var COLORS = [
  Color(0xFF28527a),
  Color(0xFF8ac4d0),
  Color(0xFFf4d160),
  //Color(0xFFfbeeac),
  //Color(0xFF28527a),
];

class DetaillMatierPage extends StatefulWidget {
  String id_matiere;
  String libelle;
  DetaillMatierPage(this.id_matiere, this.libelle);

  @override
  _DetaillMatierPage createState() =>
      new _DetaillMatierPage(id_matiere, libelle);
}

class _DetaillMatierPage extends State<DetaillMatierPage> {
  String id_matiere;
  String libelle;
  _DetaillMatierPage(this.id_matiere, this.libelle);
  var url = listDetaillMatiereEtudiant;

  List<DetaillMatierModel> _listDetaillMatiere = [];
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
      getDetaillMatiere(sp_idEtudiant, sp_idClasse, id_matiere);
    } else {
      Fluttertoast.showToast(msg: "Enable Internet");
    }
  }

  void getDetaillMatiere(
      String id_etudiant, String id_classe, String id_matiere) async {
    try {
      var res = await Dio().post('$url', data: {
        'id_etudiant': '$id_etudiant',
        'id_classe': '$id_classe',
        'id_matiere': '$id_matiere'
      });

      final myres = (res.data as List)
          .map((e) => DetaillMatierModel.fromJson(e))
          .toList();
      setState(() {
        _listDetaillMatiere = myres;
      });
    } catch (e) {
      print(e);
    }
  }

  String _getCleanDate(String time) {
    var res = time.split('-');
    var day = int.parse(res[2]) + 1;
    return res[0] + '-' + res[1] + '-' + day.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*  backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: new Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ), */
      body: Container(
        child: Column(
          children: [
            _header(context),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.assignment_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  key: Key("atelier_cms"),
                  child: Text(   
                    libelle + " : Absence",
                    style: TextStyle(
                      fontSize: 20,
                      //fontFamily: 'Frijole',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                height: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  primary: true,
                  itemCount: _listDetaillMatiere.length,
                  itemBuilder: (BuildContext content, int index) {
                    //print(_listDetaillMatiere[index].time);
                    return AwesomeListItem(
                      title: _getCleanDate(_listDetaillMatiere[index].time),
                      color:
                          Color(0xFFf4d160), // COLORS[new Random().nextInt(3)],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )

      /* new Stack(
        children: <Widget>[
          
          new Transform.translate(
            offset: Offset(0.0, -56.0),
            child: new Container(
              child: new ClipPath(
                clipper: new MyClipper(),
                child: new Stack(
                  children: [
                    new Image(
                      image: AssetImage("assets/img/isetRades.jpg"),
                      fit: BoxFit.cover,
                    ),
                    new Opacity(
                      opacity: 0.2,
                      child: new Container(color: COLORS[0]),
                    ),
                    new Transform.translate(
                      offset: Offset(0.0, 50.0),
                      child: new ListTile(
                        leading: new CircleAvatar(
                          child: new Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/img/logo.jpg"),
                              ),
                            ),
                          ),
                        ),
                        title: new Text(
                          "ISET Rades",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              letterSpacing: 2.0),
                        ),
                        subtitle: new Text(
                          "71 460 100",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 2.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  libelle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          new Transform.translate(
            offset: new Offset(0.0, MediaQuery.of(context).size.height / 8),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70, top: 40),
              child: new ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                scrollDirection: Axis.vertical,
                primary: true,
                itemCount: _listDetaillMatiere.length,
                itemBuilder: (BuildContext content, int index) {
                  print(_listDetaillMatiere[index].time);
                  return AwesomeListItem(
                      title: _getCleanDate(_listDetaillMatiere[index].time),
                      color:
                          Color(0xFFf4d160), // COLORS[new Random().nextInt(3)],
                      image: "https://picsum.photos/300?random");
                },
              ),
            ),
          ),
        ],
      ), */
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Row(
          children: [
            SizedBox(
              width: 3,
            ),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
            ),
            Icon(
              Icons.qr_code,
              size: 22,
            ),
          ],
        ),
        backgroundColor: Color(0xFF294a7D),
      ),
    );
  }
}

/* class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
} */

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListMatierePage()));
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
  Color color;
  String image;

  AwesomeListItem({this.title, this.content, this.color, this.image});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}
/*
class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Container(width: 10.0, height: 50, color: widget.color),
        new Expanded(
          child: new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
*/

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(8),

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
          /*  new Container(
            width: 40.0,
            height: 80.0,
            //color: widget.colorSeuil,
            child: Center(
              child: new Text(
                "test",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ), */
          new Expanded(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
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
                      Icons.date_range_outlined,
                      color: Colors.white,
                    ),
                  ),
                  new Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Frijole',
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
