import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/features/user/user_provider.dart';
import 'package:instant_tale/main.dart';

import '../../database/models/book.dart';

// 绘本卡片（白底）
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
        padding: EdgeInsets.symmetric(horizontal: 4.w), // 确保卡片间有间隔
        child: InkWell(
          onTap: () {
            // 点击卡片后跳转
            final userId = ref.watch(userViewModelProvider).user?.userId;
            if (userId == null) {
              context.go('/${AppRouteNames.login}');
              return;
            }
            ref.read(bookReaderViewModelProvider.notifier).loadBook(book, userId);
            context.push('/${AppRouteNames.bookReader}');
          },
          // 【修复】添加 borderRadius，确保点击水波纹和阴影是圆角
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            height: 190.w, // 设定纵轴长度
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 4.r),
                ),
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 上半部分 (70%): 图片展示区域
                  Expanded(
                    flex: 7, // 7成
                    child: ClipRRect(
                      // 【修改】用 Stack 包裹图片以添加爱心图标
                      child: Stack(
                        children: [
                          // 图片
                          Positioned.fill(
                            child: Image(
                              image: CachedNetworkImageProvider(book.coverUrl),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[200],
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.r,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                            ),
                          ),
                          // 【新增】右上角的收藏爱心
                          if (showFavoriteIcon)
                            Positioned(
                              top: 6.w,
                              right: 6.w,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.0),
                                  // 半透明背景
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18.w,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // 下半部分 (30%): 白色区域
                  Expanded(
                    flex: 3, // 3成
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w, top: 8.w, right: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 作品名
                          Text(
                            book.bookName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: Colors.black87,
                            ),
                          ),
                          // 【修改】根据 showPageCount 决定是否显示页数
                          if (showPageCount) ...[
                            SizedBox(height: 2.w),
                            Text(
                              '${book.content.length} 页',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
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
