import 'package:flutter/material.dart';

class FiltroChipSelector extends StatelessWidget {
  final List<String> opciones;
  final String valorActual;
  final Function(String) onChanged;

  const FiltroChipSelector({
    super.key,
    required this.opciones,
    required this.valorActual,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: opciones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final item = opciones[index];
          final activo = item == valorActual;

          return GestureDetector(
            onTap: () => onChanged(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: activo ? const Color(0xFF1B5E20) : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: activo ? const Color(0xFF1B5E20) : Colors.grey.shade300,
                ),
                boxShadow: activo
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: activo ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}