class EstadoLoteInsumo {
  final int estadoloteinsumoid;
  final String nombre;

  EstadoLoteInsumo({
    required this.estadoloteinsumoid,
    required this.nombre,
  });

  factory EstadoLoteInsumo.fromJson(Map<String, dynamic> json) {
    return EstadoLoteInsumo(
      estadoloteinsumoid: json['estadoloteinsumoid'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estadoloteinsumoid': estadoloteinsumoid,
      'nombre': nombre,
    };
  }
}