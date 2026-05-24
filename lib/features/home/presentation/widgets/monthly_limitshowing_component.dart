import 'package:flutter/material.dart';

class MonthlyLimitshowingComponent extends StatelessWidget {
  final double spent;
  final double limit;

  MonthlyLimitshowingComponent({
    super.key,
    required this.spent,

    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    double progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    double remainingPercent = limit > 0
        ? ((limit - spent) / limit * 100).clamp(0.0, 100.0)
        : 0.0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MONTHLY LIMIT',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '₹${spent.toString()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' / ₹${limit.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF2D2D2D),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF22C55E),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${remainingPercent.toStringAsFixed(0)}% Remaining',
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
