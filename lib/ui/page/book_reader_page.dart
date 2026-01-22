import 'dart:ui';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/character.dart';
import 'package:instant_tale/database/models/page.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/ui/component/glass_button.dart';
import 'package:instant_tale/util/audio_stream_player.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:rive/rive.dart' as rive;
import '../../database/models/book.dart';
import '../../features/book/reader/book_reader_state.dart';

class BookReaderPage extends ConsumerStatefulWidget {
  const BookReaderPage({super.key});

  @override
  ConsumerState<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends ConsumerState<BookReaderPage> {
  final PreloadPageController _pageController = PreloadPageController();
  final Map<int, GlobalKey> _pageKeys = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: bookReaderViewModelProvider,
    );
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: bookSquareViewModelProvider,
    );
    final state = ref.watch(bookReaderViewModelProvider);
    final book = state.currentBook;
    if (book == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentContent = book.content[state.currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // 柔和的淡紫色背景
      body: Stack(
        children: [
          // 背景层 (用于填充整个屏幕的氛围)
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

          // 绘本核心内容 (PageView)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => ref
                  .read(bookReaderViewModelProvider.notifier)
                  .toggleControls(),
              child: PreloadPageView.builder(
                controller: _pageController,
                preloadPagesCount: book.content.length,
                itemCount: book.content.length,
                onPageChanged: (index) {
                  ref
                      .read(bookReaderViewModelProvider.notifier)
                      .onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  final item = book.content[index];
                  return _buildBookPage(item);
                },
              ),
            ),
          ),

          // 顶部导航栏 (可隐藏)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: state.isControlsVisible ? 0 : -100.w,
            left: 0,
            right: 0,
            child: _buildTopBar(context, book, state),
          ),

          // 底部文本与控制区 (可隐藏)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: state.isControlsVisible ? 30.w : -200.w,
            left: 20.w,
            right: 20.w,
            child: _buildBottomPanel(
              currentContent,
              book.content.length,
              state.currentPage + 1,
            ),
          ),

          // 角色浮窗按钮 (如果当前页有特定角色交互，可以在这里增加逻辑)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: 20.w,
            bottom: state.isControlsVisible ? 115.w : -100.w,
            child: _buildCharacterFab(book.characters),
          ),
        ],
      ),
    );
  }

  // 构建绘本单页画面
  Widget _buildBookPage(BookPage content) {
    if (!_pageKeys.containsKey(content.current_page)) {
      _pageKeys[content.current_page] = GlobalKey();
    }
    return RepaintBoundary(
      key: _pageKeys[content.current_page],
      child: Center(
        child: Hero(
          tag: content.image_url,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.r),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            // 模拟网络图片，实际使用 CachedNetworkImage
            child: AspectRatio(
              aspectRatio: 3 / 4, // 常见的绘本比例
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 图片
                  Image.network(
                    content.image_url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, chunk) {
                      if (chunk == null) return child;
                      return Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[300],
                          size: 50.w,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50.w,
                        ),
                      );
                    },
                  ),
                  // 文字
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 25.w,
                      ),
                      // 使用黑色渐变，从透明到半透明深色
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0), // 上部透明
                            Colors.black.withOpacity(0.7), // 下部半透明深色
                          ],
                          stops: const [0.3, 1.0], // 渐变从底部 70% 处开始
                        ),
                      ),
                      child: Text(
                        content.text, // 假设 BookPage 结构中有 text 字段
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          // 白色文字，与深色蒙层形成对比
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            // 添加柔和阴影，即使在较亮的图片部分也能清晰可见
                            Shadow(
                              offset: Offset(1.0.w, 1.0.w),
                              blurRadius: 3.0.r,
                              color: const Color.fromARGB(150, 0, 0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3, // 限制行数
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 顶部导航
  Widget _buildTopBar(BuildContext context, Book book, BookReaderState state) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        child: Row(
          children: [
            GlassButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.pop(),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                book.bookName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5A4C75), // 深紫色字体
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GlassButton(
              icon: state.isStarred
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              onTap: () {
                ref
                    .read(bookReaderViewModelProvider.notifier)
                    .starBook(book.bookId);
                ref.refresh(starBooksProvider);
              },
            ),
            SizedBox(width: 12.w), // 按钮间距
            GlassButton(
              icon: Icons.share,
              onTap: () => {
                ref
                    .read(bookReaderViewModelProvider.notifier)
                    .shareBookPdf(book.content, _pageKeys, book.bookName),
              },
            ),
          ],
        ),
      ),
    );
  }

  // 底部内容面板
  Widget _buildBottomPanel(BookPage content, int totalPage, int displayIndex) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5.r,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7090B0).withOpacity(0.1),
                blurRadius: 20.r,
                offset: Offset(0, 10.r),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F9F), // 强调色，类似截图中的VIP/Search按钮
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "Page $displayIndex / $totalPage",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable:
                        StreamAudioPlayerManager.instance.isPlayingNotifier,
                    builder: (context, isPlaying, child) {
                      return GestureDetector(
                        onTap: () {
                          if (isPlaying) {
                            StreamAudioPlayerManager.instance.stopPlay();
                          } else {
                            StreamAudioPlayerManager.instance.streamPlayAudio(
                              content.text,
                            );
                          }
                        },
                        child: isPlaying
                            ? SizedBox(
                                width: 30.w,
                                height: 30.w,
                                child: rive.RiveAnimation.asset(
                                  'assets/riv/anim_audio_wave.riv',
                                ),
                              )
                            : Icon(Icons.volume_up, size: 30.w),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.w),
              // 进度条
              LinearProgressIndicator(
                value: displayIndex / totalPage,
                backgroundColor: const Color(0xFFEFEFEF),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFBFA2FF),
                ),
                borderRadius: BorderRadius.circular(4.r),
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
        height: 56.w,
        width: 56.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7E59F6).withOpacity(0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.r),
            ),
          ],
        ),
        padding: EdgeInsets.all(3.w),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFFA1C9), Color(0xFFBFA2FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(Icons.face, color: Colors.white, size: 24.w),
        ),
      ),
    );
  }

  // 角色详情弹窗
  void _showCharactersSheet(
    BuildContext context,
    List<CharacterEmbedded> characters,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 300.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.w),
              Container(
                height: 5.w,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Text(
                  "登场角色",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final char = characters[index];
                    return Container(
                      width: 120.w,
                      margin: EdgeInsets.only(right: 16.w),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40.w,
                            backgroundColor: const Color(0xFFF0EBFF),
                            backgroundImage: NetworkImage(char.avatarUrl),
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            char.characterName.trim(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            char.desc,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.w),
            ],
          ),
        );
      },
    );
  }
}
