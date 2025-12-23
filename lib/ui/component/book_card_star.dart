import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../features/book/book_provider.dart';
import '../../features/user/user_provider.dart';
import '../../main.dart';
import '../../network/dto/book_data.dart';

class BookCardStar extends ConsumerWidget {
  final BookData book;

  const BookCardStar({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: InkWell(
          onTap: () async{
            final book = await ref
                .read(bookSquareViewModelProvider.notifier)
                .findBookById(this.book.bookId);
            if (book == null) {
              return;
            }
            final userId = ref
                .watch(userViewModelProvider)
                .user
                ?.userId;
            if (!context.mounted) return;
            if (userId == null) {
              context.go('/${AppRouteNames.login}');
              return;
            }
            ref
                .read(bookReaderViewModelProvider.notifier)
                .loadBook(book, userId);
            context.push(
              '/${AppRouteNames.bookReader}',
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            height: 190.w, // 维持纵轴长度
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
                // 上半部分 (70%): 封面图
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: Image(
                      image: CachedNetworkImageProvider(book.coverUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),

                // 下半部分 (30%): 文本信息
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 书名
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
                        SizedBox(height: 2.w),
                        // 作者名
                        Text(
                          'by ${book.authorName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
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