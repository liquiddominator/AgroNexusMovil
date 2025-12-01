import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/models/actividad.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActividadItem extends StatelessWidget {
  final Actividad actividad;
  final void Function(String mensaje) onDeleted;
  final String loteNombre;

  const ActividadItem({
    super.key,
    required this.actividad,
    required this.onDeleted,
    required this.loteNombre,
  });

  @override
  Widget build(BuildContext context) {
    final prioridadNombre = getPrioridadNombre(actividad.prioridadid);
    final prioridadColor = getPrioridadColor(actividad.prioridadid);

    final tipoNombre = getNombreTipoActividad(actividad.tipoactividadid);
    final tipoColor = getColorTipoActividad(actividad.tipoactividadid);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // -------------------------
          // HEADER
          // -------------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle_outlined, size: 22, color: Colors.grey),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo actividad chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tipoColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          tipoNombre,
                          style: TextStyle(
                            fontSize: 12,
                            color: tipoColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        actividad.descripcion,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),

                          /// 🔥 Mostramos el nombre del lote, no el ID
                          Text(
                            loteNombre,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // -------------------------
          // PRIORIDAD
          // -------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PRIORIDAD",
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                _ChipEstado(nombre: prioridadNombre, color: prioridadColor),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // -------------------------
          // FECHA + ACCIONES
          // -------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 6),
                Text(
                  buildFechaTexto(),
                  style: const TextStyle(fontSize: 14),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () => _confirmarEliminar(context),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade700,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONFIRMAR ELIMINACIÓN
  // ============================================================
  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Eliminar Actividad"),
          content: const Text("¿Seguro que deseas eliminar esta actividad?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.pop(ctx);
                await _eliminar();
              },
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ELIMINAR ACTIVIDAD
  // ============================================================
  Future<void> _eliminar() async {
    final token = authController.token;
    if (token == null) return;

    final controller = ActividadController();
    final ok = await controller.eliminarActividad(actividad.actividadid, token);

    if (ok) {
      onDeleted("Actividad eliminada");
    } else {
      onDeleted("Error: ${controller.errorMessage}");
    }
  }

  // ============================================================
  // FORMATO DE FECHA
  // ============================================================
  String buildFechaTexto() {
    if (actividad.fechainicio == null) return "Sin fecha";

    final inicio = DateTime.tryParse(actividad.fechainicio!);
    final fin = actividad.fechafin != null ? DateTime.tryParse(actividad.fechafin!) : null;

    if (inicio == null) return "Sin fecha";

    final formatoDia = DateFormat("d MMM", "es");
    final formatoHora = DateFormat("HH:mm", "es");

    if (fin == null) {
      return formatoDia.format(inicio);
    }

    final mismoDia = inicio.year == fin.year &&
        inicio.month == fin.month &&
        inicio.day == fin.day;

    if (mismoDia) {
      final fecha = formatoDia.format(inicio);
      final horaInicio = formatoHora.format(inicio);
      final horaFin = formatoHora.format(fin);
      return "$fecha · $horaInicio - $horaFin";
    }

    return "${formatoDia.format(inicio)} - ${formatoDia.format(fin)}";
  }
}

///////////////////////////////////////////////////////////////////////
// HELPERS
///////////////////////////////////////////////////////////////////////

String getPrioridadNombre(int id) {
  switch (id) {
    case 1:
      return "Alta";
    case 2:
      return "Media";
    case 3:
      return "Baja";
    default:
      return "N/A";
  }
}

Color getPrioridadColor(int id) {
  switch (id) {
    case 1:
      return const Color(0xFFD32F2F);
    case 2:
      return const Color(0xFFF4B400);
    case 3:
      return const Color(0xFF388E3C);
    default:
      return Colors.grey;
  }
}

String getNombreTipoActividad(int id) {
  switch (id) {
    case 1:
      return "Siembra";
    case 2:
      return "Riego";
    case 3:
      return "Fumigación";
    case 4:
      return "Cosecha";
    case 5:
      return "Labranza";
    default:
      return "Actividad";
  }
}

Color getColorTipoActividad(int id) {
  switch (id) {
    case 1:
      return const Color(0xFF4CAF50);
    case 2:
      return const Color(0xFF2196F3);
    case 3:
      return const Color(0xFFE53935);
    case 4:
      return const Color(0xFFFFB300);
    case 5:
      return const Color(0xFF6D4C41);
    default:
      return Colors.grey;
  }
}

///////////////////////////////////////////////////////////////////////
class _ChipEstado extends StatelessWidget {
  final String nombre;
  final Color color;

  const _ChipEstado({required this.nombre, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        nombre,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}