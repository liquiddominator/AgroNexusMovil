class Prioridad {
  final int prioridadid;
  final String nombre;

  Prioridad({
    required this.prioridadid,
    required this.nombre,
  });

  factory Prioridad.fromJson(Map<String, dynamic> json) {
    return Prioridad(
      prioridadid: json['prioridadid'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prioridadid': prioridadid,
      'nombre': nombre,
    };
  }
}