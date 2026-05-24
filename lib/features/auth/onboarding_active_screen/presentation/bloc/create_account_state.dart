part of 'create_account_bloc.dart';

abstract class CreateAccountState extends Equatable {
  const CreateAccountState();

  @override
  List<Object?> get props => [];
}

class CreateAccountInitial extends CreateAccountState {}

class CreateAccountLoading extends CreateAccountState {}

class CreateAccountLoaded extends CreateAccountState {}

class CreateAccountfailure extends CreateAccountState {
  final String? erroressage;



  CreateAccountfailure({ this.erroressage});


 @override
 
  List<Object?> get props => [erroressage];
}
