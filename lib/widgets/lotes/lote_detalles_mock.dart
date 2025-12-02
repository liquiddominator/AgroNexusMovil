import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agro_nexus_movil/models/lote.dart';

class LoteDetallesGenerales extends StatelessWidget {
  final Lote lote;
  final String cultivoNombre;
  final String estadoNombre;

  const LoteDetallesGenerales({
    super.key,
    required this.lote,
    required this.cultivoNombre,
    required this.estadoNombre,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("d 'de' MMMM, yyyy", "es_ES").format(date);
  }

  DateTime? _fechaEstimadaCosecha(String? fechaSiembra) {
    if (fechaSiembra == null) return null;
    try {
      final siembra = DateTime.parse(fechaSiembra);
      const diasCosecha = 120;
      return siembra.add(const Duration(days: diasCosecha));
    } catch (_) {
      return null;
    }
  }

  int? _diasTranscurridos(String? fechaSiembra) {
    if (fechaSiembra == null) return null;
    try {
      final siembra = DateTime.parse(fechaSiembra);
      return DateTime.now().difference(siembra).inDays;
    } catch (_) {
      return null;
    }
  }

  int? _diasFaltantes(DateTime? fechaEstimada) {
    if (fechaEstimada == null) return null;
    return fechaEstimada.difference(DateTime.now()).inDays;
  }

  Widget _item(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Container _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 2),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fechaEstimada = _fechaEstimadaCosecha(lote.fechasiembra);
    final diasT = _diasTranscurridos(lote.fechasiembra);
    final diasF = _diasFaltantes(fechaEstimada);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DATOS GENERALES
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.description_outlined,
                      size: 20, color: Color(0xFF1B5E20)),
                  SizedBox(width: 8),
                  Text(
                    "Datos Generales",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),

              _item("Nombre del Lote", lote.nombre),
              _item("Cultivo Principal", cultivoNombre),
              _item("Superficie Total", "${lote.superficie} hectáreas"),
              _item("Ubicación", lote.ubicacion ?? "No definida"),

              _item("Estado Actual", estadoNombre,
                  valueColor: const Color(0xFF1B5E20)),
            ],
          ),
        ),

        // FECHAS IMPORTANTES
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_month_outlined,
                      size: 20, color: Color(0xFF1B5E20)),
                  SizedBox(width: 8),
                  Text(
                    "Fechas Importantes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),

              _item("Fecha de Siembra",
                  _formatDate(DateTime.tryParse(lote.fechasiembra ?? ""))),
              _item("Fecha Estimada de Cosecha", _formatDate(fechaEstimada)),
              _item(
                  "Días Transcurridos", diasT != null ? "$diasT días" : "-"),
              _item(
                "Días Faltantes",
                diasF != null ? "$diasF días" : "-",
                valueColor: Colors.green.shade800,
              ),
            ],
          ),
        ),

        // UBICACIÓN GEOGRÁFICA
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.pin_drop_outlined,
                      size: 20, color: Color(0xFF1B5E20)),
                  SizedBox(width: 8),
                  Text(
                    "Ubicación Geográfica",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),

              _item(
                  "Latitud",
                  lote.latitud != null
                      ? "${lote.latitud}°"
                      : "-"
              ),

              _item(
                  "Longitud",
                  lote.longitud != null
                      ? "${lote.longitud}°"
                      : "-"
              ),
            ],
          ),
        ),
      ],
    );
  }
}