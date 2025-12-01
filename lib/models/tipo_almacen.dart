class TipoAlmacen {
  final int tipoalmacenid;
  final String nombre;
  final String? descripcion;

  TipoAlmacen({
    required this.tipoalmacenid,
    required this.nombre,
    this.descripcion,
  });

  factory TipoAlmacen.fromJson(Map<String, dynamic> json) {
    return TipoAlmacen(
      tipoalmacenid: json['tipoalmacenid'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoalmacenid': tipoalmacenid,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}