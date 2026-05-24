import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/transaction_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Text(
                'Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    if (state.allTransactions.isEmpty) {
                      return Center(
                        child: Text(
                          'No Transactions Found ',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.allTransactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => TransactionTile(
                        transaction: state.allTransactions[index],
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      "NO Transactions Found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Transaction> demoTransactions = [
  Transaction(
    title: 'Grocery Store',
    category: 'Food',
    date: '12th Dec 2026',
    amount: 36345,
    isExpense: true,
    icon: Icons.shopping_cart_rounded,
  ),
  Transaction(
    title: 'Electricity Bill',
    category: 'Bills',
    date: '12th Dec 2026',
    amount: 379,
    isExpense: false,
    icon: Icons.bolt_rounded,
  ),
  Transaction(
    title: 'Grocery Store',
    category: 'Food',
    date: '12th Dec 2026',
    amount: 36345,
    isExpense: true,
    icon: Icons.shopping_cart_rounded,
  ),
  Transaction(
    title: 'Fruits',
    category: 'Food',
    date: '12th Dec 2026',
    amount: 379,
    isExpense: false,
    icon: Icons.shopping_cart_rounded,
  ),
  Transaction(
    title: 'Water Bill',
    category: 'Bills',
    date: '12th Dec 2026',
    amount: 36345,
    isExpense: true,
    icon: Icons.shopping_cart_rounded,
  ),
  Transaction(
    title: 'Grocery Store',
    category: 'Food',
    date: '12th Dec 2026',
    amount: 379,
    isExpense: false,
    icon: Icons.shopping_cart_rounded,
  ),
];
