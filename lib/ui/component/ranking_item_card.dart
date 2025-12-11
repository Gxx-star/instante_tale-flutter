import 'package:flutter/material.dart';

// 用于显示单个热门榜单项目的组件
class RankingItemCard extends StatelessWidget {
  final int rank; // 排名 (1, 2, 3...)
  final String title; // 标题 (森林里的秘密)
  final String description; // 描述 (自然故事家)
  final String imageUrl; // 封面图片
  final int likes; // 点赞数
  final double reads; // 阅读数 (以K为单位)

  const RankingItemCard({
    super.key,
    required this.rank,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.reads,
  });

  // 颜色常量
  static const Color _lightPink = Color(0xFFd94897); // 用于箭头
  static const Color _goldenColor = Color(0xFFffc107); // 用于排名背景

  // 格式化阅读数
  String get _formattedReads {
    if (reads >= 1000) {
      return '${(reads / 1000).toStringAsFixed(1)}k';
    }
    return reads.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext
  context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {

          },
          borderRadius: BorderRadius.circular(15),
          // 整个项目使用一个大的、平坦的按钮样式
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. 排名数字 (左上角)
                _buildRankBadge(),

                const SizedBox(width: 16),

                // 2. 图片和内容 (居中垂直排列)
                _buildContentColumn(),

                const Spacer(),

                // 3. 右侧箭头
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    // 排名徽章（根据截图样式，位于图片上方，这里调整到最左侧）
    Color badgeColor;
    if (rank == 1) {
      badgeColor = _goldenColor; // 1号用金色
    } else if (rank == 2) {
      badgeColor = Colors.grey; // 2号用灰色
    } else {
      badgeColor = Colors.brown[300]!; // 3号用棕色
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        rank.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildContentColumn() {
    return Row(
      children: [
        // 2.1. 圆角图片
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        const SizedBox(width: 16),
        // 2.2. 文本和统计数据
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // 描述
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            // 统计数据 (爱心和阅读数)
            Row(
              children: [
                // 点赞数
                Icon(
                  Icons.favorite_border,
                  color: _lightPink,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${likes}k',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                // 阅读数
                Icon(
                  Icons.menu_book,
                  color: Colors.lightBlue, // 使用蓝色图标
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${likes}k',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}