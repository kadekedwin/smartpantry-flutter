import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.remove, () {
            if (value > 1) onChanged(value - 1);
          }),
          Container(
            width: 32,
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
          _buildButton(Icons.add, () {
            onChanged(value + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
