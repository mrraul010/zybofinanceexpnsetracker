import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPhoneNumberField extends StatelessWidget {
  const LoginPhoneNumberField({
    super.key,
    required bool isFocused,
    required TextEditingController phoneController,
    required FocusNode phoneFocus,
  }) : _isFocused = isFocused,
       _phoneController = phoneController,
       _phoneFocus = phoneFocus;

  final bool _isFocused;
  final TextEditingController _phoneController;
  final FocusNode _phoneFocus;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFocused ? const Color(0xFF4B3FE4) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF312ECB).withOpacity(0.25),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '+91',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(width: 1, height: 22, color: Colors.white.withOpacity(0.2)),

          Expanded(
            child: TextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: const Color(0xFF312ECB),
              decoration: InputDecoration(
                hintText: 'Phone',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
