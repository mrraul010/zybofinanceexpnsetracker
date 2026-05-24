part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final double totalIncome;
  final double totalExpense;
  final String savedname;
  final double budgetLimit;
  final List<LocalTransactionmodel> recentTransactions;
  final List<LocalTransactionmodel> allTransactions;
  final List<Map<String, dynamic>> categoriesList;

  const HomeLoaded({
    required this.totalIncome,
    required this.totalExpense,
    required this.recentTransactions,
    required this.allTransactions,
    required this.categoriesList,
    required this.savedname,
    required this.budgetLimit,
  });

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpense,
    recentTransactions,
    allTransactions,
    categoriesList,
    savedname,
    budgetLimit,
    
  ];
}

class HomeError extends HomeState {
  final String errorMessage;
  const HomeError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
