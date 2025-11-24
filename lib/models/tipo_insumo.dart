class TipoInsumo {
  final int tipoinsumoid;
  final String nombre;

  TipoInsumo({
    required this.tipoinsumoid,
    required this.nombre,
  });

  factory TipoInsumo.fromJson(Map<String, dynamic> json) {
    return TipoInsumo(
      tipoinsumoid: json['tipoinsumoid'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoinsumoid': tipoinsumoid,
      'nombre': nombre,
    };
  }
}