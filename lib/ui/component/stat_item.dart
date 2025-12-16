import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 资料卡中的统计项
class StatItem extends StatelessWidget {
  final String imgUrl;
  final String text;

  const StatItem({super.key, required this.imgUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          image: AssetImage(imgUrl),
          width: 12.w,
          height: 12.w,
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
