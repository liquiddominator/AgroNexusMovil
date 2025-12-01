import '../utils/helpers.dart';

class ProduccionAlmacenamiento {
  final int produccionalmacenamientoid;
  final int produccionid;
  final int almacenid;
  final double cantidad;
  final int? unidadmedidaid;

  // condiciones ambientales
  final double? temperatura;
  final double? humedad;
  final double? temperaturaMin;
  final double? temperaturaMax;
  final double? humedadMin;
  final double? humedadMax;

  final String? fechaentrada;
  final String? fechasalida;
  final String? observaciones;

  ProduccionAlmacenamiento({
    required this.produccionalmacenamientoid,
    required this.produccionid,
    required this.almacenid,
    required this.cantidad,
    this.unidadmedidaid,
    this.temperatura,
    this.humedad,
    this.temperaturaMin,
    this.temperaturaMax,
    this.humedadMin,
    this.humedadMax,
    this.fechaentrada,
    this.fechasalida,
    this.observaciones,
  });

  factory ProduccionAlmacenamiento.fromJson(Map<String, dynamic> json) {
    return ProduccionAlmacenamiento(
      produccionalmacenamientoid: json['produccionalmacenamientoid'],
      produccionid: json['produccionid'],
      almacenid: json['almacenid'],
      cantidad: parseDoubleRequired(json['cantidad']),
      unidadmedidaid: json['unidadmedidaid'],
      temperatura: parseDouble(json['temperatura']),
      humedad: parseDouble(json['humedad']),
      temperaturaMin: parseDouble(json['temperatura_min']),
      temperaturaMax: parseDouble(json['temperatura_max']),
      humedadMin: parseDouble(json['humedad_min']),
      humedadMax: parseDouble(json['humedad_max']),
      fechaentrada: parseFechaFlexible(json['fechaentrada']),
      fechasalida: parseFechaFlexible(json['fechasalida']),
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produccionalmacenamientoid': produccionalmacenamientoid,
      'produccionid': produccionid,
      'almacenid': almacenid,
      'cantidad': cantidad,
      'unidadmedidaid': unidadmedidaid,
      'temperatura': temperatura,
      'humedad': humedad,
      'temperatura_min': temperaturaMin,
      'temperatura_max': temperaturaMax,
      'humedad_min': humedadMin,
      'humedad_max': humedadMax,
      'fechaentrada': fechaentrada,
      'fechasalida': fechasalida,
      'observaciones': observaciones,
    };
  }
}