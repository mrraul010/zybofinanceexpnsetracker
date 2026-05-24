import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/home/data/models/local_transactionmodel.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/home_shimmerloadingplaceholder.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/monthly_limitshowing_component.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/summary_card.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/transaction_tile.dart';

class HomeContent extends StatefulWidget {
  final Animation<double> fabAnimation;
  final VoidCallback onSeeAll;

  const HomeContent({required this.fabAnimation, required this.onSeeAll});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(FetchHomeDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return HomeShimmerLoader();
          } else if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchHomeDashboardData());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(state.savedname),
                    const SizedBox(height: 24),
                    _buildSummaryCards(state.totalIncome, state.totalExpense),
                    const SizedBox(height: 20),

                    MonthlyLimitshowingComponent(
                      spent: state.totalExpense,
                      limit: state.budgetLimit,
                    ),
                    const SizedBox(height: 28),
                    _buildRecentTransactions(state.recentTransactions),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Widget _buildHeader(String? userName) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '👋 Welcome, ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            TextSpan(
              text: userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.notifications_outlined,
          color: Colors.white70,
          size: 20,
        ),
      ),
    ],
  );
}

Widget _buildSummaryCards(double income, double expense) {
  return Row(
    children: [
      Expanded(
        child: SummaryCard(
          label: 'Total Income',
          amount: '₹ ${income.toStringAsFixed(2)}',
          isIncome: true,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: SummaryCard(
          label: 'Total Expense',
          amount: '₹${expense.toStringAsFixed(2)}',
          isIncome: false,
        ),
      ),
    ],
  );
}

Widget _buildRecentTransactions(List<LocalTransactionmodel> txList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'See all',
              style: TextStyle(
                color: Color(0xFF22C55E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      txList.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No transactions yet. Add one!',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: txList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return TransactionTile(transaction: txList[index]);
              },
            ),
    ],
  );
}
