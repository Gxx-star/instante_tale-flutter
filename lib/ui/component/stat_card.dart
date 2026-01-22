// 顶部卡片
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: EdgeInsets.symmetric(vertical: 2.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2.r,
              blurRadius: 5.r,
              offset: Offset(0, 3.r),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji/Icon
            Image(image: AssetImage(imgUrl), width: 30.w, height: 30.w),
            SizedBox(height: 4.w),
            // Title
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 4.w),
            // Value
            Text(
              value,
              style: TextStyle(
                  fontSize: 18.sp,
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
