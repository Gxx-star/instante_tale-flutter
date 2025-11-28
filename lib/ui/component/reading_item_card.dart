import 'package:flutter/material.dart';
// 用于表示”继续阅读“中的卡片内容
class ReadingItemCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final GestureDragCancelCallback callback;

  const ReadingItemCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.callback,
  });

  static const Color _progressIndicatorColor = Color(0xffe9c019);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 120, // 固定卡片宽度
        height: 180, // 固定卡片高度
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 1. 背景图片
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black,
                    child: Center(child: Text(title, style: const TextStyle(color: Colors.white))),
                  ),
                ),
              ),
            ),

            // 2. 底部渐变遮罩 (确保文本和进度条可见)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    // 标题文本
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}