
// “添加人物”卡片
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCharacterCard extends StatelessWidget {
  const AddCharacterCard({super.key});

  // 人物头像大小，与 CharacterCard 中的 CircleAvatar 匹配
  static const double _avatarRadius = 32;
  static const double _avatarDiameter = _avatarRadius * 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 【修改】移除左侧 Padding，使其在 ListView 中能紧贴左侧边缘
      padding: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
      child: InkWell(
        onTap: () {

        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 110, // 固定宽度
          height: 160, // 固定高度
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          // 使用 CustomPaint 来绘制虚线边框
          child: CustomPaint(
            painter: _DashedBorderPainter(
              // 【修改】虚线颜色更灰
              color: Colors.grey[300]!,
              strokeWidth: 1.5,
              radius: const Radius.circular(16),
              // 【修改】虚线段和间隔更短
              dashWidth: 3.0,
              dashSpace: 2.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 【修改】为了垂直对齐，使用 SizedBox 模拟 CharacterCard 的顶部间距
                // CharacterCard 顶部：Padding(4) + Container (Col center)
                // 这里我们保证 CircleAvatar/Container 的顶部位置和大小一致
                const SizedBox(height: 24), // 调整此高度以确保星形图标的垂直中心与人物头像的垂直中心对齐
                // 灰色圆形背景 + 星星图标
                Container(
                  // 【修改】尺寸与 CharacterCard 中的 CircleAvatar 匹配 (直径 64)
                  width: _avatarDiameter,
                  height: _avatarDiameter,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star_outline_rounded, // 星星图标
                    color: Colors.grey[600],
                    // 【修改】图标大小调整，使视觉效果更协调
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                // 灰色字体文本 (【修改】与人物姓名水平对齐，因为图片已垂直对齐)
                Text(
                  '添加人物',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600, // 加粗以匹配 CharacterCard 的名字
                  ),
                ),
                // 补充底部空间以维持卡片高度
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 自定义虚线边框绘制器
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Radius radius;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.radius = const Radius.circular(0),
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    path.addRRect(rrect);

    PathMetric pathMetric = path.computeMetrics().first;
    double totalLength = pathMetric.length;
    double currentDistance = 0.0;

    // 绘制虚线
    while (currentDistance < totalLength) {
      final double dashLength = min(dashWidth, totalLength - currentDistance);
      canvas.drawPath(
        pathMetric.extractPath(currentDistance, currentDistance + dashLength),
        paint,
      );
      currentDistance += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}