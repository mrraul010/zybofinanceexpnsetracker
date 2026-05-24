part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeDashboardData extends HomeEvent {}

class AddCategoryEvent extends HomeEvent {
  final String name;
  const AddCategoryEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteCategoryEvent extends HomeEvent {
  final String id;
  const DeleteCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddTransactionEvent extends HomeEvent {
  final LocalTransactionmodel transaction;
  final String categoryId;

  const AddTransactionEvent({
    required this.transaction,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [transaction, categoryId];
} 


class DeleteTransactionEvent extends HomeEvent {
  final String id;

  const DeleteTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}


