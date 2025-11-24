class UsuarioRol {
  final int usuariorolid;
  final int usuarioid;
  final int rolid;

  UsuarioRol({
    required this.usuariorolid,
    required this.usuarioid,
    required this.rolid,
  });

  factory UsuarioRol.fromJson(Map<String, dynamic> json) => UsuarioRol(
        usuariorolid: json["usuariorolid"],
        usuarioid: json["usuarioid"],
        rolid: json["rolid"],
      );

  Map<String, dynamic> toJson() => {
        "usuariorolid": usuariorolid,
        "usuarioid": usuarioid,
        "rolid": rolid,
      };
}