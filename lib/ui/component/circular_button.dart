// 圆形按钮
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            width: 66.w,
            height: 66.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Image(
                image: AssetImage(imgUrl),
                width: 40.w,
                height: 40.w,
              ),
            ),
          ),

          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
