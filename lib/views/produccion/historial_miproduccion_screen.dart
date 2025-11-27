import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';
import 'package:agro_nexus_movil/widgets/produccion/filtros_botones.dart';
import 'package:agro_nexus_movil/widgets/produccion/mes_produccion.dart';
import 'package:agro_nexus_movil/widgets/produccion/produccion_card.dart';
import 'package:agro_nexus_movil/widgets/produccion/ultimos6meses_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/produccion_controller.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/models/produccion.dart';
import 'package:agro_nexus_movil/widgets/inicio/stadisticas_cards.dart';
import 'package:agro_nexus_movil/views/produccion/registrar_produccion_screen.dart';

class MiHistorialProduccionContent extends StatefulWidget {
  const MiHistorialProduccionContent({super.key});

  @override
  State<MiHistorialProduccionContent> createState() =>
      _MiHistorialProduccionContentState();
}

class _MiHistorialProduccionContentState
    extends State<MiHistorialProduccionContent> {
  final _loteController = LoteController();
  final _produccionController = ProduccionController();
  final _catalogosController = CatalogosController();

  bool _loading = true;
  String? _error;

  double _produccionTotalKg = 0;
  double _produccionMesActualKg = 0;
  double _promedioMesKg = 0;
  int _totalRegistros = 0;

  List<Produccion> _produccionesUsuario = [];
  List<MesProduccion> _last6Months = [];

  // Mapa para obtener rápido el nombre del lote
  Map<int, Lote> _lotesPorId = {};
  Map<int, String> _destinosPorId = {};
  Map<int, String> _cultivosPorId = {};

  // filtro seleccionado
  String _filtroSeleccionado = 'todos'; // 'todos' | 'mes'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = authController.token;
    final usuario = authController.usuario;

    if (token == null || usuario == null) {
      setState(() {
        _loading = false;
        _error = 'No hay sesión activa.';
      });
      return;
    }

    try {
      await Future.wait([
        _loteController.cargarLotes(token),
        _produccionController.cargarProducciones(token),
        _catalogosController.cargarCatalogos(token),
      ]);

      final userId = usuario.usuarioid;
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      // LOTES DEL USUARIO
      final List<Lote> lotesUsuario = _loteController.lotes
          .where((l) => l.usuarioid == userId)
          .toList();
      final userLoteIds = lotesUsuario.map((l) => l.loteid).toSet();

      _lotesPorId = {
        for (final l in lotesUsuario) l.loteid: l,
      };

      // PRODUCCIONES DEL USUARIO
      final produccionesUsuario = _produccionController.producciones
          .where((p) => userLoteIds.contains(p.loteid))
          .toList();

      _produccionesUsuario = produccionesUsuario;
      _totalRegistros = produccionesUsuario.length;

      // PRODUCCIÓN TOTAL
      _produccionTotalKg = produccionesUsuario.fold(
        0,
        (sum, p) => sum + (p.cantidadkg ?? 0),
      );

      // PRODUCCIÓN DEL MES ACTUAL
      _produccionMesActualKg = produccionesUsuario
          .where((p) {
            if (p.fechacosecha == null) return false;
            final fecha = DateTime.tryParse(p.fechacosecha!);
            return fecha != null &&
                fecha.month == currentMonth &&
                fecha.year == currentYear;
          })
          .fold(0, (sum, p) => sum + (p.cantidadkg ?? 0));

      // PROMEDIO POR MES (según meses donde hubo registros)
      final mesesConProduccion = <String>{};

      for (final p in produccionesUsuario) {
        if (p.fechacosecha == null) continue;
        final fecha = DateTime.tryParse(p.fechacosecha!);
        if (fecha == null) continue;
        final key = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';
        mesesConProduccion.add(key);
      }

      if (mesesConProduccion.isNotEmpty) {
        _promedioMesKg =
            _produccionTotalKg / mesesConProduccion.length.toDouble();
      } else {
        _promedioMesKg = 0;
      }

      // ================== ÚLTIMOS 6 MESES ==================
      final List<MesProduccion> last6 = [];
      for (int i = 5; i >= 0; i--) {
        final date = DateTime(currentYear, currentMonth - i, 1);
        final month = date.month;
        final year = date.year;

        final totalMes = produccionesUsuario
            .where((p) {
              if (p.fechacosecha == null) return false;
              final fecha = DateTime.tryParse(p.fechacosecha!);
              return fecha != null &&
                  fecha.month == month &&
                  fecha.year == year;
            })
            .fold(0.0, (sum, p) => sum + (p.cantidadkg ?? 0));

        final label =
            DateFormat.MMM('es_BO').format(date); // ej. May, Jun, Ago
        last6.add(
          MesProduccion(
            label: label,
            totalKg: totalMes,
          ),
        );
      }

      _last6Months = last6;

            // Mapa de destinos de producción (id -> nombre)
      _destinosPorId = {
        for (final d in _catalogosController.destinoProducciones)
          d.destinoproduccionid!: d.nombre,
      };

      // Mapa de cultivos (id -> nombre)
      _cultivosPorId = {
        for (final c in _catalogosController.cultivos)
          c.cultivoid!: c.nombre,
      };

      setState(() {
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Error al cargar historial de producción: $e';
      });
    }
  }

  // ------------ helpers para la lista ------------

  List<Produccion> _produccionesFiltradas() {
    final now = DateTime.now();

    List<Produccion> lista = _produccionesUsuario;

    if (_filtroSeleccionado == 'mes') {
      lista = lista.where((p) {
        if (p.fechacosecha == null) return false;
        final f = DateTime.tryParse(p.fechacosecha!);
        return f != null && f.month == now.month && f.year == now.year;
      }).toList();
    } else {
      lista = List.from(lista);
    }

    // ordenar por fecha de cosecha descendente
    lista.sort((a, b) {
      final fa = DateTime.tryParse(a.fechacosecha ?? '');
      final fb = DateTime.tryParse(b.fechacosecha ?? '');
      if (fa == null && fb == null) return 0;
      if (fa == null) return 1;
      if (fb == null) return -1;
      return fb.compareTo(fa);
    });

    return lista;
  }

  String _formateaFecha(String? iso) {
    if (iso == null) return '-';
    final fecha = DateTime.tryParse(iso);
    if (fecha == null) return '-';
    return DateFormat("d 'de' MMMM, yyyy", 'es_BO').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('es_BO');

    final produccionesMostrar = _produccionesFiltradas();

    return SizedBox.expand(
      child: Container(
        color: const Color(0xFFEEEEEE),
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Historial de Producción',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Resumen de tu producción registrada',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                if (_loading) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (_error != null) ...[
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ] else ...[
                  DashboardStatCard(
                    icon: Icons.eco,
                    iconBgColor: const Color(0xFF2ECC71),
                    title: 'Producción Total',
                    value: numberFormatter.format(_produccionTotalKg),
                  ),
                  const SizedBox(height: 12),

                  DashboardStatCard(
                    icon: Icons.calendar_today,
                    iconBgColor: const Color(0xFF1ABC9C),
                    title: 'Este Mes',
                    value: numberFormatter.format(_produccionMesActualKg),
                  ),
                  const SizedBox(height: 12),

                  DashboardStatCard(
                    icon: Icons.show_chart,
                    iconBgColor: const Color(0xFFF1C40F),
                    title: 'Promedio/Mes',
                    value: numberFormatter.format(_promedioMesKg),
                  ),
                  const SizedBox(height: 12),

                  DashboardStatCard(
                    icon: Icons.assignment,
                    iconBgColor: const Color(0xFF9B59B6),
                    title: 'Registros',
                    value: numberFormatter.format(_totalRegistros),
                  ),
                  const SizedBox(height: 24),

                  // ======= CARD: PRODUCCIÓN ÚLTIMOS 6 MESES =======
                  buildLast6MonthsCard(
                    numberFormatter: numberFormatter,
                    last6Months: _last6Months,
                  ),
                  const SizedBox(height: 24),

                  // ========= FILTROS "TODOS" / "ESTE MES" =========
                  Row(
                    children: [
                      FiltroChip(
                        icon: Icons.list,
                        label: 'Todos',
                        seleccionado: _filtroSeleccionado == 'todos',
                        onTap: () {
                          setState(() {
                            _filtroSeleccionado = 'todos';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FiltroChip(
                        icon: Icons.calendar_today_outlined,
                        label: 'Este Mes',
                        seleccionado: _filtroSeleccionado == 'mes',
                        onTap: () {
                          setState(() {
                            _filtroSeleccionado = 'mes';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ========= BOTÓN VERDE "+ REGISTRAR" =========
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegistrarProduccionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Registrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ============ LISTA DE PRODUCCIONES ============
                  if (produccionesMostrar.isEmpty)
                    const Text(
                      'No hay producciones para este filtro.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: produccionesMostrar.length,
                      itemBuilder: (context, index) {
                        final prod = produccionesMostrar[index];
                        final lote = _lotesPorId[prod.loteid];
                        final loteNombreBase = lote?.nombre ?? 'Lote';

                        // nombre de cultivo (si existe)
                        String cultivoNombre = '';
                        if (lote != null && lote.cultivoid != null) {
                          cultivoNombre = _cultivosPorId[lote.cultivoid!] ?? '';
                        }

                        // título que se mostrará: "Lote Norte - Maíz"
                        final loteTitulo = cultivoNombre.isEmpty
                            ? loteNombreBase
                            : '$loteNombreBase - $cultivoNombre';

                        final destino = prod.destinoproduccionid != null
                            ? (_destinosPorId[prod.destinoproduccionid!] ?? 'Sin destino')
                            : 'Sin destino';
                        final fecha = _formateaFecha(prod.fechacosecha);
                        final cantidad = prod.cantidadkg ?? 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProduccionCard(
                            loteNombre: loteTitulo,
                            fechaCosecha: fecha,
                            destino: destino,
                            cantidadKg: cantidad,
                          ),
                        );
                      },
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}