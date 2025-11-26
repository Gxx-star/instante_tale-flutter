import 'package:flutter/material.dart';
// 阅读进度条
class ProgressIndicatorBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color activeColor;
  final Color inactiveColor;

  const ProgressIndicatorBar({
    super.key,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8, // 进度条高度
      decoration: BoxDecoration(
        color: inactiveColor, // 背景
        borderRadius: BorderRadius.circular(4),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0), // 确保在 0 到 1 之间
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}