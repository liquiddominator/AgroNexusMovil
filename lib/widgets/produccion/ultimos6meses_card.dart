import 'package:agro_nexus_movil/widgets/produccion/mes_produccion.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildLast6MonthsCard({
  required NumberFormat numberFormatter,
  required List<MesProduccion> last6Months,
}) {
  if (last6Months.isEmpty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        'No hay datos suficientes para mostrar el gráfico.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  final maxY = last6Months.fold<double>(
    0,
    (prev, m) => m.totalKg > prev ? m.totalKg : prev,
  );
  final scaledMaxY = maxY == 0 ? 10.0 : maxY * 1.2;

  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título con ícono
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.show_chart,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Producción de los Últimos 6 Meses',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 170,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (last6Months.length - 1).toDouble(),
              minY: 0,
              maxY: scaledMaxY,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= last6Months.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          last6Months[index].label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final index = spot.x.toInt();
                      final mes = last6Months[index];
                      return LineTooltipItem(
                        '${numberFormatter.format(mes.totalKg)} kg',
                        const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  color: const Color(0xFF2E7D32),
                  spots: [
                    for (int i = 0; i < last6Months.length; i++)
                      FlSpot(i.toDouble(), last6Months[i].totalKg),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Fila con los valores debajo (como en la imagen)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: last6Months.map((mes) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${numberFormatter.format(mes.totalKg)}kg',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mes.label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    ),
  );
}