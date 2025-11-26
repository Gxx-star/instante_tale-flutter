import 'package:flutter/material.dart';

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
      onTap: () {

      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // 确保图片按圆角裁剪
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 上半部分 (70%) - 图片和角标
            Expanded(
              flex: 7, // 占据 70% 高度
              child: Stack(
                children: [
                  // 背景图片
                  Positioned.fill(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  // 右上角角标 (热门, 新品, 推荐)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tagText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 2. 下半部分 (30%) - 白色区域和文本
            Expanded(
              flex: 3, // 占据 30% 高度
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                  children: [
                    // 加粗标题
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 灰色小字 (作者)
                    Text(
                      'by $author',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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