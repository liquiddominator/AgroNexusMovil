class DestinoProduccion {
  final int destinoproduccionid;
  final String nombre;

  DestinoProduccion({
    required this.destinoproduccionid,
    required this.nombre,
  });

  factory DestinoProduccion.fromJson(Map<String, dynamic> json) {
    return DestinoProduccion(
      destinoproduccionid: json['destinoproduccionid'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destinoproduccionid': destinoproduccionid,
      'nombre': nombre,
    };
  }
}