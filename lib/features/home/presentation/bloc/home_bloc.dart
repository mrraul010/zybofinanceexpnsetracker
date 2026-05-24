import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;
import 'package:zyboexpensetracker/features/home/data/datasources/home_local_datasource.dart';
import 'package:zyboexpensetracker/features/home/data/models/local_transactionmodel.dart';
import 'package:zyboexpensetracker/features/home/services/notification_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeLocalDatasource dataSource;
  HomeBloc(this.dataSource) : super(HomeInitial()) {
    on<FetchHomeDashboardData>((event, emit) async {
      emit(HomeLoading());

      try {
        final totals = await dataSource.getHomeoverviewTotals();
        final transactions = await dataSource.getToptenRecentTransactions();
        final allTransx = await dataSource.getAllTransactions();
        final activecats = await dataSource.getActiveCategories();

        final prefs = await SharedPreferences.getInstance();
        final String savedname = prefs.getString('user_nickname') ?? 'User';
        final double savedLimit = prefs.getDouble('budget_limit') ?? 1000.0;

        developer.log(
          'BLOC: Successfully loaded dashboard data.',
          name: 'HomeBloc',
        );
        developer.log(
          'BLOC: Totals -> Income: ${totals['total_income']}, Expense: ${totals['total_expense']}',
          name: 'HomeBloc',
        );
        developer.log(
          'BLOC: Loaded ${transactions.length} recent transactions.',
          name: 'HomeBloc',
        );
        developer.log(
          'BLOC: Loaded ${activecats.length} active categories.',
          name: 'HomeBloc',
        );

        emit(
          HomeLoaded(
            totalIncome: totals['total_income'] ?? 0.0,
            totalExpense: totals['total_expense'] ?? 0.0,
            recentTransactions: transactions,
            allTransactions: allTransx,
            categoriesList: activecats,
            savedname: savedname,
            budgetLimit: savedLimit,
          ),
        );
      } catch (e) {
        developer.log(
          'BLOC ERROR: Failed to fetch dashboard data. Error: $e',
          name: 'HomeBloc',
          error: e,
        );
        HomeError(e.toString());
      }
    });

    on<AddCategoryEvent>((event, emit) async {
      developer.log(
        'BLOC: Attempting to add new category: "${event.name}"',
        name: 'HomeBloc',
      );
      try {
        final String newId = const Uuid().v4();
        await dataSource.insertCategory(newId, event.name);
        developer.log(
          'BLOC: Successfully added category. Triggering refresh.',
          name: 'HomeBloc',
        );
        add(FetchHomeDashboardData());
      } catch (e) {
        developer.log(
          'BLOC ERROR: Failed to add category. Error: $e',
          name: 'HomeBloc',
          error: e,
        );
        emit(HomeError("Failed to add category: ${e.toString()}"));
      }
    });

    on<AddTransactionEvent>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final double limit = prefs.getDouble('budget_limit') ?? 1000.0;

        final totals = await dataSource.getHomeoverviewTotals();
        final double oldExpenseTotal = totals['total_expense'] ?? 0.0;
        await dataSource.insertTransaction(event.transaction, event.categoryId);

        final allTransx = await dataSource.getAllTransactions();
        final now = DateTime.now();

        final double oldMonthlyExpenseTotal = allTransx
            .where(
              (t) =>
                  t.type == 'debit' &&
                  t.timestamp.year == now.year &&
                  t.timestamp.month == now.month,
            )
            .fold(0.0, (sum, item) => sum + item.amount);

        if (event.transaction.type == 'debit') {
          final double newExpenseTotal =
              oldMonthlyExpenseTotal + event.transaction.amount;

          if (oldMonthlyExpenseTotal <= limit && newExpenseTotal > limit) {
            developer.log(
              'BLOC: Budget Limit Exceeded! Firing Notification...',
              name: 'HomeBloc',
            );

            await NotificationService.showBudgetAlert(
              event.transaction.amount,
              newExpenseTotal,
            );
          }
        }

        add(FetchHomeDashboardData());
      } catch (e) {
        emit(HomeError("Failed to add transaction: ${e.toString()}"));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      developer.log(
        'BLOC: Attempting to soft delete category ID: ${event.id}',
        name: 'HomeBloc',
      );
      try {
        await dataSource.softDeleteCategory(event.id);
        developer.log(
          'BLOC: Successfully deleted category. Triggering refresh.',
          name: 'HomeBloc',
        );
        add(FetchHomeDashboardData());
      } catch (e) {
        developer.log(
          'BLOC ERROR: Failed to delete category. Error: $e',
          name: 'HomeBloc',
          error: e,
        );
        emit(HomeError("Failed to delete category: ${e.toString()}"));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      try {
        await dataSource.softDeleteTransaction(event.id);

        add(FetchHomeDashboardData());
      } catch (e) {
        emit(HomeError("Failed to delete transaction: ${e.toString()}"));
      }
    });
  }
}
