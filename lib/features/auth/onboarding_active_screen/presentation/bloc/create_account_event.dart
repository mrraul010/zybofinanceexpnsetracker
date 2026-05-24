part of 'create_account_bloc.dart';

abstract class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object> get props => [];
}

class CreatingAccount extends CreateAccountEvent {
  final String phone;
  final String nickname;

  CreatingAccount({required this.phone, required this.nickname});

  @override
  List<Object> get props => [phone, nickname];
}
