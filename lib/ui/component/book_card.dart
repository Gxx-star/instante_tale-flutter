import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/main.dart';

import '../../database/models/book.dart';

// 绘本卡片
class BookCard extends ConsumerWidget {
  final Book book;
  // 【新增】控制UI显示
  final bool showPageCount;
  final bool showFavoriteIcon;

  const BookCard({
    super.key,
    required this.book,
    this.showPageCount = true, // 默认显示页数
    this.showFavoriteIcon = false, // 默认不显示爱心
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Expanded 确保三个卡片平分空间
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0), // 确保卡片间有间隔
        child: InkWell(
          onTap: () {
            // 点击卡片后跳转
            ref.watch(bookViewModelProvider.notifier).loadBook(book);
            context.push('/${AppRouteNames.bookReader}');
          },
          // 【修复】添加 borderRadius，确保点击水波纹和阴影是圆角
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 190, // 设定纵轴长度
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 上半部分 (70%): 图片展示区域
                Expanded(
                  flex: 7, // 7成
                  child: ClipRRect( // 用于裁剪图片圆角
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    // 【修改】用 Stack 包裹图片以添加爱心图标
                    child: Stack(
                      children: [
                        // 图片
                        Positioned.fill(
                          child: Image.network(
                            book.coverUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        // 【新增】右上角的收藏爱心
                        if (showFavoriteIcon)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.0), // 半透明背景
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // 下半部分 (30%在本部分中，我将为...: 白色区域
                Expanded(
                  flex: 3, // 3成
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 作品名
                        Text(
                          book.bookName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        // 【修改】根据 showPageCount 决定是否显示页数
                        if (showPageCount) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${book.content.length} 页',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ]
                      ],
                    ),
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