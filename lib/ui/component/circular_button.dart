// 圆形按钮
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String imgUrl;
  final String label;
  final Color color; // 作为主色调
  final VoidCallback? onTap;

  const CircularButton({
    super.key,
    required this.imgUrl,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // gradient: LinearGradient(
              //   colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              // boxShadow: [
              //   // 外发光 + 柔光
              //   BoxShadow(
              //     color: color.withOpacity(0.35),
              //     blurRadius: 15,
              //     offset: const Offset(0, 6),
              //   ),
              //   // 轻微内阴影提升立体感
              //   BoxShadow(
              //     color: Colors.white.withOpacity(0.9),
              //     blurRadius: 8,
              //     spreadRadius: -4,
              //     offset: const Offset(-3, -3),
              //   ),
              // ],
            ),
            child: Center(
              child: Image(
                image: AssetImage(imgUrl),
                width: 40,
                height: 40,
              ),
            ),
          ),

          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
