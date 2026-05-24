import 'package:flutter/material.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/bouncing_dots_loader.dart';

class CommonLoginElevatedButtton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttontext;
  final bool isLoading;
  CommonLoginElevatedButtton({
    super.key,
    this.onPressed,
    required this.buttontext,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B3FE4),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),

        child: isLoading ? const BouncingDotsLoader() : Text(buttontext),
      ),
    );
  }
}
