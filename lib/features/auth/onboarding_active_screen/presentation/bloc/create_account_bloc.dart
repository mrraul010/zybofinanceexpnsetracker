import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zyboexpensetracker/features/auth/data/repositories/auth_repository.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  final AuthRepository repository;
  CreateAccountBloc(this.repository) : super(CreateAccountInitial()) {
    on<CreatingAccount>((event, emit) async {
      emit(CreateAccountLoading());

      try {
        await repository.createAccount(event.phone, event.nickname);

        emit(CreateAccountLoaded());
      } catch (e) {
        log('createAccount Bloc exception ${e.toString()}');
        emit(CreateAccountfailure(erroressage: e.toString()));
      }
     
    });
  }
}
