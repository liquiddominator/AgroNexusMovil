class Clima {
  final int climaid;
  final int loteid;
  final String? fecha;
  final double? temperatura;
  final double? humedad;
  final double? lluvia;
  final String? observaciones;

  Clima({
    required this.climaid,
    required this.loteid,
    this.fecha,
    this.temperatura,
    this.humedad,
    this.lluvia,
    this.observaciones,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      climaid: json['climaid'],
      loteid: json['loteid'],
      fecha: json['fecha'],
      temperatura: json['temperatura'] != null
          ? (json['temperatura'] as num).toDouble()
          : null,
      humedad: json['humedad'] != null
          ? (json['humedad'] as num).toDouble()
          : null,
      lluvia: json['lluvia'] != null
          ? (json['lluvia'] as num).toDouble()
          : null,
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'climaid': climaid,
      'loteid': loteid,
      'fecha': fecha,
      'temperatura': temperatura,
      'humedad': humedad,
      'lluvia': lluvia,
      'observaciones': observaciones,
    };
  }
}