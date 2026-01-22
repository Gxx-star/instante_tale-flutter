import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/features/book/book_provider.dart';

import '../../features/user/user_provider.dart';
import '../../main.dart';
import '../../network/dto/book_data.dart';
import '../component/glass_button.dart';

class MyFavoritesPage extends ConsumerWidget {
  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteBooks = ref.watch(starBooksProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GlassButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '我的收藏',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A4C75),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: favoriteBooks.when(
        data: (favoriteBooks) {
          return favoriteBooks.isEmpty
              ? _buildEmptyState()
              : MasonryGridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  crossAxisCount: 3,
                  // 仿照截图，一行显示3个
                  mainAxisSpacing: 2.w,
                  crossAxisSpacing: 2.w,
                  itemCount: favoriteBooks.length,
                  itemBuilder: (context, index) {
                    return _CollectionCard(
                      book: favoriteBooks[index],
                      ref: ref,
                    );
                  },
                );
        },
        error: (e, s) {
          return Center(child: Text('加载失败: $e'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // 空状态展示
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 64.w,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Text(
            "还没有收藏任何绘本哦",
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final BookData book;
  final WidgetRef ref;

  const _CollectionCard({required this.book, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final book = await ref
            .read(bookSquareViewModelProvider.notifier)
            .findBookById(this.book.bookId);
        if (book == null) {
          return;
        }
        final userId = ref.watch(userViewModelProvider).user?.userId;
        if (!context.mounted) return;
        if (userId == null) {
          context.go('/${AppRouteNames.login}');
          return;
        }
        ref.read(bookReaderViewModelProvider.notifier).loadBook(book, userId);
        context.push('/${AppRouteNames.bookReader}');
      },
      child: AspectRatio(
        aspectRatio: 3 / 4, // 这种瀑布流布局通常使用固定的宽高比
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[100]),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 封面图
              CachedNetworkImage(
                imageUrl: book.coverUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              ),

              // 底部阴影渐变（为了让白色文字更清晰）
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 60.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // 核心信息展示
              Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // 内容靠下对齐
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 书名
                    Text(
                      book.bookName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // 底部收藏数和图标
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded, // 既然是收藏页面，用爱心图标很贴切
                          color: Colors.red,
                          size: 14.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _formatNumber(book.starNumber),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 如果需要右上角的“置顶”或“状态”标签，可以在这里加 Positioned
            ],
          ),
        ),
      ),
    );
  }

  // 格式化数字，例如 10000 -> 1万
  String _formatNumber(int number) {
    if (number < 10000) return number.toString();
    return "${(number / 10000).toStringAsFixed(1)}万";
  }
}
