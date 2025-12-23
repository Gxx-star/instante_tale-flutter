import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/features/login/login_provider.dart';
import 'package:instant_tale/features/user/user_provider.dart';
import 'package:instant_tale/ui/component/book_card_star.dart';
import 'package:instant_tale/ui/component/bottom_navigation_item.dart';
import 'package:instant_tale/ui/component/stat_item.dart';
import '../../config/main_page_config.dart';
import '../../database/models/book.dart';
import '../../database/models/character.dart';
import '../../features/character/character_provider.dart';
import '../../main.dart';
import '../component/add_character_card.dart';
import '../component/book_card.dart';
import '../component/character_card.dart';
import '../component/circular_button.dart';
import '../component/my_snackbar.dart';
import '../component/promo_button.dart';
import '../component/ranking_item_card.dart';
import '../component/reading_item_card.dart';
import '../component/setting_item.dart';
import '../component/square_item_card.dart';
import '../component/stat_card.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final _currentIndexProvider = StateProvider<int>((ref) => 0);

  @override
  void initState() {
    super.initState();
    // 延迟到页面构建完成之后执行
    Future.microtask(
      () => ref.read(characterViewModelProvider.notifier).fetchCharacter(),
    );
    Future.microtask(
      () => ref.read(bookReaderViewModelProvider.notifier).fetchBookList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterViewModel = ref.read(characterViewModelProvider.notifier);
    final currentIndex = ref.watch(_currentIndexProvider);
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: bookReaderViewModelProvider,
    );
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: characterViewModelProvider,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: IndexedStack(
        index: currentIndex,
        children: [HomePage(), MyPage()],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 10.h),
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1.w,
              blurRadius: 10.w,
              offset: Offset(0, -5.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  ref.read(_currentIndexProvider.notifier).state = 0;
                },
                child: Container(
                  alignment: Alignment.center,
                  child: BottomNavigationItem(
                    icon: Icons.home,
                    label: '首页',
                    isActive: currentIndex == 0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  ref.read(_currentIndexProvider.notifier).state = 1;
                },
                child: Container(
                  alignment: Alignment.center,
                  child: BottomNavigationItem(
                    icon: Icons.person_outline,
                    label: '我的',
                    isActive: currentIndex == 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: RawMaterialButton(
        fillColor: Colors.pinkAccent,
        splashColor: Colors.pinkAccent.withOpacity(0.5),
        focusColor: Colors.pinkAccent.withOpacity(0.3),
        // 聚焦时变浅（无障碍优化）
        hoverColor: Colors.pinkAccent.withOpacity(0.4),
        // 悬停时变浅（桌面端优化）
        elevation: 6,
        highlightElevation: 12,
        constraints: BoxConstraints(
          minWidth: 60.w,
          minHeight: 60.h,
          maxWidth: 60.w,
          maxHeight: 60.h,
        ),
        shape: CircleBorder(),
        // 保持完美圆形
        onPressed: () {
          context.push('/${AppRouteNames.createBook}');
        },
        child: Icon(Icons.add, size: 32.w, color: Colors.white),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.centerDocked,
        0,
        10.h,
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();
  final swiperImages = MainPageConfig.swiperImages;
  final FocusNode _searchFocusNode = FocusNode();

  Future<void> _preloadSwiperImages(List<String> swiperImages) async {
    if (swiperImages.isNotEmpty) {
      // 如果有多个预加载项futures可以并发预加载
      final futures = <Future<void>>[];
      for (var swiperImage in swiperImages) {
        futures.add(
          precacheImage(CachedNetworkImageProvider(swiperImage), context),
        );
      }
      await Future.wait(futures); // 等待所有图片加载完成
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadSwiperImages(swiperImages);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    final user = userState.user;
    final userViewModel = ref.watch(userViewModelProvider.notifier);
    final bookViewModel = ref.watch(bookReaderViewModelProvider.notifier);
    // 阅读记录
    final readingList = ref.watch(readingHistoryProvider);
    // 榜单
    final List<Map<String, dynamic>> rankingList = MainPageConfig.rankingList;
    // 绘本广场
    final List<Map<String, dynamic>> squareList = MainPageConfig.squareList;
    // 阅读时长
    int durationHours = 12;
    // 收藏数
    int collectionCount = 18;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // 加载动画
      );
    }
    return Stack(
      children: [
        // 背景板
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFFFF0F3)),
        ),
        // 主页面
        GestureDetector(
          onTap: () {
            if (_searchFocusNode.hasFocus) {
              _searchFocusNode.unfocus();
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部栏
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 15.h,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: NetworkImage(user.avatar),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SizedBox(
                            height: 40.h,
                            child: TextField(
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: '搜索绘本...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14.sp,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: const Color(0xffe374b6),
                                  size: 20.w,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0.r),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 轮播图
                  Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Container(
                      height: 180.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2.w,
                            blurRadius: 5.w,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Image(
                                image: CachedNetworkImageProvider(
                                  swiperImages[index],
                                ),
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          );
                        },
                        itemCount: swiperImages.length,
                        autoplay: true,
                        control: SwiperControl(color: Colors.white),
                      ),
                    ),
                  ),
                  // 统计已读、时长、收藏
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Row(
                      children: [
                        StatCard(
                          imgUrl: 'assets/images/jin_mao.png',
                          title: '已读',
                          value: '${readingList.value?.length}本',
                          color: Colors.green,
                          backgroundColor: Color(0xFFCFF0BF),
                        ),
                        SizedBox(width: 12.w),
                        StatCard(
                          imgUrl: 'assets/images/ke_ji.png',
                          title: '时长',
                          value: '${durationHours}h',
                          color: Colors.yellow.shade900,
                          backgroundColor: Color(0xFFFBE3A4),
                        ),
                        SizedBox(width: 12.w),
                        StatCard(
                          imgUrl: 'assets/images/cang_shu.png',
                          title: '收藏',
                          value: '$collectionCount本',
                          color: Colors.orange.shade900,
                          backgroundColor: Color(0xFFFBD9CE),
                        ),
                      ],
                    ),
                  ),
                  // 圆形卡片导航项
                  SizedBox(height: 18.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircularButton(
                          imgUrl: 'assets/images/mei_shu.png',
                          label: '创建绘本',
                          color: Colors.white,
                          // color: Color(0xFFF472B6),
                          onTap: () {
                            context.push('/${AppRouteNames.createBook}');
                          },
                        ),
                        CircularButton(
                          imgUrl: 'assets/images/dian_shi.png',
                          label: '绘本广场',
                          color: Colors.white,
                          // color: Color(0xFFA78BFA),
                          onTap: () {
                            context.push('/${AppRouteNames.bookSquare}');
                          },
                        ),
                        CircularButton(
                          imgUrl: 'assets/images/pin_tu.png',
                          label: '我的作品',
                          color: Colors.white,
                          // color: Color(0xFF38BDF8),
                          onTap: () {
                            context.push('/${AppRouteNames.myBooksPage}');
                          },
                        ),
                        const CircularButton(
                          imgUrl: 'assets/images/wan_ju_ya.png',
                          label: '浏览历史',
                          color: Colors.white,
                          // color: Color(0xFFFBBF24),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // 广告牌
                  const PromoButton(),
                  SizedBox(height: 20.h),

                  // 阅读记录模块
                  readingList.when(
                    data: (readingList) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 标题行：时钟 Icon, 文本, 更多按钮
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0.w,
                              vertical: 8.0.h,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 6.w),
                                Text(
                                  '继续阅读',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          // 可滑动的卡片列表
                          SizedBox(
                            height: readingList.isEmpty ? 0.h : 200.h,
                            // 设定高度以便 ListView 正确显示
                            child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: readingList.length,
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              itemBuilder: (context, index) {
                                final item = readingList[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == readingList.length - 1
                                        ? 0
                                        : 12.0.w,
                                  ),
                                  child: ReadingItemCard(
                                    title: item.bookName,
                                    imageUrl: item.bookCover,
                                    callback: () async{
                                      final book = await ref
                                          .read(bookSquareViewModelProvider.notifier)
                                          .findBookById(item.bookId);
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
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
                    error: (e, s) {
                      return Text('error,$e');
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 20.h),

                  // 热门榜单
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题行：增长箭头 Icon, 文本, 更多按钮
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: Row(
                            children: [
                              // 粉色增长箭头
                              SizedBox(width: 6.w),
                              Text(
                                '热门榜单',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const Spacer(),
                              // 更多按钮
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(50.w, 20.h),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: Colors.grey[500],
                                ),
                                child: Text(
                                  '更多 >',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 榜单卡片列表 (竖直排列)
                        ...rankingList.map((item) {
                          return RankingItemCard(
                            rank: item['rank'] as int,
                            title: item['title'] as String,
                            description: item['description'] as String,
                            imageUrl: item['imageUrl'] as String,
                            likes: item['likes'] as int,
                            reads: item['reads'] as double,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // 绘本广场模块
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题行：广场 Icon, 文本, 更多按钮
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: Row(
                            children: [
                              // 新增：广场图标 (使用 'apps' 或 'grid_view')
                              SizedBox(width: 6.w),
                              Text(
                                '绘本广场',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const Spacer(),
                              // 更多按钮
                              TextButton(
                                onPressed: () {
                                  context.push(
                                    '/${AppRouteNames.bookSquare}',
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(50.w, 20.h),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: Colors.grey[500],
                                ),
                                child: Text(
                                  '更多 >',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 2x2 网格布局
                        GridView.builder(
                          // 关键属性：防止 GridView 在 SingleChildScrollView 内部滚动
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: squareList.length,
                          // 4个项目
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2列
                                crossAxisSpacing: 12.w, // 水平间距
                                mainAxisSpacing: 12.h, // 垂直间距
                                childAspectRatio: 0.6, // 宽高比 (宽度/高度)，使其纵向更长
                              ),
                          itemBuilder: (context, index) {
                            final item = squareList[index];
                            return SquareItemCard(
                              title: item['title'] as String,
                              author: item['author'] as String,
                              imageUrl: item['imageUrl'] as String,
                              tagText: item['tagText'] as String,
                              tagColor: item['tagColor'] as Color,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.h), // 为底部导航栏留出空间
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  Future<void> _preloadCharacters(List<CharacterCollection> characters) async {
    if (characters.isNotEmpty) {
      final futures = <Future<void>>[];
      for (var character in characters) {
        if (character.avatarUrl.isNotEmpty) {
          futures.add(
            precacheImage(
              CachedNetworkImageProvider(character.avatarUrl),
              context,
            ),
          );
        }
        if (character.threeViewUrl.isNotEmpty) {
          futures.add(
            precacheImage(
              CachedNetworkImageProvider(character.threeViewUrl),
              context,
            ),
          );
        }
      }
      await Future.wait(futures);
    }
  }

  Future<void> _preloadBooks(List<Book> books) async {
    if (books.isNotEmpty) {
      final futures = <Future<void>>[];
      for (var book in books) {
        if (book.coverUrl.isNotEmpty) {
          futures.add(
            precacheImage(CachedNetworkImageProvider(book.coverUrl), context),
          );
        }
      }
      await Future.wait(futures);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(characterListProvider, (previous, next) {
        if (next is AsyncData && next.value != null) {
          _preloadCharacters(next.value!); // 数据就绪后执行预加载
        }
      });
      ref.listenManual(booksProvider, (previous, next) {
        if (next is AsyncData && next.value != null) {
          _preloadBooks(next.value!); // 数据就绪后执行预加载
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterViewModel = ref.read(characterViewModelProvider.notifier);
    final settingsData = MainPageConfig.settingsData;
    final userState = ref.read(userViewModelProvider);
    final user = userState.user;
    final userViewModel = ref.read(userViewModelProvider.notifier);
    ref.listen<String?>(
      userViewModelProvider.select((state) => state.message),
      (previous, next) {
        if (next != null) {
          MySnackBar.show(context, next);
        }
      },
    );
    final showAvatarVipBadge = true;
    final showUsernameVipBadge = true;
    final isVipMember = true;
    final vipExpiryDate = "2099-99-99";
    final books = ref.watch(booksProvider);
    final starBooks = ref.watch(starBooksProvider);
    final topThreeFavorites = [];
    final characters = ref.watch(characterListProvider);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFFFF0F3)),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                // 个人资料
                Container(
                  padding: EdgeInsets.all(20.0.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10.w,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 顶部信息：头像、文本、编辑按钮
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 左侧：头像 + 皇冠
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5.w,
                                      ),
                                    ],
                                  ),
                                  child: user == null
                                      ? CircularProgressIndicator()
                                      : CircleAvatar(
                                          radius: 36.r,
                                          backgroundImage: NetworkImage(
                                            user.avatar,
                                          ),
                                          backgroundColor: Colors.grey[200],
                                        ),
                                ),
                                onTap: () {
                                  context.push(
                                    '/${AppRouteNames.editProfilePage}',
                                  );
                                },
                              ),

                              if (showAvatarVipBadge)
                                Positioned(
                                  bottom: -5.h,
                                  right: -5.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0C75A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.w,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.workspace_premium,
                                      color: Colors.white,
                                      size: 16.w,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 14.w),
                          // 2. 中间：文本信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 第 1 行: 用户名 + VIP 标签
                                Row(
                                  children: [
                                    Text(
                                      user?.name ?? "未命名",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    if (showUsernameVipBadge)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF0C75A),
                                          borderRadius: BorderRadius.circular(
                                            5.r,
                                          ),
                                        ),
                                        child: Text(
                                          'VIP',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                // 第 2 行: ID
                                Text(
                                  'ID: ${user?.userId}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                // 第 3 行: 统计数据 (使用 StatItem 组件)
                                Row(
                                  children: [
                                    StatItem(
                                      imgUrl: 'assets/images/bao_bao.jpg',
                                      text: '${characters.value?.length}个\n宝宝',
                                    ),
                                    SizedBox(width: 30.w),
                                    StatItem(
                                      imgUrl: 'assets/images/book.jpg',
                                      text: '${books.value?.length}本\n绘本',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // 3. 右侧：编辑按钮
                          Container(
                            width: 34.0.w,
                            height: 34.0.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.w,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.grey[700],
                                size: 18.0.w,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints.tightFor(
                                width: 34.0.w,
                                height: 34.0.h,
                              ),
                              onPressed: () {
                                context.push(
                                  '/${AppRouteNames.editProfilePage}',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // 底部 VIP 横幅
                      if (true)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFBE6),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Color(0xFFE6A23C).withOpacity(0.5),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: isVipMember
                                      ? Color(0xFFF0C75A)
                                      : Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.workspace_premium_outlined,
                                  color: Colors.white,
                                  size: 24.w,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VIP会员',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '有效期至 $vipExpiryDate',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF0C75A),
                                  foregroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  '续费',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // 我的绘本
                SizedBox(height: 16.h),
                Column(
                  children: [
                    // 头部标题和查看全部按钮
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                      child: Row(
                        children: [
                          // 左侧：Icon + 文本
                          SizedBox(width: 4.w),
                          Text(
                            '我的绘本',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          // 右侧：查看全部 > 按钮
                          TextButton(
                            onPressed: () {
                              context.push('/${AppRouteNames.myBooksPage}');
                            },
                            style: TextButton.styleFrom(
                              alignment: Alignment.centerRight,
                              foregroundColor: Colors.grey[700],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '查看全部 >',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                //1Icon(Icons.arrow_forward_ios, size: 14,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 绘本列表 (只展示前三项)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 使用 BookCard 组件
                      children: books.when(
                        data: (books) {
                          var bookWidgets = books
                              .take(3)
                              .map<Widget>((book) => BookCard(book: book))
                              .toList();
                          while (bookWidgets.length < 3) {
                            bookWidgets.add(Spacer());
                          }
                          return bookWidgets;
                        },
                        error: (error, stack) => [Text('Error:$error')],
                        loading: () => [CircularProgressIndicator()],
                      ),
                    ),
                  ],
                ),
                // 我的收藏
                SizedBox(height: 16.h),
                Column(
                  children: [
                    // 头部标题和查看全部按钮
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                      // 【修改】水平 padding 调整为 0.0
                      child: Row(
                        children: [
                          SizedBox(width: 4.w),
                          Text(
                            '我的收藏',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerRight,
                              foregroundColor: Colors.grey[700],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '查看全部 >',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                //Icon(Icons.arrow_forward_ios, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // 收藏列表 (只展示前三项)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 使用 BookCard 组件
                      children: starBooks.when(
                        data: (starBooks) {
                          var bookWidgets = starBooks
                              .take(3)
                              .map<Widget>((starBook) => BookCardStar(book: starBook))
                              .toList();
                          while (bookWidgets.length < 3) {
                            bookWidgets.add(Spacer());
                          }
                          return bookWidgets;
                        },
                        error: (error, stack) => [Text('Error:$error')],
                        loading: () => [CircularProgressIndicator()],
                      ),
                    )
                  ],
                ),
                // 我的人物
                SizedBox(height: 16.h),
                Column(
                  children: [
                    // 头部标题和查看管理按钮 (Padding 4.0, 使得左侧边缘距 SingleChildScrollView 的 16.0 边界为 20.0)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                      // 【修改】水平 padding 调整为 0.0
                      child: Row(
                        children: [
                          // 左侧：Icon + 文本
                          SizedBox(width: 4.w),
                          Text(
                            '我的人物',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          // 右侧：查看管理 > 按钮
                          TextButton(
                            onPressed: () {
                              context.push(
                                '/${AppRouteNames.characterManagementPage}',
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerRight,
                              foregroundColor: Colors.grey[700],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('管理 >', style: TextStyle(fontSize: 14.sp)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 可水平滑动的 List
                    SizedBox(
                      height: MediaQuery.of(context).size.shortestSide >= 600
                          ? 260.h
                          : 190.h,
                      child: characters.when(
                        data: (data) {
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.shortestSide >=
                                        600
                                    ? 240.h
                                    : 170.h, // 卡片实际高度
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(left: 0.0.w),
                                  // 总数 = 1个添加按钮 + 排序后的人物列表
                                  itemCount: 1 + data.length,
                                  itemBuilder: (context, index) {
                                    // 第一个内容固定是“添加人物”按钮
                                    if (index == 0) {
                                      // AddCharacterCard 内部移除了左侧 4.0 padding，确保第一张卡片紧贴 20.0 边缘
                                      return AddCharacterCard();
                                    }
                                    // 之后是人物卡片
                                    final character = data[index - 1];
                                    return CharacterCard(character: character);
                                  },
                                ),
                              ),
                              SizedBox(height: 8.h), // 卡片和滑动条的间距
                            ],
                          );
                        },
                        error: (error, stack) => Text('Error:$error'),
                        loading: () => CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
                // 设置项
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 头部标题：设置 Icon + 账号管理 文本
                    Padding(
                      // 【修改】水平 padding 调整为 0.0，以使设置按钮横向更长
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.0.w,
                        vertical: 8.0.h,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 4.w),
                          Text(
                            '账号管理',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 按钮列表
                    ...settingsData.map((item) {
                      return SettingItem(
                        iconData: item['iconData'] as IconData,
                        iconColor: item['iconColor'] as Color,
                        iconBackgroundColor:
                            item['iconBackgroundColor'] as Color,
                        title: item['title'] as String,
                        subtitle: item['subtitle'] as String,
                        onTap: () {
                          switch (item['title']) {
                            case '个人资料':
                              context.push('/${AppRouteNames.editProfilePage}');
                              break;
                            case '通知设置':
                              MySnackBar.show(context, '功能开发中');
                              break;
                            case '隐私与安全':
                              context.push(
                                '/${AppRouteNames.privacySecurityPage}',
                              );
                              break;
                            case '帮助与反馈':
                              MySnackBar.show(context, '功能开发中');
                              break;
                            case '关于我们':
                              MySnackBar.show(context, '功能开发中');
                              break;
                          }
                        },
                      );
                    }),
                  ],
                ),
                // 退出登录
                Container(
                  height: 45.0.h,
                  margin: EdgeInsets.symmetric(horizontal: 0.0.w),
                  // 移除水平间距 (原 4.0)
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0.r),
                    border: Border.all(
                      color: Color(0xFFE57373).withOpacity(0.4),
                      // 粉色边框 (使用 _logoutRed 红色以示警告)
                      width: 1.2.w,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent, // 确保水波纹效果可见
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0.r),
                      onTap: () async {
                        await AppGlobals().clearTokens();
                        await AppGlobals().isar.writeTxn(() async {
                          await AppGlobals().isar.users.clear();
                        });
                        ref.read(loginViewModelProvider.notifier).logout();
                        ref.read(userViewModelProvider.notifier).logout();
                        if (mounted) {
                          context.go('/${AppRouteNames.login}');
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // 使 Row 宽度适应其内容
                          children: [
                            // 登出 Icon
                            Icon(
                              Icons.exit_to_app, // 登出 Icon
                              color: Color(0xFFE57373), // 粉色/红色字体
                              size: 22.w, // 略微减小 Icon 尺寸 (原 24)
                            ),
                            SizedBox(width: 8.w),
                            // 退出登录 文本
                            Text(
                              '退出登录',
                              style: TextStyle(
                                fontSize: 15.sp,
                                // 减小字体 (原 16)
                                fontWeight: FontWeight.w500,
                                // 【修改】字体偏细 (原 w600)
                                color: Color(0xFFE57373), // 粉色/红色字体
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class NoScalingAnimation extends FloatingActionButtonAnimator {
  late double _x;
  late double _y;

  @override
  Offset getOffset({
    required Offset begin,
    required Offset end,
    required double progress,
  }) {
    _x = begin.dx + (end.dx - begin.dx) * progress;
    _y = begin.dy + (end.dy - begin.dy) * progress;
    return Offset(_x, _y);
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}
