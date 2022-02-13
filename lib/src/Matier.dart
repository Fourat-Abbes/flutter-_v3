class Matier {
  String id_matiere;
  String libelle;
  String charge_horaire;
  String nb_abs;

  Matier({this.id_matiere, this.libelle, this.charge_horaire, this.nb_abs});

  factory Matier.fromJson(Map<String, dynamic> json) {
    Matier c = Matier();
    c.id_matiere = json['id_matiere'].toString();
    c.libelle = json['libelle'];
    c.charge_horaire = json['charge_horaire'].toString();
    c.nb_abs = json['nb_abs'].toString();
    return c;
  }
}
