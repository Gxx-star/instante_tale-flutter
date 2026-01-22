import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySnackBar {
  static void show(BuildContext context, String message) {
    // 1. 如果当前有SnackBar显示，先移除，防止多条消息堆积延迟
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // 2. 构建自定义SnackBar
    final snackBar = SnackBar(
      // 核心技巧：将SnackBar背景设为透明，完全由content内部控制样式
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 2), // 只显示2秒
      behavior: SnackBarBehavior.floating, // 悬浮模式
      // 核心技巧：通过 margin 调整位置
      // bottom: 100 可以让它悬浮在 FAB 之上，避免把 FAB 顶上去
      margin: EdgeInsets.only(bottom: 25.w, left: 20.w, right: 20.w),
      padding: EdgeInsets.zero, // 移除默认内边距

      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
        decoration: BoxDecoration(
          // 契合图片的风格：粉紫渐变
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE0B3FF), // 浅紫色 (类似图片左侧)
              Color(0xFFFF80AB), // 粉色 (类似图片右侧)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          // 大圆角
          borderRadius: BorderRadius.circular(15.r),
          // 柔和的阴影
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF80AB).withOpacity(0.3),
              offset: Offset(0, 4.r),
              blurRadius: 10.r,
              spreadRadius: 1.r,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 可选：加个小图标增加亲和力
            Icon(Icons.sentiment_satisfied_alt, color: Colors.white, size: 20.w),
            SizedBox(width: 10.w),
            // 文本内容
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0, // 增加一点字间距，显得更精致
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    // 3. 显示
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
