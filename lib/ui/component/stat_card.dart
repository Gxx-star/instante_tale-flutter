// 顶部卡片
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;

  const StatCard({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // Retaining the reduced vertical padding for shorter height
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji/Icon
            Image(image: AssetImage(imgUrl), width: 30, height: 30),
            const SizedBox(height: 4),
            // Title
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: color, // Use passed color
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
