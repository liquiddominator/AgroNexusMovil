class UnidadMedida {
  final int unidadmedidaid;
  final String nombre;

  UnidadMedida({
    required this.unidadmedidaid,
    required this.nombre,
  });

  factory UnidadMedida.fromJson(Map<String, dynamic> json) {
    return UnidadMedida(
      unidadmedidaid: json['unidadmedidaid'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unidadmedidaid': unidadmedidaid,
      'nombre': nombre,
    };
  }
}