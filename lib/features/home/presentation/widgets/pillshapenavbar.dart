import 'package:flutter/material.dart';
import 'package:zyboexpensetracker/features/home/presentation/widgets/navitem.dart';

class PillShapeNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  PillShapeNavBar({
    super.key,
    required this.onTabChanged,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,

      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          decoration: BoxDecoration(
            color: Color(0xff262626),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white24, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavItem(
                imagepath: 'assets/navbarpieicon.svg',
                isSelected: selectedIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              const SizedBox(width: 8),
              NavItem(
                imagepath: 'assets/navbarsyncicon.svg',
                isSelected: selectedIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              const SizedBox(width: 8),
              NavItem(
                imagepath: 'assets/navbarprofileicon.svg',
                isSelected: selectedIndex == 2,
                onTap: () => onTabChanged(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
