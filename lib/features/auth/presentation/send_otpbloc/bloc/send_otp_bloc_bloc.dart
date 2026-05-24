import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:zyboexpensetracker/features/auth/data/models/send_otpmodel.dart';
import 'package:zyboexpensetracker/features/auth/data/repositories/auth_repository.dart';

part 'send_otp_bloc_event.dart';
part 'send_otp_bloc_state.dart';

class SendOtpBlocBloc extends Bloc<SendOtpBlocEvent, SendOtpBlocState> {
  final AuthRepository repository;
  SendOtpBlocBloc(this.repository) : super(SendOtpBlocInitial()) {
    on<SendingOtpEvent>((event, emit) async {
      emit(SendOtpBlocloading());
      try {
        final res = await repository.sendOtp(event.phone ?? '');

        emit(SendOtpBlocSucess(sendOtpResponse: res));
      } catch (e) {
        emit(
          SendOtpFailure(
            errormessage: e.toString().replaceAll('Exception: ', ''),
          ),
        );
      }
    });
  }
}
