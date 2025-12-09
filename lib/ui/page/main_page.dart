import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:instant_tale/features/book/book_provider.dart';
import 'package:instant_tale/features/login/login_provider.dart';
import 'package:instant_tale/features/user/user_provider.dart';
import 'package:instant_tale/ui/component/bottom_navigation_item.dart';
import 'package:instant_tale/ui/component/stat_item.dart';
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
  const MainPage({Key? key}) : super(key: key);

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
      () => ref.read(bookViewModelProvider.notifier).fetchBookList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _characterViewModel = ref.watch(characterViewModelProvider.notifier);
    final _currentIndex = ref.watch(_currentIndexProvider);
    ref.listen<String?>(
      bookViewModelProvider.select((state) => state.message),
      (previous, next) {
        if (next != null) {
          MySnackBar.show(context, next);
        }
      },
    );
    ref.listen<String?>(
      characterViewModelProvider.select((state) => state.message),
      (previous, next) {
        if (next != null) {
          MySnackBar.show(context, next);
        }
      },
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: IndexedStack(
        index: _currentIndex,
        children: [HomePage(), MyPage()],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
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
                    isActive: _currentIndex == 0,
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
                    isActive: _currentIndex == 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        //margin: EdgeInsets.only(bottom: 50), // 向下移动 40px（可按需调整数值）
        child: RawMaterialButton(
          fillColor: Colors.pinkAccent,
          splashColor: Colors.pinkAccent.withOpacity(0.5),
          focusColor: Colors.pinkAccent.withOpacity(0.3),
          // 聚焦时变浅（无障碍优化）
          hoverColor: Colors.pinkAccent.withOpacity(0.4),
          // 悬停时变浅（桌面端优化）
          elevation: 6,
          highlightElevation: 12,
          constraints: BoxConstraints(
            minWidth: 60,
            minHeight: 60,
            maxWidth: 60,
            maxHeight: 60,
          ),
          shape: CircleBorder(),
          // 保持完美圆形
          onPressed: () {
            context.push('/${AppRouteNames.createBook}');
          },
          child: Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.centerDocked,
        0,
        10,
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  final swiperImages = [
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-c523e00b552859928cef368b7b77e566.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-14f0801056b5516cb69a762f62b60ae0.png',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-09d03e52070451ce993880bff5484b08.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-429fed69e4a55c08841eaac1ed81dfe0.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-5c29d9ed9583598ba4ecabb63569231c.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-3fbf8ae1450353c2ad9db108c587d00a.jpg',
  ];

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
  Widget build(BuildContext context) {
    final _userState = ref.watch(userViewModelProvider);
    final _user = _userState.user;
    final _userViewModel = ref.watch(userViewModelProvider.notifier);
    final _bookViewModel = ref.watch(bookViewModelProvider.notifier);
    // 阅读记录
    final _readingList = ref.watch(readingHistoryProvider);
    // 榜单
    final List<Map<String, dynamic>> _rankingList = [
      {
        'rank': 1,
        'title': '森林里的秘密',
        'description': '自然故事家',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-30057b9671fa544bab038cb83c3215ec.jpg',
        'likes': 9, // 0.9k
        'reads': 12.5, // 12.5k
      },
      {
        'rank': 2,
        'title': '魔法世界探险',
        'description': '魔法创作者',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-c0312588d70f5a238877ef88b3e6bbb9.jpg',
        'likes': 19, // 1.9k
        'reads': 23.5, // 23.5k
      },
      {
        'rank': 3,
        'title': '海洋生物图鉴',
        'description': '小小科学家',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-a723f22b34355ddca9ba2fb08d720ef4.jpg',
        'likes': 5, // 0.5k
        'reads': 8.2, // 8.2k
      },
    ];
    // 绘本广场
    final List<Map<String, dynamic>> _squareList = [
      {
        'title': '彩色的梦想',
        'author': '梦想家',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-99bf8f20d53f5995bd41150fa8fdb17b.jpg',
        'tagText': '热门',
        'tagColor': Color(0xFFE91E63),
      },
      {
        'title': '奇妙之旅',
        'author': '旅行者',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-cef72bbabead5df8beb38a5bc4306b57.jpg',
        'tagText': '推荐',
        'tagColor': Color(0xFF673AB7),
      },
      {
        'title': '动物王国',
        'author': '自然之友',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-935a7e64393a5719837d03ad2d0aca4b.jpg',
        'tagText': '新品',
        'tagColor': Color(0xFF4CAF50),
      },
      {
        'title': '星空物语',
        'author': '星空讲述者',
        'imageUrl':
            'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-70c6ff6d13f65be1af553703c9d0348c.jpg',
        'tagText': '精选',
        'tagColor': Color(0xFF2196F3), // 精选 (蓝色)
      },
    ];
    int readCount = 24; // 阅读数
    int durationHours = 12; // 阅读时长
    int collectionCount = 18; // 收藏数
    if (_user == null) {
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
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部栏
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(_user!.avatar),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '搜索绘本...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xffe374b6),
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Swiper(
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image(
                              image: CachedNetworkImageProvider(swiperImages[index]),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      StatCard(
                        imgUrl: 'assets/images/jin_mao.png',
                        title: '已读',
                        value: '${_readingList.value?.length}本',
                        color: Colors.green,
                        backgroundColor: Color(0xFFCFF0BF),
                      ),
                      const SizedBox(width: 12),
                      StatCard(
                        imgUrl: 'assets/images/ke_ji.png',
                        title: '时长',
                        value: '${durationHours}h',
                        color: Colors.yellow.shade900,
                        backgroundColor: Color(0xFFFBE3A4),
                      ),
                      const SizedBox(width: 12),
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
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                const SizedBox(height: 18),

                // 广告牌
                const PromoButton(),
                const SizedBox(height: 20),

                // 阅读记录模块
                _readingList.when(
                  data: (readingList) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题行：时钟 Icon, 文本, 更多按钮
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              Text(
                                '继续阅读',
                                style: TextStyle(
                                  fontSize: 16,
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
                          height: 200, // 设定高度以便 ListView 正确显示
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: readingList.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            itemBuilder: (context, index) {
                              final item = readingList[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == readingList.length - 1
                                      ? 0
                                      : 12.0,
                                ),
                                child: ReadingItemCard(
                                  title: item.book.bookName,
                                  imageUrl: item.book.coverUrl,
                                  callback: () {
                                    final userId = ref.watch(userViewModelProvider).user?.userId;
                                    if (userId == null) {
                                      context.go('/${AppRouteNames.login}');
                                      return;
                                    }
                                    ref
                                        .read(bookViewModelProvider.notifier)
                                        .loadBook(item.book,userId);
                                    context.push(
                                      '/${AppRouteNames.bookReader}',
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
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
                const SizedBox(height: 20),

                // 热门榜单
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题行：增长箭头 Icon, 文本, 更多按钮
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // 粉色增长箭头
                            const SizedBox(width: 6),
                            Text(
                              '热门榜单',
                              style: TextStyle(
                                fontSize: 16,
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
                                minimumSize: const Size(50, 20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: Colors.grey[500],
                              ),
                              child: const Text(
                                '更多 >',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 榜单卡片列表 (竖直排列)
                      ..._rankingList.map((item) {
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
                const SizedBox(height: 20),

                // 绘本广场模块
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题行：广场 Icon, 文本, 更多按钮
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // 新增：广场图标 (使用 'apps' 或 'grid_view')
                            const SizedBox(width: 6),
                            Text(
                              '绘本广场',
                              style: TextStyle(
                                fontSize: 16,
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
                                minimumSize: const Size(50, 20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: Colors.grey[500],
                              ),
                              child: const Text(
                                '更多 >',
                                style: TextStyle(fontSize: 14),
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
                        itemCount: _squareList.length,
                        // 4个项目
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2列
                              crossAxisSpacing: 12, // 水平间距
                              mainAxisSpacing: 12, // 垂直间距
                              childAspectRatio: 0.6, // 宽高比 (宽度/高度)，使其纵向更长
                            ),
                        itemBuilder: (context, index) {
                          final item = _squareList[index];
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
                const SizedBox(height: 100), // 为底部导航栏留出空间
              ],
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
    final _characterViewModel = ref.watch(characterViewModelProvider.notifier);
    final List<SettingItem> _settingsData = [
      SettingItem(
        iconData: Icons.person_outline,
        iconColor: const Color(0xFF42A5F5),
        // 蓝色
        iconBackgroundColor: const Color(0xFFE3F2FD),
        // 浅蓝色
        title: '个人资料',
        subtitle: '编辑昵称、头像等信息',
        onTap: () {
          // 进入个人资料
          context.push('/${AppRouteNames.editProfilePage}');
        },
      ),
      SettingItem(
        iconData: Icons.notifications_none,
        iconColor: Color(0xFFAB47BC),
        // 紫色
        iconBackgroundColor: Color(0xFFF3E5F5),
        // 浅紫色
        title: '通知设置',
        subtitle: '管理推送通知',
        onTap: () {
          MySnackBar.show(context, '功能开发中');
        },
      ),
      SettingItem(
        iconData: Icons.security,
        // 更换为盾牌 icon
        iconColor: Color(0xFF66BB6A),
        // 翠绿色
        iconBackgroundColor: Color(0xFFE8F5E9),
        // 浅绿色
        title: '隐私与安全',
        subtitle: '密码、隐私设置',
        onTap: () {
          context.push('/${AppRouteNames.privacySecurityPage}');
        },
      ),
      SettingItem(
        iconData: Icons.help_outline,
        iconColor: Color(0xFFFF7043),
        // 橙色
        iconBackgroundColor: Color(0xFFFFF3E0),
        // 浅橙色
        title: '帮助与反馈',
        subtitle: '常见问题、联系客服',
        onTap: () {
          MySnackBar.show(context, '功能开发中');
        },
      ),
      SettingItem(
        iconData: Icons.star_outline,
        iconColor: Color(0xFFFFCA28),
        // 深黄色
        iconBackgroundColor: Color(0xFFFFFDE7),
        // 浅黄色
        title: '关于我们',
        subtitle: '版本 1.0.0',
        onTap: () {
          MySnackBar.show(context, '功能开发中');
        },
      ),
    ];
    final _userState = ref.watch(userViewModelProvider);
    final _user = _userState.user;
    final _userViewModel = ref.watch(userViewModelProvider.notifier);
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
    final favoriteCount = 5;
    final books = ref.watch(booksProvider);
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
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 8),
                // 个人资料
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
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
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 36,
                                    backgroundImage: NetworkImage(
                                      '${_user!.avatar}',
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
                                  bottom: -5,
                                  right: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0C75A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.workspace_premium,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
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
                                      '${_user!.name}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    if (showUsernameVipBadge)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF0C75A),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: const Text(
                                          'VIP',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                // 第 2 行: ID
                                Text(
                                  'ID: ${_user!.userId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // 第 3 行: 统计数据 (使用 StatItem 组件)
                                Row(
                                  children: [
                                    StatItem(
                                      imgUrl: 'assets/images/bao_bao.jpg',
                                      text: '${characters.value?.length}个\n宝宝',
                                    ),
                                    const SizedBox(width: 30),
                                    StatItem(
                                      imgUrl: 'assets/images/book.jpg',
                                      text: '${books.value?.length}本\n绘本',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 3. 右侧：编辑按钮
                          Container(
                            width: 34.0,
                            height: 34.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.grey[700],
                                size: 18.0,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints.tightFor(
                                width: 34.0,
                                height: 34.0,
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
                      SizedBox(height: 20),
                      // 底部 VIP 横幅
                      if (true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFBE6),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFFE6A23C).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isVipMember
                                      ? Color(0xFFF0C75A)
                                      : Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.workspace_premium_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'VIP会员',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '有效期至 $vipExpiryDate',
                                    style: TextStyle(
                                      fontSize: 12,
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  elevation: 2,
                                ),
                                child: const Text(
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
                const SizedBox(height: 16),
                Column(
                  children: [
                    // 头部标题和查看全部按钮
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          // 左侧：Icon + 文本
                          const SizedBox(width: 4),
                          Text(
                            '我的绘本',
                            style: TextStyle(
                              fontSize: 16,
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('查看全部 >', style: TextStyle(fontSize: 14)),
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
                          var bookWidgets = books.take(3).map<Widget>((book)=>BookCard(book: book)).toList();
                          while(bookWidgets.length < 3){
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
                const SizedBox(height: 16),
                Column(
                  children: [
                    // 头部标题和查看全部按钮
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      // 【修改】水平 padding 调整为 0.0
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Text(
                            '我的收藏',
                            style: TextStyle(
                              fontSize: 16,
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('查看全部 >', style: TextStyle(fontSize: 14)),
                                //Icon(Icons.arrow_forward_ios, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 收藏列表 (只展示前三项)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: topThreeFavorites.map((book) {
                        return BookCard(
                          book: book,
                          showPageCount: false, // 不显示页数
                          showFavoriteIcon: true, // 显示爱心
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // 我的人物
                const SizedBox(height: 16),
                Column(
                  children: [
                    // 头部标题和查看管理按钮 (Padding 4.0, 使得左侧边缘距 SingleChildScrollView 的 16.0 边界为 20.0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      // 【修改】水平 padding 调整为 0.0
                      child: Row(
                        children: [
                          // 左侧：Icon + 文本
                          const SizedBox(width: 4),
                          Text(
                            '我的人物',
                            style: TextStyle(
                              fontSize: 16,
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('管理 >', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 可水平滑动的 List
                    SizedBox(
                      height: 190, // 设定一个合适的高度 (卡片 160 + padding/滑动条 30)
                      child: characters.when(
                        data: (data) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 170, // 卡片实际高度
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(left: 0.0),
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
                              const SizedBox(height: 8), // 卡片和滑动条的间距
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Text(
                            '账号管理',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 按钮列表
                    ..._settingsData.map((item) {
                      return SettingItem(
                        iconData: item.iconData,
                        iconColor: item.iconColor,
                        iconBackgroundColor: item.iconBackgroundColor,
                        title: item.title,
                        subtitle: item.subtitle,
                        onTap: () {
                          item.onTap();
                        },
                      );
                    }).toList(),
                  ],
                ),
                // 退出登录
                Container(
                  height: 45.0,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  // 移除水平间距 (原 4.0)
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Color(0xFFE57373).withOpacity(0.4),
                      // 粉色边框 (使用 _logoutRed 红色以示警告)
                      width: 1.2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent, // 确保水波纹效果可见
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () async{
                        await AppGlobals().clearTokens();
                        await AppGlobals().isar.writeTxn(()async{
                          await AppGlobals().isar.users.clear();
                        });
                        ref.read(loginViewModelProvider.notifier).logout();
                        ref.read(userViewModelProvider.notifier).logout();
                        if(mounted){
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
                              size: 22, // 略微减小 Icon 尺寸 (原 24)
                            ),
                            const SizedBox(width: 8),
                            // 退出登录 文本
                            Text(
                              '退出登录',
                              style: TextStyle(
                                fontSize: 15,
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
                const SizedBox(height: 16),
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
