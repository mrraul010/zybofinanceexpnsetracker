import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zyboexpensetracker/features/home/data/models/local_transactionmodel.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';

class TransactionTile extends StatelessWidget {
  final LocalTransactionmodel transaction;

  const TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.type == 'debit';
    IconData _getIconForCategory(String categoryName) {
      switch (categoryName.toLowerCase()) {
        case 'food':
          return Icons.shopping_cart_rounded;
        case 'bills':
          return Icons.bolt_rounded;
        case 'transport':
          return Icons.directions_bus_rounded;
        case 'shopping':
          return Icons.local_mall_rounded;
        case 'salary':
          return Icons.monetization_on_outlined;
        case 'movies':
          return Icons.movie_outlined;
        case 'movie':
          return Icons.movie_outlined;
        case 'entertainment':
          return Icons.movie_outlined;
        default:
          return Icons.receipt_long_rounded;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF242424), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForCategory(transaction.categoryName),
              color: Colors.white70,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.categoryName,
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(transaction.timestamp),
                style: const TextStyle(color: Color(0xFF666666), fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                '${isExpense ? '-' : '+'}₹${_fmt(transaction.amount)}',
                style: TextStyle(
                  color: isExpense
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF22C55E),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              context.read<HomeBloc>().add(
                DeleteTransactionEvent(transaction.id),
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2A1515),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFEF4444),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}
