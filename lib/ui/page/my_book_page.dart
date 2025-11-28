import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/main.dart';

import '../../database/models/book.dart';
import '../component/glass_button.dart';

// "我的绘本“中的绘本卡片
class MyBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MyBookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        // 外部容器使用圆角和柔和阴影
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 封面图片
              Image.network(
                book.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 封面加载失败时的占位
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey[500],
                      ),
                    ),
                  );
                },
              ),

              // 底部信息区域（渐变阴影覆盖）
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // 渐变阴影效果
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0), // 顶部透明
                        Colors.black.withOpacity(0.7), // 底部深色
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 绘本名字
                      Text(
                        book.bookName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 创建时间
                      Text(
                        '创建时间: ${AppGlobals().formatTimestamp(book.createdAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
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
    );
  }
}

class MyBooksPage extends ConsumerStatefulWidget {
  const MyBooksPage({super.key});

  @override
  ConsumerState<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends ConsumerState<MyBooksPage> {
  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // 柔和背景色
      body: books.when(
        data: (booksList) {
          return Column(
            children: [
              // 顶部 AppBar (样式沿用)
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0FF), // 浅紫色背景
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFBFA2FF),
                      blurRadius: 10,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GlassButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '我的绘本',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A4C75),
                          ),
                        ),
                      ),
                    ),
                    // 右侧占位保持居中或添加功能按钮
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 绘本列表
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 一行两个
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7, // 绘本封面通常较高
                  ),
                  itemCount: booksList.length, // 使用模拟数据源
                  itemBuilder: (context, index) {
                    final book = booksList[index];
                    return MyBookCard(
                      book: book,
                      onTap: () {
                        ref.read(bookViewModelProvider.notifier).loadBook(book);
                        context.push('/${AppRouteNames.bookReader}');
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('删除绘本'),
                              content: const Text('确定要删除该绘本吗？'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(bookViewModelProvider.notifier)
                                        .deleteBook(book.bookId);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('确认'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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
}
