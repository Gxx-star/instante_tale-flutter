import 'dart:io';

import 'package:flutter/material.dart';
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
          width: 12,
          height: 12,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}