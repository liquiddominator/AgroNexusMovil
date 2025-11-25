class ApiConstants {
  /// Base URL para el EMULADOR ANDROID (apunta al localhost de tu PC)
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  // ======================================================
  // Helper para construir URLs completas
  // ======================================================
  static String url(String endpoint) => '$baseUrl$endpoint';

  // ======================================================
  // AUTH
  // ======================================================
  static const String authRegister = 'register';
  static const String authLogin = 'login';
  static const String authMe = 'me';
  static const String authLogout = 'logout';

  // ======================================================
  // CATÁLOGOS
  // (apiResource en api.php)
  // ======================================================
  static const String tipoActividades = 'tipoactividades';
  static const String prioridades = 'prioridades';
  static const String tipoInsumos = 'tipoinsumos';
  static const String unidadesMedida = 'unidadesmedida';
  static const String cultivos = 'cultivos';
  static const String estadoLoteTipos = 'estadolote-tipos';
  static const String destinoProducciones = 'destinoproducciones';
  static const String estadoLoteInsumos = 'estadolote-insumos';

  // ======================================================
  // USUARIOS Y ROLES
  // ======================================================
  static const String roles = 'roles';
  static const String usuarios = 'usuarios';
  static const String usuarioRoles = 'usuario-roles';

  // ======================================================
  // LOTES Y PRODUCCIÓN
  // ======================================================
  static const String lotes = 'lotes';
  static const String estadoLotes = 'estadolotes';
  static const String producciones = 'producciones';
  static const String historialEstadosLote = 'historial-estados-lote';

  // ======================================================
  // INSUMOS Y APLICACIONES
  // ======================================================
  static const String insumos = 'insumos';
  static const String loteInsumos = 'lote-insumos';

  // ======================================================
  // ACTIVIDADES
  // ======================================================
  static const String actividades = 'actividades';

  // ======================================================
  // CLIMA
  // ======================================================
  static const String climas = 'climas';

  // ======================================================
  // VENTAS
  // ======================================================
  static const String ventas = 'ventas';

  // ======================================================
  // API EXTERNA DE CLIMA
  // ======================================================
  static const String externalWeatherBase =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String weatherApiKey = '740702a07c32f0410a7c6b869f1d1608';
}