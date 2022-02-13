class DetaillMatierModel {
  String id_presence;
  String id_etudiant;
  String id_enseignement;
  String id_etat_presence_etd;
  String localisation;
  String time;
  String id_seance;
  String id_salle;
  String id_matiere;
  String id_enseignant;
  String id_classe;
  String id_statut_enseignement;
  String qr_code;
  String libelle;
  String charge_horaire;
  String id_type_enseignement;
  String id_semestre;
  String id_niveau;

  DetaillMatierModel(
      {this.id_presence,
      this.id_etudiant,
      this.id_enseignement,
      this.id_etat_presence_etd,
      this.localisation,
      this.time,
      this.id_seance,
      this.id_salle,
      this.id_matiere,
      this.id_enseignant,
      this.id_classe,
      this.id_statut_enseignement,
      this.qr_code,
      this.libelle,
      this.charge_horaire,
      this.id_type_enseignement,
      this.id_semestre,
      this.id_niveau});

  factory DetaillMatierModel.fromJson(Map<String, dynamic> json) {
    DetaillMatierModel c = DetaillMatierModel();
    c.id_presence = json['id_presence'].toString();
    c.id_etudiant = json['id_etudiant'].toString();
    c.id_enseignement = json['id_enseignement'].toString();
    c.id_etat_presence_etd = json['id_etat_presence_etd'].toString();
    c.localisation = json['localisation'].toString();
    c.time = json['time'].toString();
    c.id_seance = json['id_seance'].toString();
    c.id_salle = json['id_salle'].toString();
    c.id_matiere = json['id_matiere'].toString();
    c.id_enseignant = json['id_enseignant'].toString();
    c.id_classe = json['id_classe'].toString();
    c.id_statut_enseignement = json['id_statut_enseignement'].toString();
    c.qr_code = json['qr_code'].toString();
    c.libelle = json['libelle'].toString();
    c.charge_horaire = json['charge_horaire'].toString();
    c.id_type_enseignement = json['id_type_enseignement'].toString();
    c.id_semestre = json['id_semestre'].toString();
    c.id_niveau = json['id_niveau'].toString();

    return c;
  }
}
