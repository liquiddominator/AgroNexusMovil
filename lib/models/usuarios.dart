class Usuario {
  final int usuarioid;
  final String nombre;
  final String apellido;
  final String email;
  final String nombreusuario;
  final String? telefono;
  final String? imagenurl;              // sigue siendo nullable
  final String? informacionadicional;
  final String fecharegistro;
  final String? fechamodificacion;
  final String? ultimologin;
  final bool activo;

  // URL por defecto para avatar
  static const String defaultAvatarUrl =
      'https://bsmobatqfjmrfiipkimu.supabase.co/storage/v1/object/public/agronexus-bucket/usuarios/userDefault.png';

  Usuario({
    required this.usuarioid,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.nombreusuario,
    this.telefono,
    this.imagenurl,
    this.informacionadicional,
    required this.fecharegistro,
    this.fechamodificacion,
    this.ultimologin,
    required this.activo,
  });

  // ✅ Constructor robusto: convierte nulls a valores seguros
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        usuarioid: json["usuarioid"] as int,
        nombre: (json["nombre"] ?? "") as String,
        apellido: (json["apellido"] ?? "") as String,
        email: (json["email"] ?? "") as String,
        nombreusuario: (json["nombreusuario"] ?? "") as String,
        telefono: json["telefono"]?.toString(),
        // si viene null, usa la imagen por defecto
        imagenurl: (json["imagenurl"] ?? defaultAvatarUrl) as String,
        informacionadicional: json["informacionadicional"] as String?,
        // si POR ALGÚN MOTIVO viene null, evita el crash
        fecharegistro: (json["fecharegistro"] ?? "") as String,
        fechamodificacion: json["fechamodificacion"] as String?,
        ultimologin: json["ultimologin"] as String?,
        // puede venir true/false o 1/0
        activo: (json["activo"] is bool)
            ? json["activo"] as bool
            : (json["activo"] == 1),
      );

  Map<String, dynamic> toJson() => {
        "usuarioid": usuarioid,
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "nombreusuario": nombreusuario,
        "telefono": telefono,
        "imagenurl": imagenurl,
        "informacionadicional": informacionadicional,
        "fecharegistro": fecharegistro,
        "fechamodificacion": fechamodificacion,
        "ultimologin": ultimologin,
        "activo": activo,
      };

  // 👇 Getter cómodo para usar siempre en los widgets
  String get avatarUrl => imagenurl ?? defaultAvatarUrl;
}