import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 绘本项目卡片
class SquareItemCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String tagText;
  final Color tagColor;

  const SquareItemCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.tagText,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8.r,
              offset: Offset(0, 4.r),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // 确保图片按圆角裁剪
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // 背景图片
                  Positioned.fill(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  // 右上角角标 (热门, 新品, 推荐)
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.w,
                      ),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        tagText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
