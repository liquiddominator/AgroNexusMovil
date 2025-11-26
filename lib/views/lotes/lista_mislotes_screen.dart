import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';
import 'package:agro_nexus_movil/models/estado_lote_tipo.dart';
import 'package:agro_nexus_movil/views/lotes/detalle_lote_screen.dart';
import 'package:agro_nexus_movil/views/lotes/mapa_lotes_screen.dart';
import 'package:agro_nexus_movil/views/lotes/registrar_lote_screen.dart';
import 'package:agro_nexus_movil/widgets/lotes/lote_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/produccion_controller.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/models/produccion.dart';

class MiListaLotesContent extends StatefulWidget {
  const MiListaLotesContent({super.key});

  @override
  State<MiListaLotesContent> createState() => _MiListaLotesContentState();
}

class _MiListaLotesContentState extends State<MiListaLotesContent> {
  final _loteController = LoteController();
  final _produccionController = ProduccionController();
  final catalogosController = CatalogosController();

  bool _loading = true;
  String? _error;
  String _search = '';

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
        catalogosController.cargarCatalogos(token)
      ]);

      setState(() {
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Error al cargar lotes: $e';
      });
    }
  }

  List<Lote> _lotesFiltrados() {
    final usuario = authController.usuario;
    if (usuario == null) return [];

    final query = _search.toLowerCase();

    return _loteController.lotes
        .where((l) => l.usuarioid == usuario.usuarioid)
        .where((l) {
          if (query.isEmpty) return true;
          return l.nombre.toLowerCase().contains(query) ||
              (l.ubicacion ?? '').toLowerCase().contains(query);
        })
        .toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
  }

  double _produccionTotalLote(int loteId) {
    final List<Produccion> producciones = _produccionController.producciones
        .where((p) => p.loteid == loteId)
        .toList();

    return producciones.fold(
      0,
      (sum, p) => sum + (p.cantidadkg ?? 0),
    );
  }

  String _formateaFecha(String? iso) {
    if (iso == null) return '-';
    try {
      final date = DateTime.parse(iso);
      final f = DateFormat('d MMMM', 'es_BO'); // 15 mayo
      return f.format(date);
    } catch (_) {
      return iso;
    }
  }

  (String, Color, Color) _estadoBadge(int? estadoId) {
    if (estadoId == null) {
      return ('Sin Estado', Colors.grey.shade200, Colors.grey.shade600);
    }

    final estado = catalogosController.estadoLoteTipos.firstWhere(
      (e) => e.estadolotetipoid == estadoId,
      orElse: () => EstadoLoteTipo(
        estadolotetipoid: 0,
        nombre: 'Desconocido',
      ),
    );

    final nombre = estado.nombre.toLowerCase();

    switch (nombre) {
      case 'preparación':
        return (
          'Preparación',
          const Color(0xFFF3E5D8), // marrón claro suave
          const Color(0xFF8D6E63), // marrón tierra
        );

      case 'siembra':
        return (
          'Siembra',
          const Color(0xFFE6F9EF), // verde claro suave
          const Color(0xFF1E8E5A), // verde medio
        );

      case 'crecimiento':
        return (
          'Crecimiento',
          const Color(0xFFE0F2F1), // verde agua claro
          const Color(0xFF00796B), // verde fuerte
        );

      case 'maduración':
        return (
          'Maduración',
          const Color(0xFFFFE8D5), // naranja muy suave
          const Color(0xFFEF6C00), // naranja intenso
        );

      case 'cosecha':
        return (
          'Cosecha',
          const Color(0xFFFFF3CD), // amarillo suave
          const Color(0xFFB68400), // amarillo dorado
        );

      default:
        return (
          estado.nombre,
          Colors.blue.shade50,
          Colors.blue.shade700,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lotes = _lotesFiltrados();

    return Container(
      color: const Color(0xFFEEEEEE),
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      'Mis Lotes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gestiona tus parcelas y cultivos',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buscador + Filtro
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _search = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Buscar lotes...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // aquí luego metes tu sheet de filtros
                            },
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Filtrar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Botones: Nuevo Lote + Mapa
                    Row(
                      children: [
                        // ----- BOTÓN NUEVO LOTE (70%) -----
                        Expanded(
                          flex: 7, // 70% del ancho aprox
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegistrarLoteScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF27AE60), // VERDE OSCURO PRINCIPAL
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                    color: Color(0x33000000),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '+ Nuevo Lote',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ----- BOTÓN MAPA (30%) -----
                        Expanded(
                          flex: 3, // 30% del ancho aprox
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const MapaLotesScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF27AE60),
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                    color: Color(0x22000000),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.map,
                                    size: 18,
                                    color: Color(0xFF27AE60),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Mapa',
                                    style: TextStyle(
                                      color: Color(0xFF27AE60),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (_loading) ...[
                      const Center(child: CircularProgressIndicator()),
                    ] else if (_error != null) ...[
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ] else if (lotes.isEmpty) ...[
                      const SizedBox(height: 40),
                      const Center(
                        child: Text(
                          'Aún no tienes lotes registrados.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ] else ...[
                      // Lista de tarjetas de lotes
                      for (final lote in lotes) ...[
                        Builder(
                          builder: (context) {
                            final produccionTotal = _produccionTotalLote(lote.loteid);

                            return Column(
                              children: [
                                LoteCard(
                                  lote: lote,
                                  produccionTotalKg: produccionTotal,
                                  formateaFecha: _formateaFecha,
                                  estadoBadge: _estadoBadge(lote.estadolotetipoid),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => DetalleLoteScreen(
                                          lote: lote,
                                          produccionTotalKg: produccionTotal,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}