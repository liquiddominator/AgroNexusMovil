import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarioMes extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;
  final List<DateTime> diasConActividades;

  const CalendarioMes({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.diasConActividades,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildWeekDays(),
          const SizedBox(height: 8),
          _buildDaysGrid(),
          const SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // Encabezado de semana
  // ──────────────────────────────────────────
  Widget _buildWeekDays() {
    final names = ["DOM", "LUN", "MAR", "MIÉ", "JUE", "VIE", "SÁB"];

    return Row(
      children: names
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // ──────────────────────────────────────────
  // Grilla de días
  // ──────────────────────────────────────────
  Widget _buildDaysGrid() {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final lastDay = DateTime(visibleMonth.year, visibleMonth.month + 1, 0);

    final int leadingEmpty = firstDay.weekday % 7;
    final int daysInMonth = lastDay.day;

    final List<DateTime?> calendar = [
      ...List<DateTime?>.filled(leadingEmpty, null),
      ...List.generate(
        daysInMonth,
        (i) => DateTime(visibleMonth.year, visibleMonth.month, i + 1),
      )
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: calendar.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final day = calendar[i];
        return _buildDayCell(day);
      },
    );
  }

  // ──────────────────────────────────────────
  // Celda individual
  // ──────────────────────────────────────────
  Widget _buildDayCell(DateTime? day) {
    if (day == null) return Container();

    bool isSelected = selectedDate != null &&
        day.year == selectedDate!.year &&
        day.month == selectedDate!.month &&
        day.day == selectedDate!.day;

    bool tieneActividad = diasConActividades.any((d) =>
        d.year == day.year && d.month == day.month && d.day == day.day);

    return GestureDetector(
      onTap: () => onDateSelected(day),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFF1B5E20), width: 2)
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${day.day}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF1B5E20) : Colors.black87,
                ),
              ),

              if (tieneActividad) ...[
                const SizedBox(height: 4),
                _dot(Colors.green),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // ──────────────────────────────────────────
  // Leyenda
  // ──────────────────────────────────────────
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legend("Siembra", Colors.green),
        _legend("Riego", Colors.blue),
        _legend("Fumigación", Colors.red),
        _legend("Cosecha", Colors.orange),
        _legend("Labranza", Colors.brown),
      ],
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}