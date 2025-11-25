import '../utils/helpers.dart';

class Venta {
  final int ventaid;
  final int produccionid;
  final String? cliente;
  final double? cantidadkg;
  final double? preciokg;
  final String? fechaventa;
  final String? observaciones;

  Venta({
    required this.ventaid,
    required this.produccionid,
    this.cliente,
    this.cantidadkg,
    this.preciokg,
    this.fechaventa,
    this.observaciones,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      ventaid: json['ventaid'],
      produccionid: json['produccionid'],
      cliente: json['cliente'],
      cantidadkg: parseDouble(json['cantidadkg']),
      preciokg: parseDouble(json['preciokg']),
      fechaventa: json['fechaventa'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaid': ventaid,
      'produccionid': produccionid,
      'cliente': cliente,
      'cantidadkg': cantidadkg,
      'preciokg': preciokg,
      'fechaventa': fechaventa,
      'observaciones': observaciones,
    };
  }
}