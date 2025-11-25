import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/produccion_controller.dart';
import 'package:agro_nexus_movil/controllers/venta_controller.dart';
import 'package:agro_nexus_movil/controllers/weather_controller.dart';
import 'package:agro_nexus_movil/models/actividad.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/models/produccion.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/models/weather.dart';
import 'package:agro_nexus_movil/utils/location_helper.dart';
import 'package:agro_nexus_movil/views/lotes/registrar_lote_screen.dart';
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
        .where((a) => a.prioridadid == 1)
        .toList()
      ..sort((a, b) {
        final fa = DateTime.tryParse(a.fechainicio ?? "");
        final fb = DateTime.tryParse(b.fechainicio ?? "");
        if (fa == null || fb == null) return 0;
        return fb.compareTo(fa);
      });

    actividadesPrioridadAlta =
        actividadesPrioridadAlta.take(3).toList();

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
                  _DashboardStatCard(
                    icon: Icons.map,
                    iconBgColor: const Color(0xFF2ECC71),
                    title: 'Lotes Activos',
                    value: numberFormatter.format(_lotesActivos),
                  ),
                  const SizedBox(height: 12),

                  // CARD: PRODUCCIÓN DEL MES
                  _DashboardStatCard(
                    icon: Icons.agriculture,
                    iconBgColor: const Color(0xFF1ABC9C),
                    title: 'Producción del Mes',
                    value: '${numberFormatter.format(_produccionMesKg)} kg',
                  ),
                  const SizedBox(height: 12),

                  // CARD: VENTAS DEL MES
                  _DashboardStatCard(
                    icon: Icons.attach_money,
                    iconBgColor: const Color(0xFFE74C3C),
                    title: 'Ventas del Mes',
                    value: currencyFormatter.format(_ventasMesTotal),
                  ),
                  const SizedBox(height: 30),

                  if (_weatherController.weather != null) ...[
                    _WeatherCard(weather: _weatherController.weather!),
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

                  _WrapQuickActions(onQuickNav: widget.onQuickNav),

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
                          .where((l) => l.loteid == act.loteid)
                          .toList();

                      final loteNombre = coincidencias.isNotEmpty
                          ? coincidencias.first.nombre
                          : "Lote";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ActividadPrioridadCard(
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

class _DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String value;

  const _DashboardStatCard({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Weather weather;

  const _WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF007AFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ubicación
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                (weather.city.isNotEmpty && weather.country.isNotEmpty)
                    ? '${weather.city}, ${weather.country}'
                    : 'Mi ubicación',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Temperatura grande
          Text(
            '${weather.temperature.toStringAsFixed(0)}°C',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Descripción
          Text(
            weather.description,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Humedad y viento
          Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                '${weather.humidity.toStringAsFixed(0)}% Humedad',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.air, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                '${(weather.feelsLike).toStringAsFixed(0)}° Sensación',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _WrapQuickActions extends StatelessWidget {
  final void Function(AgroMenuItem item)? onQuickNav;

  const _WrapQuickActions({this.onQuickNav});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _QuickActionButton(
          icon: Icons.add,
          color: Colors.green.shade700,
          label: "Nuevo Lote",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrarLoteScreen()),
            );
          },
        ),
        _QuickActionButton(
          icon: Icons.edit_calendar,
          color: Colors.green,
          label: "Actividad",
          onTap: () {
            onQuickNav?.call(AgroMenuItem.actividades);
          },
        ),
        _QuickActionButton(
          icon: Icons.inventory,
          color: Colors.teal,
          label: "Inventario",
          onTap: () {
            onQuickNav?.call(AgroMenuItem.inventario);
          },
        ),
        _QuickActionButton(
          icon: Icons.bar_chart,
          color: Colors.amber.shade700,
          label: "Reportes",
          onTap: () {
            onQuickNav?.call(AgroMenuItem.reportes);
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 2, // 2 columnas
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}
class _ActividadPrioridadCard extends StatelessWidget {
  final Actividad actividad;
  final String loteNombre;
  final String tiempo;

  const _ActividadPrioridadCard({
    required this.actividad,
    required this.loteNombre,
    required this.tiempo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícono rojo de prioridad alta
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.priority_high,
              size: 22,
              color: Colors.red,
            ),
          ),

          const SizedBox(width: 14),

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividad.descripcion ?? "Actividad",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$loteNombre · $tiempo",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}