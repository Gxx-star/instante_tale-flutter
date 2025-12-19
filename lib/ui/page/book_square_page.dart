import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/config/storybook_plaza_page_config.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/features/user/user_provider.dart';
import 'package:instant_tale/ui/component/glass_button.dart';

import '../../main.dart';
import '../../network/dto/book_data.dart'; // 新增导入

class BookSquarePage extends ConsumerStatefulWidget {
  const BookSquarePage({super.key});

  @override
  ConsumerState<BookSquarePage> createState() => _BookSquarePageState();
}

class _BookSquarePageState extends ConsumerState<BookSquarePage> {
  final ScrollController _scrollController = ScrollController();
  final _currentPageProvider = StateProvider<int>((ref) {
    return 1;
  }); // 维护当前页码

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
    _scrollController.addListener(_onScroll);
  }

  // 加载逻辑
  Future<void> _loadData() async {
    await ref
        .read(bookSquareViewModelProvider.notifier)
        .loadBookPage(ref.read(_currentPageProvider));
    ref.read(_currentPageProvider.notifier).state++;
  }

  // 滚动监听：距离底部 300 像素时触发
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 150 &&
        ref.read(bookSquareViewModelProvider).hasMore) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: bookSquareViewModelProvider,
    );
    final bookList = ref.watch(bookSquareViewModelProvider).books;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF2F8), // 延续粉色调背景
      appBar: AppBar(
        title: Center(
            child: const Text(
              '内容广场',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(_currentPageProvider.notifier).state = 1;
          await _loadData();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: MasonryGridView.count(
            controller: _scrollController,
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  final book = await ref
                      .read(bookSquareViewModelProvider.notifier)
                      .findBookById(bookList[index].bookId);
                  if (book == null) {
                    return;
                  }
                  final userId = ref.watch(userViewModelProvider).user?.userId;
                  // 异步方法运行时被销毁就停止运行
                  if (!context.mounted) return;
                  if (userId == null) {
                    context.go('/${AppRouteNames.login}');
                    return;
                  }
                  ref
                      .read(bookReaderViewModelProvider.notifier)
                      .loadBook(book, userId);
                  context.push('/${AppRouteNames.bookReader}');
                },
                child: _BookCard(book: bookList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

// 单个绘本卡片小组件
class _BookCard extends StatelessWidget {
  final BookData book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图
          CachedNetworkImage(
            imageUrl: book.coverUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(height: 150.h, color: Colors.grey[100]),
            errorWidget: (context, url, error) => Container(
              height: 150.h,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.bookName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "by ${book.authorName}",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14.h,
                          color: Colors.amber,
                        ),
                        Text(
                          "${book.starNumber}",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
