import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/widgets/actividades/calendario_mes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/models/actividad.dart';

class CalendarioActividadesScreen extends StatefulWidget {
  const CalendarioActividadesScreen({super.key});

  @override
  State<CalendarioActividadesScreen> createState() =>
      _CalendarioActividadesScreenState();
}

class _CalendarioActividadesScreenState
    extends State<CalendarioActividadesScreen> {
  
  final ActividadController _actividadController = ActividadController();
  final LoteController _loteController = LoteController();
  List<Actividad> _actividades = [];

  DateTime _visibleMonth =
      DateTime(DateTime.now().year, DateTime.now().month);

  DateTime? _selectedDate;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = authController.token!;
    final userId = authController.usuario!.usuarioid;

    await _actividadController.cargarActividades(token);
    await _loteController.cargarLotes(token);

    setState(() {
      _actividades = _actividadController.actividades
          .where((a) => a.usuarioid == userId)
          .toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMonthContainer(),
            const SizedBox(height: 20),
            CalendarioMes(
              visibleMonth: _visibleMonth,
              selectedDate: _selectedDate,
              diasConActividades: _actividades
                  .map((a) => DateTime.parse(a.fechainicio!))
                  .toList(),
              onDateSelected: (day) {
                setState(() => _selectedDate = day);
              },
              onMonthChanged: (newMonth) {
                setState(() => _visibleMonth = newMonth);
              },
            ),
            _buildSelectedDateBlock(),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // HEADER
  // ======================================================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: const BoxDecoration(
        color: Color(0xFF1B5E20),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              "Calendario de Actividades",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // CONTENEDOR DE MES
  // ======================================================
  Widget _buildMonthContainer() {
    final actividadesMes = actividadesDelMes();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month - 1,
                      );
                    });
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: Color(0xFF1B5E20),
                  ),
                ),

                Column(
                  children: [
                    Text(
                      DateFormat("MMMM yyyy", "es")
                          .format(_visibleMonth)
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$actividadesMes actividades programadas",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month + 1,
                      );
                    });
                  },
                  child: const Icon(
                    Icons.chevron_right,
                    size: 28,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateBlock() {
    if (_selectedDate == null) return const SizedBox();

    final actividades = actividadesDelDia(_selectedDate!);

    final fechaTitulo = DateFormat("EEEE, d 'de' MMMM", "es")
        .format(_selectedDate!)
        .toLowerCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 TÍTULO DE LA FECHA SELECCIONADA
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Color(0xFF1B5E20), size: 20),
              const SizedBox(width: 8),
              Text(
                _capitalize(fechaTitulo),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (actividades.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("No hay actividades este día.",
                  style: TextStyle(color: Colors.grey)),
            ),

          // 🔹 LISTA DE ACTIVIDADES
          ...actividades.map(_actividadCard),
        ],
      ),
    );
  }

  Widget _buildActivitiesOfDay() {
    if (_selectedDate == null) {
      return const SizedBox();
    }

    final actividades = actividadesDelDia(_selectedDate!);

    final fechaTitulo = DateFormat("EEEE, d 'de' MMMM", "es")
        .format(_selectedDate!)
        .toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -------------------------------
        // TÍTULO CON LA FECHA
        // -------------------------------
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: Color(0xFF1B5E20), size: 20),
              const SizedBox(width: 8),
              Text(
                _capitalize(fechaTitulo),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),

        if (actividades.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "No hay actividades este día.",
              style: TextStyle(color: Colors.grey),
            ),
          ),

        // -------------------------------
        // LISTA DE ACTIVIDADES
        // -------------------------------
        ...actividades.map((a) => _actividadCard(a)),
      ],
    );
  }

  Widget _actividadCard(Actividad a) {
    final fecha = DateTime.tryParse(a.fechainicio ?? "");
    final hora = fecha != null ? DateFormat("HH:mm").format(fecha) : "--:--";

    final tipoNombre = _nombreTipo(a.tipoactividadid);
    final color = colorPorTipo(a.tipoactividadid);
    final icon = _iconoTipo(a.tipoactividadid);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primera fila: Chip + Hora
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: color),
                    const SizedBox(width: 4),
                    Text(
                      tipoNombre,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                hora,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Descripción
          Text(
            a.descripcion,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 6),

          // Lote
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(
                nombreLote(a.loteid),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // ======================================================
  // COLORES POR TIPO
  // ======================================================
  Color colorPorTipo(int tipo) {
    switch (tipo) {
      case 1:
        return Colors.green; // Siembra
      case 2:
        return Colors.blue; // Riego
      case 3:
        return Colors.red; // Fumigación
      case 4:
        return Colors.orange; // Cosecha
      case 5:
        return Colors.brown; // Labranza
      default:
        return Colors.grey;
    }
  }

  // ======================================================
  // FILTRAR ACTIVIDADES POR DÍA
  // ======================================================
  List<Actividad> actividadesDelDia(DateTime dia) {
    return _actividades.where((a) {
      if (a.fechainicio == null) return false;

      final date = DateTime.tryParse(a.fechainicio!);
      if (date == null) return false;

      return date.year == dia.year &&
          date.month == dia.month &&
          date.day == dia.day;
    }).toList();
  }

  String nombreLote(int loteId) {
    for (final lote in _loteController.lotes) {
      if (lote.loteid == loteId) return lote.nombre;
    }
    return "Lote $loteId";
  }

  // ======================================================
  // CONTADOR DE ACTIVIDADES DEL MES
  // ======================================================
  int actividadesDelMes() {
    return _actividades.where((a) {
      if (a.fechainicio == null) return false;

      final date = DateTime.tryParse(a.fechainicio!);
      if (date == null) return false;

      return date.year == _visibleMonth.year &&
          date.month == _visibleMonth.month;
    }).length;
  }

  String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _nombreTipo(int id) {
    switch (id) {
      case 1: return "Siembra";
      case 2: return "Riego";
      case 3: return "Fumigación";
      case 4: return "Cosecha";
      case 5: return "Labranza";
      default: return "Actividad";
    }
  }

  IconData _iconoTipo(int id) {
    switch (id) {
      case 1: return Icons.eco;
      case 2: return Icons.water_drop;
      case 3: return Icons.bug_report;
      case 4: return Icons.agriculture;
      case 5: return Icons.grass;
      default: return Icons.more_horiz;
    }
  }
}