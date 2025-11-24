class Cultivo {
  final int cultivoid;
  final String nombre;

  Cultivo({
    required this.cultivoid,
    required this.nombre,
  });

  factory Cultivo.fromJson(Map<String, dynamic> json) => Cultivo(
        cultivoid: json["cultivoid"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "cultivoid": cultivoid,
        "nombre": nombre,
      };
}