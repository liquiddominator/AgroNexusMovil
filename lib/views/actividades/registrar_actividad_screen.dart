import 'package:agro_nexus_movil/widgets/actividades/fecha_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/actividad_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';

class RegistrarActividadScreen extends StatefulWidget {
  const RegistrarActividadScreen({super.key});

  @override
  State<RegistrarActividadScreen> createState() => _RegistrarActividadScreenState();
}

class _RegistrarActividadScreenState extends State<RegistrarActividadScreen> {
  final _actividadController = ActividadController();
  final _loteController = LoteController();
  final _catalogosController = CatalogosController();

  bool loading = true;
  bool saving = false;

  // ========= FORM VALUES ==========
  int? selectedTipoId;
  int? selectedPrioridadId;
  int? selectedLoteId;

  DateTime? fechaInicio;
  DateTime? fechaFin;

  final descripcionController = TextEditingController();
  final observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final token = authController.token!;

    await Future.wait([
      _loteController.cargarLotes(token),
      _catalogosController.cargarCatalogos(token),
    ]);

    setState(() => loading = false);
  }

  // ======================================================
  //  PICK FECHAS
  // ======================================================
  Future<void> pickFechaInicio() async {
    // 1️⃣ Elegir fecha
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (pickedDate == null) return;

    // 2️⃣ Elegir hora
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: fechaInicio != null
          ? TimeOfDay(hour: fechaInicio!.hour, minute: fechaInicio!.minute)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // 3️⃣ Combinar fecha + hora
    setState(() {
      fechaInicio = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> pickFechaFin() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaFin ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: fechaFin != null
          ? TimeOfDay(hour: fechaFin!.hour, minute: fechaFin!.minute)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      fechaFin = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  // ======================================================
  //  GUARDAR ACTIVIDAD
  // ======================================================
  Future<void> guardarActividad() async {
    if (saving) return;

    if (selectedTipoId == null ||
        selectedPrioridadId == null ||
        selectedLoteId == null ||
        descripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos obligatorios.")),
      );
      return;
    }

    if (fechaInicio != null &&
        fechaFin != null &&
        fechaFin!.isBefore(fechaInicio!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La fecha fin no puede ser menor a la fecha inicio.")),
      );
      return;
    }

    setState(() => saving = true);

    final token = authController.token!;
    final userId = authController.usuario!.usuarioid;
    final df = DateFormat("yyyy-MM-dd HH:mm:ss");

    final body = {
      "loteid": selectedLoteId,
      "usuarioid": userId,
      "descripcion": descripcionController.text.trim(),
      "fechainicio": fechaInicio != null ? df.format(fechaInicio!) : null,
      "fechafin": fechaFin != null ? df.format(fechaFin!) : null,
      "tipoactividadid": selectedTipoId,
      "prioridadid": selectedPrioridadId,
      "observaciones": observacionesController.text.trim()
    };

    final ok = await _actividadController.crearActividad(body, token);

    setState(() => saving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Actividad registrada correctamente.")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${_actividadController.errorMessage}")),
      );
    }
  }

  // ======================================================
  //  UI
  // ======================================================
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userId = authController.usuario!.usuarioid;
    final lotesUsuario = _loteController.lotes
    .where((l) => l.usuarioid == userId)
    .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================
            Container(
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
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Registrar Actividad",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // CUADRO DE INSTRUCCIONES
            // =====================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Registra y organiza las actividades agrícolas de tus lotes "
                        "para un mejor control, planificación y seguimiento.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =====================================================
            // CONTENEDOR BLANCO PRINCIPAL
            // =====================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // =====================================================
                    //  TIPO DE ACTIVIDAD (TUS ICONOS ORIGINALES)
                    // =====================================================
                    const Text(
                      "Tipo de Actividad *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      children: [
                        ..._catalogosController.tipoActividades.map((t) {
                          final active = selectedTipoId == t.tipoactividadid;

                          // Usamos TUS íconos y TUS colores
                          IconData iconData;
                          switch (t.nombre.toLowerCase()) {
                            case "siembra":
                              iconData = Icons.agriculture;
                              break;
                            case "riego":
                              iconData = Icons.water_drop;
                              break;
                            case "fumigación":
                              iconData = Icons.bug_report;
                              break;
                            case "cosecha":
                              iconData = Icons.content_cut;
                              break;
                            case "labranza":
                              iconData = Icons.inventory_2;
                              break;
                            default:
                              iconData = Icons.more_horiz;
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedTipoId = t.tipoactividadid);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: active
                                      ? const Color(0xFF1B5E20)
                                      : Colors.grey.shade300,
                                  width: active ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(iconData,
                                      size: 32,
                                      color: Colors.grey.shade700),
                                  const SizedBox(height: 6),
                                  Text(
                                    t.nombre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    ),

                    const SizedBox(height: 26),

                    // =====================================================
                    // DESCRIPCIÓN
                    // =====================================================
                    const Text(
                      "Descripción de la Actividad *",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: descripcionController,
                      decoration: InputDecoration(
                        hintText: "Ej: Siembra de Maíz en área norte",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // =====================================================
                    //  LOTE
                    // =====================================================
                    const Text(
                      "Lote *",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF1B5E20),
                          width: 1.2,
                        ),
                      ),
                      child: DropdownButton<int>(
                        value: selectedLoteId,
                        isExpanded: true,
                        underline: Container(),
                        hint: const Text("-- Selecciona un lote --"),
                        items: lotesUsuario.map((l) {
                          return DropdownMenuItem(
                            value: l.loteid,
                            child: Text(l.nombre),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => selectedLoteId = v),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // =====================================================
                    //  FECHAS (TUS _FechaItem)
                    // =====================================================
                    const Text(
                      "Fechas *",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF666666),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text("Fecha Inicio",
                        style: TextStyle(fontSize: 13, color: Color(0xFF777777))),
                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: pickFechaInicio,
                      child: FechaItem(
                        placeholder: fechaInicio != null
                          ? DateFormat("dd/MM/yyyy HH:mm").format(fechaInicio!)
                          : "dd/mm/aaaa HH:mm",
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text("Fecha Fin",
                        style: TextStyle(fontSize: 13, color: Color(0xFF777777))),
                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: pickFechaFin,
                      child: FechaItem(
                        placeholder: fechaFin != null
                            ? DateFormat("dd/MM/yyyy").format(fechaFin!)
                            : "dd/mm/aaaa HH:mm",
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =====================================================
                    //  PRIORIDAD (TUS _PrioridadItem)
                    // =====================================================
                    const Text(
                      "Prioridad *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Column(
                      children: _catalogosController.prioridades.map((p) {
                        final active = selectedPrioridadId == p.prioridadid;

                        IconData icon;
                        if (p.nombre.toLowerCase() == "alta") {
                          icon = Icons.error_outline;
                        } else if (p.nombre.toLowerCase() == "media") {
                          icon = Icons.remove_circle_outline;
                        } else {
                          icon = Icons.info_outline;
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedPrioridadId = p.prioridadid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: active
                                      ? const Color(0xFF1B5E20)
                                      : Colors.grey.shade300,
                                  width: active ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(icon,
                                      size: 30, color: Colors.grey.shade800),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.nombre,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // =====================================================
                    // OBSERVACIONES
                    // =====================================================
                    const Text(
                      "Observaciones Adicionales",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: observacionesController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              "Agrega notas o detalles adicionales sobre la actividad (opcional)",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =====================================================
                    // BOTONES
                    // =====================================================
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFF1B5E20)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Color(0xFF1B5E20),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: saving ? null : guardarActividad,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: saving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Guardar Actividad",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}