import '../utils/helpers.dart';

class LoteInsumo {
  final int loteinsumoid;
  final int loteid;
  final int insumoid;
  final int usuarioid;
  final double cantidadusada;
  final String? fechauo;
  final double? costototal;
  final int? estadoloteinsumoid;
  final String? observaciones;

  LoteInsumo({
    required this.loteinsumoid,
    required this.loteid,
    required this.insumoid,
    required this.usuarioid,
    required this.cantidadusada,
    this.fechauo,
    this.costototal,
    this.estadoloteinsumoid,
    this.observaciones,
  });

  factory LoteInsumo.fromJson(Map<String, dynamic> json) {
    return LoteInsumo(
      loteinsumoid: json['loteinsumoid'],
      loteid: json['loteid'],
      insumoid: json['insumoid'],
      usuarioid: json['usuarioid'],
      cantidadusada: parseDoubleRequired(json['cantidadusada']),
      fechauo: json['fechauo'],
      costototal: parseDouble(json['costototal']),
      estadoloteinsumoid: json['estadoloteinsumoid'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loteinsumoid': loteinsumoid,
      'loteid': loteid,
      'insumoid': insumoid,
      'usuarioid': usuarioid,
      'cantidadusada': cantidadusada,
      'fechauo': fechauo,
      'costototal': costototal,
      'estadoloteinsumoid': estadoloteinsumoid,
      'observaciones': observaciones,
    };
  }
}