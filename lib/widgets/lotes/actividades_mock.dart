import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/models/tipo_actividad.dart';
import 'package:agro_nexus_movil/views/actividades/registrar_actividad_screen.dart';
import 'package:agro_nexus_movil/widgets/lotes/lote_tabs_navigator.dart';
import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';
import 'package:agro_nexus_movil/models/actividad.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActividadesMock extends StatefulWidget {
  final Lote lote;

  const ActividadesMock({
    super.key,
    required this.lote,
  });

  @override
  State<ActividadesMock> createState() => _ActividadesMockState();
}

class _ActividadesMockState extends State<ActividadesMock> {
  final actividadController = ActividadController();
  final catalogos = catalogosController; // global
  List<Actividad> actividades = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = authController.token;
    if (token == null) return;

    await actividadController.cargarActividades(token);

    setState(() {
      actividades = actividadController.actividades
          .where((a) => a.loteid == widget.lote.loteid)
          .where((a) => a.fechafin != null) // solo finalizadas
          .toList()
        ..sort(
          (a, b) =>
              DateTime.parse(b.fechafin!).compareTo(DateTime.parse(a.fechafin!)),
        );

      loading = false;
    });
  }

  // ───────────────────────────────────────────────
  // OBTENER NOMBRE DEL TIPO DE ACTIVIDAD
  // ───────────────────────────────────────────────
  String _nombreTipoActividad(int id) {
    final tipo = catalogos.tipoActividades.firstWhere(
      (t) => t.tipoactividadid == id,
      orElse: () => TipoActividad(
        tipoactividadid: 0,
        nombre: "Actividad",
        descripcion: null,
      ),
    );
    return tipo.nombre;
  }

  // ───────────────────────────────────────────────
  // TEXTO DE FECHA RELATIVA
  // ───────────────────────────────────────────────
  String _tiempoRelativo(String fechaISO) {
    final fecha = DateTime.parse(fechaISO);
    timeago.setLocaleMessages('es', timeago.EsMessages());
    return timeago.format(fecha, locale: 'es');
  }

  // ───────────────────────────────────────────────
  // ITEM DEL TIMELINE
  // ───────────────────────────────────────────────
  Widget _timelineItem({
    required String tiempo,
    required String titulo,
    required String descripcion,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLUMNA IZQUIERDA → Línea + Punto
          Column(
            children: [
              Container(
                width: 2,
                height: 8,
                color: const Color(0xFF1B5E20),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF1B5E20), width: 2),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: showDivider ? 60 : 0,
                color: Colors.grey.shade300,
              ),
            ],
          ),

          const SizedBox(width: 16),

          // COLUMNA DERECHA → Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tiempo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (showDivider) ...[
                  const SizedBox(height: 14),
                  Divider(color: Colors.grey.shade300),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // BOTÓN
  // ───────────────────────────────────────────────
  Widget _button(
    String text, {
    bool primary = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? const Color(0xFF1B5E20) : Colors.white,
          foregroundColor: primary ? Colors.white : Colors.black87,
          elevation: primary ? 2 : 0,
          side: primary ? BorderSide.none : const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: primary ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // WIDGET PRINCIPAL
  // ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (actividades.isEmpty) {
      return mockContainer("No hay actividades finalizadas.");
    }

    return Column(
      children: [
        // CONTENEDOR PRINCIPAL
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                offset: Offset(0, 2),
                color: Color(0x14000000),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.history,
                      size: 20, color: Color(0xFF1B5E20)),
                  SizedBox(width: 8),
                  Text(
                    "Historial de Actividades",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(),

              for (int i = 0; i < actividades.length; i++)
                _timelineItem(
                  tiempo: _tiempoRelativo(actividades[i].fechafin!),
                  titulo: _nombreTipoActividad(actividades[i].tipoactividadid),
                  descripcion: actividades[i].descripcion,
                  showDivider: i != actividades.length - 1,
                ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        _button(
          "Registrar Actividad",
          primary: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegistrarActividadScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}