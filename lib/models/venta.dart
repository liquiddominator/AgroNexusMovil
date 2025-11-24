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
      cantidadkg:
          json['cantidadkg'] != null ? (json['cantidadkg'] as num).toDouble() : null,
      preciokg:
          json['preciokg'] != null ? (json['preciokg'] as num).toDouble() : null,
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