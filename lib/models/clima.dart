import '../utils/helpers.dart';

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
      temperatura: parseDouble(json['temperatura']),
      humedad: parseDouble(json['humedad']),
      lluvia: parseDouble(json['lluvia']),
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