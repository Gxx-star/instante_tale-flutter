import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/main.dart';

class AddCharacterCard extends StatelessWidget {
  const AddCharacterCard({super.key});

  // 修复：直接用适配单位定义头像尺寸，避免静态变量计算错误
  static final double _avatarRadius = 32.w; // 直接带w单位

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 修复：垂直间距改用h（之前用w是错误的，导致不同屏幕比例适配异常）
      padding: EdgeInsets.only(right: 8.0.w, top: 4.0.h, bottom: 4.0.h),
      child: InkWell(
        onTap: () {
          context.push('/${AppRouteNames.createCharacter}');
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          // 修复1：移除固定宽高，改用最小宽度+自适应高度（解决卡片截断）
          constraints: BoxConstraints(
            minWidth: 110.w, // 最小宽度保证卡片不压缩
            maxWidth: 120.w, // 最大宽度限制避免过宽
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          // 修复2：用Padding替代固定高度，让内容自适应
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            // 使用 CustomPaint 来绘制虚线边框（包裹自适应内容）
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: Colors.grey[300]!,
                // 修复3：strokeWidth不能用r（圆角单位），改用固定dp值
                strokeWidth: 1.5,
                radius: Radius.circular(16.r),
                dashWidth: 3.0.w,
                dashSpace: 2.0.w,
              ),
              child: Column(
                // 修复4：MainAxisSize.min 让高度自适应内容，避免固定高度截断
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // 居中对齐更稳定
                children: [
                  // 修复5：垂直间距改用h（之前24.w是错误的）
                  SizedBox(height: 16.h),
                  // 灰色圆形背景 + 星星图标
                  Container(
                    // 修复：直接用适配后的直径，避免静态变量计算错误
                    width: _avatarRadius * 2,
                    height: _avatarRadius * 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_outline_rounded,
                      color: Colors.grey[600],
                      size: 36.w,
                    ),
                  ),
                  SizedBox(height: 12.h), // 修复：改用h单位
                  // 文本（与CharacterCard样式对齐）
                  Text(
                    '添加人物',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center, // 居中避免溢出
                  ),
                  // 移除固定高度，由MainAxisSize.min自适应
                  SizedBox(height: 8.h), // 补充底部间距，视觉更协调
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 自定义虚线边框绘制器（修复绘制适配问题）
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
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // 优化：虚线端点圆润，视觉更好

    // 修复：绘制区域内缩，避免边框被裁剪
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, radius);

    Path path = Path()..addRRect(rrect);
    PathMetric pathMetric = path.computeMetrics().first;
    double totalLength = pathMetric.length;
    double currentDistance = 0.0;

    // 绘制虚线（兼容不同尺寸）
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
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    // 修复：当参数变化时重绘，避免边框显示异常
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
