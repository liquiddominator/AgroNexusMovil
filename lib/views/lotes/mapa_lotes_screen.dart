import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/models/estado_lote_tipo.dart';

class MapaLotesScreen extends StatefulWidget {
  const MapaLotesScreen({super.key});

  @override
  State<MapaLotesScreen> createState() => _MapaLotesScreenState();
}

class _MapaLotesScreenState extends State<MapaLotesScreen> {
  GoogleMapController? mapController;
  final Location location = Location();
  final _loteController = LoteController();
  final _catalogosController = CatalogosController();

  LatLng initialPos = const LatLng(-17.7833, -63.1821); // Santa Cruz, Bolivia
  Set<Marker> _markers = {};
  bool _loading = true;
  String? _error;

  // Lotes del usuario para mostrar en la lista
  List<Lote> _lotesUsuario = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

    Future<void> _init() async {
    try {
      // 1. Primero catálogos (para tener los estados)
      await _loadCatalogos();

      // 2. Luego lotes (ya puede usar _estadoById sin null)
      await _loadLotes();

      // 3. Finalmente ubicación del usuario
      await _initLocation();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _initLocation() async {
    try {
      final permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) return;

      final loc = await location.getLocation();
      if (loc.latitude == null || loc.longitude == null) return;

      setState(() {
        initialPos = LatLng(loc.latitude!, loc.longitude!);
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(initialPos, 14),
        );
      }
    } catch (_) {
      // si falla la ubicación, dejamos el initialPos por defecto
    }
  }

  Future<void> _loadCatalogos() async {
    try {
      final token = authController.token;
      if (token == null) return;
      await _catalogosController.cargarCatalogos(token);
    } catch (_) {
      // si falla, simplemente no mostramos leyenda completa
    }
  }

  Future<void> _loadLotes() async {
    try {
      final token = authController.token;
      final usuario = authController.usuario;

      if (token == null || usuario == null) {
        setState(() {
          _error = 'No hay sesión activa.';
        });
        return;
      }

      await _loteController.cargarLotes(token);

      final lotesUsuario = _loteController.lotes
          .where((l) => l.usuarioid == usuario.usuarioid)
          .toList();

      _lotesUsuario = lotesUsuario;

      final markers = <Marker>{};

            for (final lote in lotesUsuario) {
        if (lote.latitud == null || lote.longitud == null) continue;

        final pos = LatLng(lote.latitud!, lote.longitud!);

        // obtenemos el estado del lote
        final estado = _estadoById(lote.estadolotetipoid);
        final hue = estado != null
            ? _markerHueEstado(estado.nombre)
            : BitmapDescriptor.hueRed;

        markers.add(
          Marker(
            markerId: MarkerId('lote_${lote.loteid}'),
            position: pos,
            infoWindow: InfoWindow(
              title: lote.nombre,
              snippet: 'Superficie: ${lote.superficie} ha',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          ),
        );
      }

      setState(() {
        _markers = markers;
      });

      // Si hay lotes con marker, centra la cámara en el primero
      if (markers.isNotEmpty && mapController != null) {
        final first = markers.first.position;
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(first, 14),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar lotes: $e';
      });
    }
  }

  // Buscar el estado por id
  EstadoLoteTipo? _estadoById(int? id) {
    if (id == null) return null;
    try {
      return _catalogosController.estadoLoteTipos
          .firstWhere((e) => e.estadolotetipoid == id);
    } catch (_) {
      return null;
    }
  }

  // Color según nombre del estado (mismas gamas que usas en la lista)
  Color _colorEstado(String nombreRaw) {
    final nombre = nombreRaw.toLowerCase();

    switch (nombre) {
      case 'preparación':
        return const Color(0xFF8D6E63); // marrón tierra
      case 'siembra':
        return const Color(0xFF1E8E5A); // verde medio
      case 'crecimiento':
        return const Color(0xFF00796B); // verde fuerte
      case 'maduración':
        return const Color(0xFFEF6C00); // naranja intenso
      case 'cosecha':
        return const Color(0xFFB68400); // amarillo dorado
      default:
        return Colors.blue.shade700;
    }
  }

    // Hue para el ícono del marcador según el estado
  double _markerHueEstado(String nombreRaw) {
    final nombre = nombreRaw.toLowerCase();

    switch (nombre) {
      case 'preparación':
        return BitmapDescriptor.hueRose;      // algo terroso/rosado
      case 'siembra':
        return BitmapDescriptor.hueGreen;     // verde
      case 'crecimiento':
        return BitmapDescriptor.hueAzure;     // celeste/verde agua
      case 'maduración':
        return BitmapDescriptor.hueOrange;    // naranja
      case 'cosecha':
        return BitmapDescriptor.hueYellow;    // amarillo
      default:
        return BitmapDescriptor.hueRed;       // por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<EstadoLoteTipo> estados = _catalogosController.estadoLoteTipos;

    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Lotes")),
      body: Stack(
        children: [
          // ================= MAPA =================
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPos,
              zoom: 13,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            onMapCreated: (controller) {
              mapController = controller;

              if (_markers.isNotEmpty) {
                final first = _markers.first.position;
                mapController!.moveCamera(
                  CameraUpdate.newLatLngZoom(first, 14),
                );
              }
            },
          ),

          // ================= LOADER =================
          if (_loading)
            const Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // ================= ERROR =================
          if (_error != null && !_loading)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

          // ========== PANEL SUPERIOR: LISTA DE LOTES ==========
          if (!_loading && _lotesUsuario.isNotEmpty)
            Positioned(
              top: 12,
              left: 0,
              right: 220,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.40, // 🔥 55% del ancho
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          offset: Offset(0, 3),
                          color: Color(0x33000000),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header verde
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF1B5E20), // verde oscuro
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Mis Lotes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Lista de lotes simplificada
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 230, // para que no tape todo el mapa
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            itemCount: _lotesUsuario.length,
                            itemBuilder: (context, index) {
                              final lote = _lotesUsuario[index];
                              final estado = _estadoById(lote.estadolotetipoid);
                              final nombreEstado =
                                  estado?.nombre ?? 'Sin estado';
                              final colorEstado = estado != null
                                  ? _colorEstado(estado.nombre)
                                  : Colors.grey;

                              return GestureDetector(
                                onTap: () {
                                  // si el lote tiene marker, centra la cámara
                                  if (lote.latitud != null &&
                                      lote.longitud != null &&
                                      mapController != null) {
                                    final pos = LatLng(
                                        lote.latitud!, lote.longitud!);
                                    mapController!.animateCamera(
                                      CameraUpdate.newLatLngZoom(pos, 15),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F8F8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      // Línea de color del estado
                                      Container(
                                        width: 4,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: colorEstado,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lote.nombre,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                nombreEstado,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // ===== LEYENDA DE ESTADOS (ESQUINA INFERIOR IZQUIERDA) =====
          if (!_loading && estados.isNotEmpty)
            Positioned(
              left: 12,
              bottom: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0, 2),
                      color: Color(0x22000000),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Estado de lotes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final estado in estados) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _colorEstado(estado.nombre),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            estado.nombre,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}