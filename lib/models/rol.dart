class Rol {
  final int rolid;
  final String nombre;
  final String? descripcion;

  Rol({
    required this.rolid,
    required this.nombre,
    this.descripcion,
  });

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        rolid: json["rolid"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "rolid": rolid,
        "nombre": nombre,
        "descripcion": descripcion,
      };
}