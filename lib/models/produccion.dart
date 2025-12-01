import '../utils/helpers.dart';

class Produccion {
  final int produccionid;
  final int loteid;
  final double? cantidadkg;
  final int? unidadmedidaid;
  final String? fechacosecha;
  final int? destinoproduccionid;
  final String? imagenurl;
  final String? observaciones;

  Produccion({
    required this.produccionid,
    required this.loteid,
    this.cantidadkg,
    this.unidadmedidaid,
    this.fechacosecha,
    this.destinoproduccionid,
    this.imagenurl,
    this.observaciones,
  });

  factory Produccion.fromJson(Map<String, dynamic> json) {
    return Produccion(
      produccionid: json['produccionid'],
      loteid: json['loteid'],
      cantidadkg: parseDouble(json['cantidadkg']),
      unidadmedidaid: json['unidadmedidaid'],
      fechacosecha: parseFechaFlexible(json['fechacosecha']),
      destinoproduccionid: json['destinoproduccionid'],
      imagenurl: json['imagenurl']?.toString(),
      observaciones: json['observaciones']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produccionid': produccionid,
      'loteid': loteid,
      'cantidadkg': cantidadkg,
      'unidadmedidaid': unidadmedidaid,
      'fechacosecha': fechacosecha,
      'destinoproduccionid': destinoproduccionid,
      'imagenurl': imagenurl,
      'observaciones': observaciones,
    };
  }
}