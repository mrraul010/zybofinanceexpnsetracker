import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/auth/onboarding_active_screen/presentation/bloc/create_account_bloc.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/bouncing_dots_loader.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/snackbars.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';

class OnboardingNameScreen extends StatefulWidget {
  final String? phonenumber;

  const OnboardingNameScreen({super.key, this.phonenumber});

  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isValid = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: BlocConsumer<CreateAccountBloc, CreateAccountState>(
        listener: (context, state) async {
          if (state is CreateAccountLoaded) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_nickname', _nameController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${_nameController.text.trim()}!'),
                backgroundColor: const Color(0xFF34C759),
              ),
            );

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state is CreateAccountfailure) {
            showAwesomeSnackbar(
              context: context,
              type: SnackbarType.error,
              title: 'Oops',
              message: state.erroressage ?? 'Sorry Something Went Wrong',
              actionLabel: 'Retry',
              onAction: () {},
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: '👋', style: TextStyle(fontSize: 28)),
                        TextSpan(
                          text: 'What should we\ncall you?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'This name stays only on your device.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _nameController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Your name',
                        hintStyle: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        border: InputBorder.none,
                        suffixIcon: _isValid
                            ? const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF34C759),
                                  size: 24,
                                ),
                              )
                            : null,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  BlocBuilder<CreateAccountBloc, CreateAccountState>(
                    builder: (context, state) {
                      final isLoading = state is CreateAccountLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isValid
                              ? () {
                                  FocusScope.of(context).unfocus();

                                  context.read<CreateAccountBloc>().add(
                                    CreatingAccount(
                                      phone: widget.phonenumber ?? '',
                                      nickname: _nameController.text.trim(),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3AF4),
                            disabledBackgroundColor: const Color(0xFF2A2A7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? BouncingDotsLoader()
                              : Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _isValid
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
