class Actividad {
  final int actividadid;
  final int loteid;
  final int usuarioid;
  final String descripcion;
  final String? fechainicio;
  final String? fechafin;
  final int tipoactividadid;
  final int prioridadid;
  final String? observaciones;

  Actividad({
    required this.actividadid,
    required this.loteid,
    required this.usuarioid,
    required this.descripcion,
    this.fechainicio,
    this.fechafin,
    required this.tipoactividadid,
    required this.prioridadid,
    this.observaciones,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      actividadid: json['actividadid'],
      loteid: json['loteid'],
      usuarioid: json['usuarioid'],
      descripcion: json['descripcion'],
      fechainicio: json['fechainicio'],
      fechafin: json['fechafin'],
      tipoactividadid: json['tipoactividadid'],
      prioridadid: json['prioridadid'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actividadid': actividadid,
      'loteid': loteid,
      'usuarioid': usuarioid,
      'descripcion': descripcion,
      'fechainicio': fechainicio,
      'fechafin': fechafin,
      'tipoactividadid': tipoactividadid,
      'prioridadid': prioridadid,
      'observaciones': observaciones,
    };
  }
}