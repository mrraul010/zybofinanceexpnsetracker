import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/auth/onboarding_active_screen/presentation/screens/onboarding_active_screen.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/common_elevated_buttton.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/snackbars.dart';
import 'package:zyboexpensetracker/features/auth/verify_otp/presentation/widgets/verify_otp_elevated_button.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String? phonenumber;
  final String serverOtp;
  final bool userExists;
  final String? token;
  final String? nickname;
  final VoidCallback? onClearNumber;
  const VerifyOTPScreen({
    super.key,
    this.phonenumber,
    this.onClearNumber,
    required this.serverOtp,
    this.userExists = false,
    this.token,
    this.nickname,
  });

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  
  late final List<FocusNode> _focusNodes;

  int _resendSeconds = 32;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _focusNodes = List.generate(6, (index) {
      final node = FocusNode();
      node.onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          if (_controllers[index].text.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();

            _controllers[index - 1].clear();
            setState(() {});

            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
      return node;
    });

    _startResendTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.serverOtp.length == 6) {
        for (int i = 0; i < 6; i++) {
          _controllers[i].text = widget.serverOtp[i];
        }

        _focusNodes[5].requestFocus();

        Future.delayed(const Duration(milliseconds: 50), () {
          for (var c in _controllers) {
            if (c.text.isNotEmpty) {
              c.selection = TextSelection.fromPosition(
                const TextPosition(offset: 1),
              );
            }
          }
        });
        setState(() {});
      }
    });
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  bool get _isOtpComplete => _controllers.every((c) => c.text.isNotEmpty);

  void _onVerify() async {
    if (!_isOtpComplete) return;

    final enteredOtp = _controllers.map((c) => c.text).join();

    if (enteredOtp != widget.serverOtp) {
      showAwesomeSnackbar(
        context: context,
        type: SnackbarType.error,
        title: 'Invalid OTP',
        message: 'The code you entered is incorrect.',
      );
      return;
    }

    if (widget.userExists == true) {
      final prefs = await SharedPreferences.getInstance();
      if (widget.token != null) {
        await prefs.setString('auth_token', widget.token!);
      }
      if (widget.nickname != null) {
        await prefs.setString('user_nickname', widget.nickname!);
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OnboardingNameScreen(phonenumber: widget.phonenumber ?? ''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Verify OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Enter the 6-Digit code sent to ${widget.phonenumber}',
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
              ),

              const SizedBox(height: 6),

              GestureDetector(
                onTap: () {
                  widget.onClearNumber?.call();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Change Number',
                  style: TextStyle(
                    color: Color(0xFF5B6EF5),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (val) => _onOtpDigitChanged(val, index),
                  );
                }),
              ),

              const SizedBox(height: 28),

             
              VerifyOtpElevatedButton(
                onPressed: _isOtpComplete ? _onVerify : null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    'Resend OTP in  ',
                    style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                  ),
                  Text(
                    _resendSeconds > 0 ? '${_resendSeconds}s' : 'Resend',
                    style: TextStyle(
                      color: _resendSeconds > 0
                          ? const Color(0xFFAAAAAA)
                          : const Color(0xFF5B6EF5),
                      fontSize: 14,
                      fontWeight: _resendSeconds == 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          hintText: '-',
          hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF3D4EF5), width: 1.5),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
