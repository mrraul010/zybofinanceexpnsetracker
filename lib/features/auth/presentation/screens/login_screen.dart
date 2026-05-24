import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zyboexpensetracker/features/auth/presentation/send_otpbloc/bloc/send_otp_bloc_bloc.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/common_elevated_buttton.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/login_phonenumberfield.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/snackbars.dart';
import 'package:zyboexpensetracker/features/auth/verify_otp/presentation/screens/verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool _isFocused = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();

    _phoneFocus.addListener(() {
      setState(() => _isFocused = _phoneFocus.hasFocus);
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideIn = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      showAwesomeSnackbar(
        context: context,
        type: SnackbarType.error,
        title: 'Invalid number',
        message: 'Please enter a valid 10-digit phone number.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<SendOtpBlocBloc>().add(SendingOtpEvent(phone: phone));

  
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<SendOtpBlocBloc, SendOtpBlocState>(
        listener: (context, state) {
          if (state is SendOtpBlocSucess) {
            final otp = state.sendOtpResponse?.otp;

            if (otp == null || otp.isEmpty) {
              showAwesomeSnackbar(
                context: context,
                type: SnackbarType.error,
                title: 'Server Error',
                message: 'No OTP received from the server. Please try again.',
                actionLabel: 'Retry',
              );
              return;
            }
            showAwesomeSnackbar(
              context: context,
              type: SnackbarType.success,
              title: 'OTP Sent!',
              message: 'We sent a code to +91 ${_phoneController.text}',
              actionLabel: 'OK',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOTPScreen(
                  phonenumber: _phoneController.text.trim(),
                  onClearNumber: () => _phoneController.clear(),
                  token: state.sendOtpResponse?.token,
                  nickname: state.sendOtpResponse?.nickname,
                  serverOtp: otp,
                  userExists: state.sendOtpResponse?.userExists ?? false,
                ),
              ),
            );
          } else if (state is SendOtpFailure) {
            showAwesomeSnackbar(
              context: context,
              type: SnackbarType.error,
              title: 'Failed to send OTP',
              message: 'Check your connection and try again.',
              actionLabel: 'Retry',
              onAction: _onContinue,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SendOtpBlocloading;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      topPad > 0 ? 16 : 32,
                      24,
                      bottomPad + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Log In Using Phone & OTP',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),

                        const SizedBox(height: 46),

                        IgnorePointer(
                          ignoring: isLoading,
                          child: LoginPhoneNumberField(
                            isFocused: _isFocused,
                            phoneController: _phoneController,
                            phoneFocus: _phoneFocus,
                          ),
                        ),

                        const SizedBox(height: 26),

                        CommonLoginElevatedButtton(
                          buttontext: 'Send Otp',
                          onPressed: _onContinue,
                          isLoading: isLoading,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
