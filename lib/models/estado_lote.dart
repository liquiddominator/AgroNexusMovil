class EstadoLote {
  final int estadoid;
  final int loteid;
  final int estadolotetipoid;
  final String? fecharegistro;
  final String? observaciones;
  final String? imagenurl;

  EstadoLote({
    required this.estadoid,
    required this.loteid,
    required this.estadolotetipoid,
    this.fecharegistro,
    this.observaciones,
    this.imagenurl,
  });

  factory EstadoLote.fromJson(Map<String, dynamic> json) {
    return EstadoLote(
      estadoid: json['estadoid'],
      loteid: json['loteid'],
      estadolotetipoid: json['estadolotetipoid'],
      fecharegistro: json['fecharegistro'],
      observaciones: json['observaciones'],
      imagenurl: json['imagenurl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estadoid': estadoid,
      'loteid': loteid,
      'estadolotetipoid': estadolotetipoid,
      'fecharegistro': fecharegistro,
      'observaciones': observaciones,
      'imagenurl': imagenurl,
    };
  }
}