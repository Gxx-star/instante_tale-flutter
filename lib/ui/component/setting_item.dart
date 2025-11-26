import 'package:flutter/material.dart';

// 设置项
class SettingItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingText; // 用于“关于我们”的版本号显示

  const SettingItem({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
  });

  // 【修改】按钮的高度常量 - 减少至 64.0 (原 76.0)
  static const double _buttonHeight = 64.0;
  // 边距常量 - 移除水平边距 (原 4.0)
  static const EdgeInsets _margin =
  EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0);
  // 圆角半径
  static const double _borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _buttonHeight,
      margin: _margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // 确保水波纹效果可见
        child: InkWell(
          borderRadius: BorderRadius.circular(_borderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // 1. 左侧带背景的 Icon - 更改为圆形，略微减小尺寸
                Container(
                  width: 40, // 略微减小尺寸 (原 44)
                  height: 40, // 略微减小尺寸 (原 44)
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      color: iconColor,
                      size: 22, // 略微减小 Icon 尺寸 (原 24)
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. 中间文本区域 (主/副标题) - 字体偏细
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15, // 略微减小字体 (原 16)
                          fontWeight: FontWeight.w500, // 【修改】字体偏细 (原 w600)
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. 右侧的 > icon (箭头)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14, // 略微减小箭头尺寸 (原 16)
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}