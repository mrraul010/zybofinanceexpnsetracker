import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavItem extends StatelessWidget {
  final String? imagepath;
  final bool isSelected;
  final VoidCallback onTap;

  NavItem({required this.isSelected, required this.onTap, this.imagepath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: isSelected ? 56 : 53,
        height: isSelected ? 56 : 53,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF312ECB) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            imagepath ?? '',
            height: isSelected ? 24 : 22,
            color: isSelected ? Colors.white : const Color(0xFF888888),
          ),
        ),
       
      ),
    );
  }
}
