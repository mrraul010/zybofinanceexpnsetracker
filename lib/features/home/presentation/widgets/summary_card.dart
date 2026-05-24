import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final bool isIncome;

  const SummaryCard({
    required this.label,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isIncome
        ? const Color(0xFF14532D)
        : const Color(0xFF7F1D1D);
    final accentColor = isIncome
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    final borderColor = isIncome
        ? const Color(0xFF166534)
        : const Color(0xFF991B1B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isIncome
                  ? const Color(0xFF86EFAC)
                  : const Color(0xFFFCA5A5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: accentColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  amount,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
