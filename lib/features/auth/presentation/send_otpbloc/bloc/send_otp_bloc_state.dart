part of 'send_otp_bloc_bloc.dart';

@immutable
abstract class SendOtpBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpBlocInitial extends SendOtpBlocState {}

class SendOtpBlocloading extends SendOtpBlocState {}

class SendOtpBlocSucess extends SendOtpBlocState {
  final SendOtpResponse? sendOtpResponse;

  SendOtpBlocSucess({this.sendOtpResponse});

  @override
  List<Object?> get props => [sendOtpResponse];
}

class SendOtpFailure extends SendOtpBlocState {
  final String? errormessage;

  SendOtpFailure({this.errormessage});
}
