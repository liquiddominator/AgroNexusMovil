import '../utils/helpers.dart';

class Almacen {
  final int almacenid;
  final String nombre;
  final String? descripcion;
  final String? ubicacion;
  final double? capacidad;
  final int? unidadmedidaid;
  final int? tipoalmacenid;
  final bool activo;

  Almacen({
    required this.almacenid,
    required this.nombre,
    this.descripcion,
    this.ubicacion,
    this.capacidad,
    this.unidadmedidaid,
    this.tipoalmacenid,
    required this.activo,
  });

  factory Almacen.fromJson(Map<String, dynamic> json) {
    return Almacen(
      almacenid: json['almacenid'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      ubicacion: json['ubicacion'],
      capacidad: parseDouble(json['capacidad']),
      unidadmedidaid: json['unidadmedidaid'],
      tipoalmacenid: json['tipoalmacenid'],
      activo: (json['activo'] is bool)
          ? json['activo'] as bool
          : (json['activo'] == 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'almacenid': almacenid,
      'nombre': nombre,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'capacidad': capacidad,
      'unidadmedidaid': unidadmedidaid,
      'tipoalmacenid': tipoalmacenid,
      'activo': activo,
    };
  }
}