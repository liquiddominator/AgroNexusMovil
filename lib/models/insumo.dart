class Insumo {
  final int insumoid;
  final String nombre;
  final int tipoinsumoid;
  final int unidadmedidaid;
  final double stock;
  final double stockminimo;
  final String? proveedor;
  final double? preciounitario;
  final String? descripcion;

  Insumo({
    required this.insumoid,
    required this.nombre,
    required this.tipoinsumoid,
    required this.unidadmedidaid,
    required this.stock,
    required this.stockminimo,
    this.proveedor,
    this.preciounitario,
    this.descripcion,
  });

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      insumoid: json['insumoid'],
      nombre: json['nombre'],
      tipoinsumoid: json['tipoinsumoid'],
      unidadmedidaid: json['unidadmedidaid'],
      stock: (json['stock'] as num).toDouble(),
      stockminimo: (json['stockminimo'] as num).toDouble(),
      proveedor: json['proveedor'],
      preciounitario: json['preciounitario'] != null
          ? (json['preciounitario'] as num).toDouble()
          : null,
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insumoid': insumoid,
      'nombre': nombre,
      'tipoinsumoid': tipoinsumoid,
      'unidadmedidaid': unidadmedidaid,
      'stock': stock,
      'stockminimo': stockminimo,
      'proveedor': proveedor,
      'preciounitario': preciounitario,
      'descripcion': descripcion,
    };
  }
}