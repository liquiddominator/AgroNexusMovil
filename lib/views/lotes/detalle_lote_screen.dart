import 'package:agro_nexus_movil/models/lote.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleLoteScreen extends StatelessWidget {
  final Lote lote;
  final double produccionTotalKg;

  const DetalleLoteScreen({
    super.key,
    required this.lote,
    required this.produccionTotalKg,
  });

  String _formateaFecha(String? iso) {
    if (iso == null) return '-';
    try {
      final date = DateTime.parse(iso);
      final f = DateFormat('d MMMM yyyy', 'es_BO');
      return f.format(date);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('es_BO');

    return Scaffold(
      appBar: AppBar(
        title: Text(lote.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lote.imagenurl != null && lote.imagenurl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    lote.imagenurl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            Text(
              lote.nombre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lote.ubicacion ?? 'Ubicación no especificada',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DetalleItem(
                    label: 'Superficie',
                    value:
                        '${numberFormatter.format(lote.superficie)} ha',
                  ),
                ),
                Expanded(
                  child: _DetalleItem(
                    label: 'Producción total',
                    value:
                        '${numberFormatter.format(produccionTotalKg)} kg',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _DetalleItem(
              label: 'Fecha de siembra',
              value: _formateaFecha(lote.fechasiembra),
            ),

            const SizedBox(height: 16),
            _DetalleItem(
              label: 'Latitud',
              value: lote.latitud?.toStringAsFixed(6) ?? '-',
            ),
            const SizedBox(height: 8),
            _DetalleItem(
              label: 'Longitud',
              value: lote.longitud?.toStringAsFixed(6) ?? '-',
            ),
          ],
        ),
      ),
    );
  }
}

class _DetalleItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetalleItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}