class HistorialEstadoLote {
  final int historialEstadoId;
  final int loteid;
  final int estadolotetipoid;
  final String? fechaCambio;
  final String? observaciones;
  final String? imagenurl;
  final int? usuarioid;
  final String? createdAt;
  final String? updatedAt;

  HistorialEstadoLote({
    required this.historialEstadoId,
    required this.loteid,
    required this.estadolotetipoid,
    this.fechaCambio,
    this.observaciones,
    this.imagenurl,
    this.usuarioid,
    this.createdAt,
    this.updatedAt,
  });

  factory HistorialEstadoLote.fromJson(Map<String, dynamic> json) {
    return HistorialEstadoLote(
      historialEstadoId: json['historial_estado_id'],
      loteid: json['loteid'],
      estadolotetipoid: json['estadolotetipoid'],
      fechaCambio: json['fecha_cambio'],
      observaciones: json['observaciones'],
      imagenurl: json['imagenurl'],
      usuarioid: json['usuarioid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'historial_estado_id': historialEstadoId,
      'loteid': loteid,
      'estadolotetipoid': estadolotetipoid,
      'fecha_cambio': fechaCambio,
      'observaciones': observaciones,
      'imagenurl': imagenurl,
      'usuarioid': usuarioid,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}