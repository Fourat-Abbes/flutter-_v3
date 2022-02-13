class UserModel {
  String id_etudiant;
  String id_classe;

  String accessToken;

  UserModel({this.id_etudiant, this.id_classe});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel c = UserModel();
    c.id_etudiant = json['id_etudiant'].toString();
    c.id_classe = json['id_classe'].toString();

    return c;
  }
}
