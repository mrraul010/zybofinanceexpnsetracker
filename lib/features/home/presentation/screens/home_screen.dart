import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/history/presentation/screens/history_screen.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_content.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/add_transactionsbottomsheet.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/monthly_limitshowing_component.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/navitem.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/pillshapenavbar.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/summary_card.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/transaction_tile.dart';
import 'package:zyboexpensetracker/features/profile/presentation/screens/profile_screen.dart';

class Transaction {
  final String title;
  final String category;
  final String date;
  final double amount;
  final bool isExpense;
  final IconData icon;

  const Transaction({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.icon,
  });
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOutBack,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  late final List<Widget> _pages = [
    HomeContent(
      fabAnimation: _fabAnimation,
      onSeeAll: () => setState(() => _selectedIndex = 1),
    ),

    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: PillShapeNavBar(
        selectedIndex: _selectedIndex,
        onTabChanged: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: _selectedIndex == 0
          ? ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                onPressed: () {
                

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddTransactionSheet(),
                  );
                },
                backgroundColor: const Color(0xFF22C55E),
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            )
          : null,
      floatingActionButtonLocation: _selectedIndex == 0
          ? FloatingActionButtonLocation.endFloat
          : null,
    );
  }
}
