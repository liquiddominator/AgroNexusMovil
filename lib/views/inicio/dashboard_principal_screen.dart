import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/produccion_controller.dart';
import 'package:agro_nexus_movil/controllers/venta_controller.dart';
import 'package:agro_nexus_movil/controllers/weather_controller.dart';
import 'package:agro_nexus_movil/models/actividad.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/utils/location_helper.dart';
import 'package:agro_nexus_movil/widgets/inicio/acciones_rapidas_botones.dart';
import 'package:agro_nexus_movil/widgets/inicio/actividad_prioridad_card.dart';
import 'package:agro_nexus_movil/widgets/inicio/stadisticas_cards.dart';
import 'package:agro_nexus_movil/widgets/inicio/weather_card.dart';
import 'package:agro_nexus_movil/widgets/menu_navegacion/agro_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPrincipalContent extends StatefulWidget {
  final void Function(AgroMenuItem item)? onQuickNav;

  const DashboardPrincipalContent({
    super.key,
    this.onQuickNav,
  });

  @override
  State<DashboardPrincipalContent> createState() =>
      _DashboardPrincipalContentState();
}

class _DashboardPrincipalContentState extends State<DashboardPrincipalContent> {
  final _loteController = LoteController();
  final _produccionController = ProduccionController();
  final _ventaController = VentaController();
  final _weatherController = WeatherController();
  final _actividadController = ActividadController();

  bool _loading = true;
  String? _error;

  int _lotesActivos = 0;
  double _produccionMesKg = 0;
  double _ventasMesTotal = 0;

  List<Actividad> actividadesPrioridadAlta = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  String tiempoRelativo(String? fechaISO) {
    final fecha = DateTime.tryParse(fechaISO ?? "");
    if (fecha == null) return "";
    final d = DateTime.now().difference(fecha);

    if (d.inMinutes < 60) return "Hace ${d.inMinutes} min";
    if (d.inHours < 24) return "Hace ${d.inHours} horas";
    if (d.inDays == 1) return "Ayer";

    return "Hace ${d.inDays} días";
  }

  Future<void> _loadDashboardData() async {
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
      _ventaController.cargarVentas(token),
      _actividadController.cargarActividades(token),
    ]);

    final userId = usuario.usuarioid;
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // LOTES DEL USUARIO
    final lotesUsuario = _loteController.lotes
        .where((l) => l.usuarioid == userId)
        .toList();
    final userLoteIds = lotesUsuario.map((l) => l.loteid).toSet();
    _lotesActivos = lotesUsuario.length;

    // PRODUCCIÓN DEL MES
    final produccionesUsuario =
        _produccionController.producciones
            .where((p) => userLoteIds.contains(p.loteid))
            .toList();

    _produccionMesKg = produccionesUsuario
        .where((p) {
          if (p.fechacosecha == null) return false;
          final fecha = DateTime.tryParse(p.fechacosecha!);
          return fecha != null &&
              fecha.month == currentMonth &&
              fecha.year == currentYear;
        })
        .fold(0, (sum, p) => sum + (p.cantidadkg ?? 0));

    final userProduccionIds =
        produccionesUsuario.map((p) => p.produccionid).toSet();

    // VENTAS DEL MES
    _ventasMesTotal = _ventaController.ventas
        .where((v) {
          if (v.fechaventa == null) return false;
          if (!userProduccionIds.contains(v.produccionid)) return false;
          final fecha = DateTime.tryParse(v.fechaventa!);
          return fecha != null &&
              fecha.month == currentMonth &&
              fecha.year == currentYear;
        })
        .fold(0, (sum, v) => sum + (v.cantidadkg ?? 0) * (v.preciokg ?? 0));

    // CLIMA
    final location = await LocationHelper.getUserLocation();
    if (location != null) {
      await _weatherController.loadWeather(
        location.latitude!,
        location.longitude!,
      );
    }

    // ACTIVIDADES ALTA PRIORIDAD — SOLO 3
    actividadesPrioridadAlta = _actividadController.actividades
        .where((a) =>
            a.prioridadid == 1 &&
            a.loteid != null &&
            userLoteIds.contains(a.loteid))          // <-- aquí filtramos por lotes del usuario
        .toList()
      ..sort((a, b) {
        final fa = DateTime.tryParse(a.fechainicio ?? "");
        final fb = DateTime.tryParse(b.fechainicio ?? "");
        if (fa == null || fb == null) return 0;
        return fb.compareTo(fa);
      });

    actividadesPrioridadAlta = actividadesPrioridadAlta.take(3).toList();

    setState(() {
      _loading = false;
      _error = null;
    });

  } catch (e) {
    setState(() {
      _loading = false;
      _error = 'Error al cargar datos: $e';
    });
  }
}

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final usuario = authController.usuario;
    final nombre = usuario?.nombre ?? '';

    final numberFormatter = NumberFormat.decimalPattern('es_BO');
    final currencyFormatter =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs. ', decimalDigits: 2);

    return SizedBox.expand(
      child: Container(
        color: const Color(0xFFEEEEEE),
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                Text(
                  '${_greeting()}, ${nombre.isEmpty ? 'agricultor' : nombre}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Resumen de tu actividad agrícola',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                if (_loading) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (_error != null) ...[
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ] else ...[
                  // CARD: LOTES ACTIVOS
                  DashboardStatCard(
                    icon: Icons.map,
                    iconBgColor: const Color(0xFF2ECC71),
                    title: 'Lotes Activos',
                    value: numberFormatter.format(_lotesActivos),
                  ),
                  const SizedBox(height: 12),

                  // CARD: PRODUCCIÓN DEL MES
                  DashboardStatCard(
                    icon: Icons.agriculture,
                    iconBgColor: const Color(0xFF1ABC9C),
                    title: 'Producción del Mes',
                    value: '${numberFormatter.format(_produccionMesKg)} kg',
                  ),
                  const SizedBox(height: 12),

                  // CARD: VENTAS DEL MES
                  DashboardStatCard(
                    icon: Icons.attach_money,
                    iconBgColor: const Color(0xFFE74C3C),
                    title: 'Ventas del Mes',
                    value: currencyFormatter.format(_ventasMesTotal),
                  ),
                  const SizedBox(height: 30),

                  if (_weatherController.weather != null) ...[
                    WeatherCard(weather: _weatherController.weather!),
                    const SizedBox(height: 16),
                  ],
                  // ACCIONES RÁPIDAS
                  const Text(
                    "Acciones Rápidas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  WrapQuickActions(onQuickNav: widget.onQuickNav),

                  const SizedBox(height: 28),

                  const Text(
                    "Actividades de Prioridad Alta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (actividadesPrioridadAlta.isEmpty)
                    const Text(
                      "No hay actividades de prioridad alta.",
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...actividadesPrioridadAlta.map((act) {
                      final coincidencias = _loteController.lotes
                          .where((l) => l.loteid == act.loteid && l.usuarioid == usuario?.usuarioid)
                          .toList();

                      final loteNombre = coincidencias.isNotEmpty
                          ? coincidencias.first.nombre
                          : "Lote";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ActividadPrioridadCard(
                          actividad: act,
                          loteNombre: loteNombre,
                          tiempo: tiempoRelativo(act.fechainicio),
                        ),
                      );
                    }).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}