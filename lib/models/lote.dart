class Lote {
  final int loteid;
  final int usuarioid;
  final String nombre;
  final String? ubicacion;
  final double superficie;
  final int? cultivoid;
  final String? fechasiembra;
  final int? estadolotetipoid;
  final double? latitud;
  final double? longitud;
  final String fechacreacion;
  final String? fechamodificacion;
  final String? imagenurl;

  Lote({
    required this.loteid,
    required this.usuarioid,
    required this.nombre,
    this.ubicacion,
    required this.superficie,
    this.cultivoid,
    this.fechasiembra,
    this.estadolotetipoid,
    this.latitud,
    this.longitud,
    required this.fechacreacion,
    this.fechamodificacion,
    this.imagenurl,
  });

  factory Lote.fromJson(Map<String, dynamic> json) {
    return Lote(
      loteid: json['loteid'],
      usuarioid: json['usuarioid'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
      superficie: (json['superficie'] as num).toDouble(),
      cultivoid: json['cultivoid'],
      fechasiembra: json['fechasiembra'],
      estadolotetipoid: json['estadolotetipoid'],
      latitud: json['latitud'] != null ? (json['latitud'] as num).toDouble() : null,
      longitud: json['longitud'] != null ? (json['longitud'] as num).toDouble() : null,
      fechacreacion: json['fechacreacion'],
      fechamodificacion: json['fechamodificacion'],
      imagenurl: json['imagenurl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loteid': loteid,
      'usuarioid': usuarioid,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'superficie': superficie,
      'cultivoid': cultivoid,
      'fechasiembra': fechasiembra,
      'estadolotetipoid': estadolotetipoid,
      'latitud': latitud,
      'longitud': longitud,
      'fechacreacion': fechacreacion,
      'fechamodificacion': fechamodificacion,
      'imagenurl': imagenurl,
    };
  }
}