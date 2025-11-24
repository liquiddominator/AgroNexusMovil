class TipoActividad {
  final int tipoactividadid;
  final String nombre;
  final String? descripcion;

  TipoActividad({
    required this.tipoactividadid,
    required this.nombre,
    this.descripcion,
  });

  factory TipoActividad.fromJson(Map<String, dynamic> json) {
    return TipoActividad(
      tipoactividadid: json['tipoactividadid'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoactividadid': tipoactividadid,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}