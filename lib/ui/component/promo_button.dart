import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 推广内容
class PromoButton extends StatefulWidget {
  // 移除 final VoidCallback onTap;
  const PromoButton({super.key}); // 移除 required this.onTap

  @override
  State<PromoButton> createState() => _PromoButtonState();
}

class _PromoButtonState extends State<PromoButton> {
  // Define local constants
  static const Color _customPinkColor = Color(0xFFdb519d); // 强调粉色 (用于按钮/价格)
  static const Color _lightBgPink = Color(0xFFF9EEF7); // 更浅的粉色背景
  static const Color _purpleColor = Color(0xFF673AB7); // 紫色 (用于四分之一圆)

  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {

        },
        // 专门为 Web/Desktop 平台添加悬浮效果
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Container(
            height: 120.w,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.w),
            decoration: BoxDecoration(
              color: Color(0xfff3e8f7), // 更浅的粉色背景
              borderRadius: BorderRadius.circular(15.r), // 圆角
              border: Border.all(color: Color(0xffeba9d3), width: 1.5.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(_isHovering ? 0.4 : 0.1),
                  spreadRadius: 2.r,
                  blurRadius: 10.r, // 悬浮时更明显的模糊
                  offset: Offset(0, _isHovering ? 8.r : 3.r), // 悬浮时下边界更深的阴影
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias, // 剪裁四分之一圆
            child: Stack(
              children: [
                // Top-right quarter circle (Purple) - 50% radius
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: _purpleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60.r),
                      ),
                    ),
                  ),
                ),
                // Bottom-left quarter circle (Purple) - smaller radius (30px)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 35.w, // 较小的宽度
                    height: 35.w, // 较小的高度
                    decoration: BoxDecoration(
                      color: _purpleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(60.r), // 较小的圆角
                      ),
                    ),
                  ),
                ),

                // Centered content (Text and Button)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '定制专属主角绘本，限时',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const TextSpan(text: '  '),
                            TextSpan(
                              text: '0.1元',
                              style: TextStyle(
                                color: Color(0xffce4187),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.w),
                      // “立即抢购” 静态按钮 (无点击效果)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                        decoration: BoxDecoration(
                          color: _customPinkColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '立即抢购',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
