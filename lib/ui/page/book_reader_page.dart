import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/database/models/character.dart';
import 'package:instant_tale/database/models/page.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
class BookReaderPage extends ConsumerStatefulWidget {
  const BookReaderPage({super.key});

  @override
  ConsumerState<BookReaderPage> createState() => _BookReaderPageState();
}
class _BookReaderPageState extends ConsumerState<BookReaderPage> {
  final PreloadPageController _pageController = PreloadPageController();
  @override
  void initState() {
    super.initState();
    // 绘制完成之后的回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 加载绘本数据
      ref.read(bookViewModelProvider.notifier);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookViewModelProvider);
    final book = state.currentBook;

    if (book == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentContent = book.content[state.currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // 柔和的淡紫色背景
      body: Stack(
        children: [
          // 1. 沉浸式背景层 (用于填充整个屏幕的氛围)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFEBF2), // 浅粉
                    Color(0xFFE1D7FF), // 浅紫
                  ],
                ),
              ),
            ),
          ),

          // 2. 绘本核心内容 (PageView)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => ref.read(bookViewModelProvider.notifier).toggleControls(),
              child: PreloadPageView.builder(
                controller: _pageController,
                preloadPagesCount: book.content.length,
                itemCount: book.content.length,
                onPageChanged: (index) {
                  ref.read(bookViewModelProvider.notifier).onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  final item = book.content[index];
                  return _buildBookPage(item);
                },
              ),
            ),
          ),

          // 3. 顶部导航栏 (可隐藏)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: state.isControlsVisible ? 0 : -100,
            left: 0,
            right: 0,
            child: _buildTopBar(context, book.bookName),
          ),

          // 4. 底部文本与控制区 (可隐藏)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: state.isControlsVisible ? 30 : -200,
            left: 20,
            right: 20,
            child: _buildBottomPanel(currentContent, book.content.length, state.currentPage + 1),
          ),

          // 5. 角色浮窗按钮 (如果当前页有特定角色交互，可以在这里增加逻辑)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: 20,
            bottom: state.isControlsVisible ? 180 : -100,
            child: _buildCharacterFab(book.characters),
          )
        ],
      ),
    );
  }

  // 构建绘本单页画面
  Widget _buildBookPage(BookPage content) {
    return Center(
      child: Hero(
        tag: content.image_url,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          clipBehavior: Clip.hardEdge,
          // 模拟网络图片，实际使用 CachedNetworkImage
          child: AspectRatio(
            aspectRatio: 3 / 4, // 常见的绘本比例
            child: Container(
              color: Colors.white,
              child: Image.network(
                content.image_url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, chunk) {
                  if (chunk == null) return child;
                  return Center(child: Icon(Icons.image, color: Colors.grey[300], size: 50));
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 顶部导航
  Widget _buildTopBar(BuildContext context, String title) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _glassButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.pop(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A4C75), // 深紫色字体
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 底部内容面板
  Widget _buildBottomPanel(BookPage content, int totalPage, int displayIndex) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7090B0).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F9F), // 强调色，类似截图中的VIP/Search按钮
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Page $displayIndex / $totalPage",
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.volume_up_rounded, color: Color(0xFF9A8BB5)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content.text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A4A4A),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // 进度条
              LinearProgressIndicator(
                value: displayIndex / totalPage,
                backgroundColor: const Color(0xFFEFEFEF),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFBFA2FF)),
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 角色展示按钮（悬浮）
  Widget _buildCharacterFab(List<CharacterEmbedded>? characters) {
    if (characters == null || characters.isEmpty) return const SizedBox();

    // 取第一个角色的头像显示在按钮上
    return GestureDetector(
      onTap: () {
        _showCharactersSheet(context, characters);
      },
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7E59F6).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ]
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Color(0xFFFFA1C9), Color(0xFFBFA2FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
          child: const Icon(Icons.face, color: Colors.white),
        ),
      ),
    );
  }

  // 角色详情弹窗
  void _showCharactersSheet(BuildContext context, List<CharacterEmbedded> characters) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("登场角色", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final char = characters[index];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFF0EBFF),
                              backgroundImage: NetworkImage(char.avatarUrl),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              char.characterName.trim(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              char.desc,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
    );
  }

  // 按钮组件
  Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF5A4C75)),
          ),
        ),
      ),
    );
  }
}