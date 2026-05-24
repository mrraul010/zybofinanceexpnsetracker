part of 'send_otp_bloc_bloc.dart';

@immutable
abstract class SendOtpBlocEvent extends Equatable {
  const SendOtpBlocEvent();

  @override
  List<Object?> get props => [];
}

class SendingOtpEvent extends SendOtpBlocEvent {
  final String? phone;

  SendingOtpEvent({this.phone});

  @override
  List<Object?> get props => [phone];
}
