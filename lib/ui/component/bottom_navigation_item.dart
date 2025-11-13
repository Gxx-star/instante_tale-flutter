import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const BottomNavigationItem({
    required this.icon,
    required this.label,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Color(0xFFd94897);
    final inactiveColor = Colors.grey[400];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28),
        Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
