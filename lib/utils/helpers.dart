// /utils/helpers.dart

/// Convierte dinámicos a double?
/// Soporta num, String o null.
double? parseDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

/// Convierte dinámicos a double obligatorio.
/// Si no puede convertir, devuelve 0.
double parseDoubleRequired(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

/// Convierte dinámicos a int? desde num o string.
int? parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

/// Convierte dinámicos a int requerido.
/// Si no puede convertir, devuelve 0.
int parseIntRequired(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

/// Convierte dinámicos a bool? (acepta true/false, "1"/"0", 1/0)
bool? parseBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v == 1;
  if (v is String) {
    if (v == "1") return true;
    if (v == "0") return false;
    if (v.toLowerCase() == "true") return true;
    if (v.toLowerCase() == "false") return false;
  }
  return null;
}