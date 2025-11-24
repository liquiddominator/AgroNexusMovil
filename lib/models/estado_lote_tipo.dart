class EstadoLoteTipo {
  final int estadolotetipoid;
  final String nombre;
  final String? descripcion;

  EstadoLoteTipo({
    required this.estadolotetipoid,
    required this.nombre,
    this.descripcion,
  });

  factory EstadoLoteTipo.fromJson(Map<String, dynamic> json) {
    return EstadoLoteTipo(
      estadolotetipoid: json['estadolotetipoid'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estadolotetipoid': estadolotetipoid,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}