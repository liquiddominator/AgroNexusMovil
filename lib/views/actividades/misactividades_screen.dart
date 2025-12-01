import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/models/actividad.dart';
import 'package:agro_nexus_movil/widgets/actividades/actividad_card.dart';
import 'package:agro_nexus_movil/widgets/actividades/actividad_stat_card.dart';
import 'package:agro_nexus_movil/widgets/actividades/boton_nuevaactividad.dart';
import 'package:agro_nexus_movil/widgets/actividades/filtros_actividades.dart';
import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';

class MisActividadesContent extends StatefulWidget {
  const MisActividadesContent({super.key});

  @override
  State<MisActividadesContent> createState() => _MisActividadesContentState();
}

class _MisActividadesContentState extends State<MisActividadesContent> {
  final ActividadController _actividadController = ActividadController();
  final CatalogosController _catalogosController = CatalogosController();
  final LoteController _loteController = LoteController();

  bool loading = true;

  int alta = 0;
  int media = 0;
  int baja = 0;

  // 🎯 Filtros reales desde catálogo
  String filtroTipo = "Todos";
  String filtroPrioridad = "Todas";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = authController.token;
    final usuario = authController.usuario;

    if (token == null || usuario == null) return;

    // 🔹 Cargar actividades y catálogos en paralelo
    await Future.wait([
      _actividadController.cargarActividades(token),
      _catalogosController.cargarCatalogos(token),
      _loteController.cargarLotes(token),
    ]);

    final actividades = _actividadController.actividades;
    final userId = usuario.usuarioid;

    final actividadesUsuario =
        actividades.where((a) => a.usuarioid == userId).toList();

    setState(() {
      alta = actividadesUsuario.where((a) => a.prioridadid == 1).length;
      media = actividadesUsuario.where((a) => a.prioridadid == 2).length;
      baja = actividadesUsuario.where((a) => a.prioridadid == 3).length;
      loading = false;
    });
  }

  // ====================================================
  // LISTADO DE ACTIVIDADES con filtros reales
  // ====================================================
  Widget _buildListadoActividades() {
    final userId = authController.usuario!.usuarioid;

    List<Actividad> actividades =
        _actividadController.actividades.where((a) => a.usuarioid == userId).toList();

    // 🔹 Filtro por tipo actividad
    if (filtroTipo != "Todos") {
      final tipo = _catalogosController.tipoActividades
          .firstWhere((t) => t.nombre == filtroTipo);
      actividades = actividades.where((a) => a.tipoactividadid == tipo.tipoactividadid).toList();
    }

    // 🔹 Filtro por prioridad
    if (filtroPrioridad != "Todas") {
      final prioridad = _catalogosController.prioridades
          .firstWhere((p) => p.nombre.toLowerCase() == filtroPrioridad.toLowerCase());
      actividades = actividades.where((a) => a.prioridadid == prioridad.prioridadid).toList();
    }

    if (actividades.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Text("No hay actividades", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: actividades.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        final item = actividades[i];

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ActividadItem(
            actividad: item,
            loteNombre: (() {
              for (final lote in _loteController.lotes) {
                if (lote.loteid == item.loteid) {
                  return lote.nombre;
                }
              }
              return "Lote ${item.loteid}";
            })(),
            onDeleted: (mensaje) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(mensaje)),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    // ==========================
    // Opciones dinámicas
    // ==========================
    final opcionesTipo = ["Todos", ..._catalogosController.tipoActividades.map((x) => x.nombre)];
    final opcionesPrioridad = ["Todas", ..._catalogosController.prioridades.map((x) => x.nombre)];

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
          setState(() {}); // refrescar UI
        },
        color: const Color(0xFF1B5E20),
        backgroundColor: Colors.white,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ==========================
              //  CARDS DE ESTADÍSTICAS
              // ==========================
              ActividadCard(count: alta, label: 'PRIORIDAD ALTA', color: const Color(0xFFD32F2F)),
              const SizedBox(height: 16),

              ActividadCard(count: media, label: 'PRIORIDAD MEDIA', color: const Color(0xFFF4B400)),
              const SizedBox(height: 16),

              ActividadCard(count: baja, label: 'PRIORIDAD BAJA', color: const Color(0xFF388E3C)),
              const SizedBox(height: 25),

              // ==========================
              //  FILTRO POR TIPO ACTIVIDAD
              // ==========================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Tipo de Actividad", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),

              FiltroChipSelector(
                opciones: opcionesTipo,
                valorActual: filtroTipo,
                onChanged: (value) => setState(() => filtroTipo = value),
              ),

              const SizedBox(height: 20),

              // ==========================
              //  FILTRO POR PRIORIDAD
              // ==========================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Prioridad", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),

              FiltroChipSelector(
                opciones: opcionesPrioridad,
                valorActual: filtroPrioridad,
                onChanged: (value) => setState(() => filtroPrioridad = value),
              ),

              const SizedBox(height: 20),

              buildBotonNuevaActividad(context),

              const SizedBox(height: 20),

              _buildListadoActividades(),
            ],
          ),
        ),
      ),
    );
  }
}