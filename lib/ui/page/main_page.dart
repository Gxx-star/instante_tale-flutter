import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/ui/component/bottom_navigation_item.dart';

import '../component/circular_button.dart';
import '../component/progress_indicator_bar.dart';
import '../component/promo_button.dart';
import '../component/ranking_item_card.dart';
import '../component/reading_item_card.dart';
import '../component/square_item_card.dart';
import '../component/stat_card.dart';

class MainPage extends ConsumerWidget {
  final _currentIndexProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = ref.watch(_currentIndexProvider);
    return Scaffold(
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
            GestureDetector(
              onTap: () {
                ref.read(_currentIndexProvider.notifier).state = 0;
              },
              child: BottomNavigationItem(
                icon: Icons.home,
                label: '首页',
                isActive: _currentIndex == 0,
              ),
            ),
            // 位于中心的浮动按钮
            GestureDetector(
              onTap: () {
                ref.read(_currentIndexProvider.notifier).state = 1;
              },
              child: BottomNavigationItem(
                icon: Icons.person_outline,
                label: '我的',
                isActive: _currentIndex == 1,
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
          onPressed: () {},
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

class HomePage extends ConsumerWidget {
  final _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 阅读记录
    final List<Map<String, dynamic>> _readingList = [
      {
        'title': '好朋友的冒险',
        'imageUrl':
            'https://tse3.mm.bing.net/th/id/OIP.IrxJ0bSPmY0aW7-mfCrXhgHaKE?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'progress': 0.7,
      },
      {
        'title': '晚安故事集',
        'imageUrl':
            'https://tse1.explicit.bing.net/th/id/OIP.ZR-CgWMl9Iay6w3bToF7WgHaHa?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'progress': 0.45,
      },
      {
        'title': '勇敢小英雄',
        'imageUrl':
            'https://tse1.mm.bing.net/th/id/OIP.1CYDxdrMeTOd3J7SyTE2EAHaHZ?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'progress': 0.9,
      },
      {
        'title': '星际探索者',
        'imageUrl':
            'https://tse1.mm.bing.net/th/id/OIP.cT3fO0r-vTVGfWQ7zqiojgHaHi?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'progress': 0.2,
      },
    ];
    // 榜单
    final List<Map<String, dynamic>> _rankingList = [
      {
        'rank': 1,
        'title': '森林里的秘密',
        'description': '自然故事家',
        'imageUrl':
            'https://tse1.mm.bing.net/th/id/OIP.m_45x3j99nK5j1wX8nF45AHaHa?rs=1&pid=ImgDetMain',
        'likes': 9, // 0.9k
        'reads': 12.5, // 12.5k
      },
      {
        'rank': 2,
        'title': '魔法世界探险',
        'description': '魔法创作者',
        'imageUrl':
            'https://tse2.mm.bing.net/th/id/OIP.zQvY5R3Z_2kF-y9Vl27y5gHaHa?rs=1&pid=ImgDetMain',
        'likes': 19, // 1.9k
        'reads': 23.5, // 23.5k
      },
      {
        'rank': 3,
        'title': '海洋生物图鉴',
        'description': '小小科学家',
        'imageUrl':
            'https://tse1.mm.bing.net/th/id/OIP.b01-M8lF5v_82X9_wH_Q-AAAAA?rs=1&pid=ImgDetMain',
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
            'https://tse3.mm.bing.net/th/id/OIP.EIJplBRKzZiXAnpLCWn6VwHaHI?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'tagText': '热门',
        'tagColor': Color(0xFFE91E63), // 热门 (粉色)
      },
      {
        'title': '奇妙之旅',
        'author': '旅行者',
        'imageUrl':
            'https://tse2.mm.bing.net/th/id/OIP.kd_I0Ipb4W1dhnnle6OfrgHaHE?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'tagText': '推荐',
        'tagColor': Color(0xFF673AB7), // 推荐 (紫色)
      },
      {
        'title': '动物王国',
        'author': '自然之友',
        'imageUrl':
            'https://tse3.mm.bing.net/th/id/OIP.hKS5gt9rCzCou0rpZVPvhgHaHa?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'tagText': '新品',
        'tagColor': Color(0xFF4CAF50), // 新品 (绿色)
      },
      {
        'title': '星空物语',
        'author': '星空讲述者',
        'imageUrl':
            'https://tse3.mm.bing.net/th/id/OIP.WBgt6EuwqzjIHBZWpj2DyAHaHa?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        'tagText': '精选',
        'tagColor': Color(0xFF2196F3), // 精选 (蓝色)
      },
    ];
    int readCount = 24; // 阅读数
    int durationHours = 12; // 阅读时长
    int collectionCount = 18; // 收藏数
    return Stack(
      children: [
        // 1. 【Gradient Background Layer】
        Container(
          width: double.infinity,
          height: 440.0,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFecaed5), Color(0xFFe6d5fb)],
            ),
          ),
        ),

        // 2. 【Scrollable Content Layer】
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
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://tse1.explicit.bing.net/th/id/OIP.HQ6SWtXliC_0akDP_Bd4IQHaID?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
                        ),
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
                      const SizedBox(width: 12),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0C75A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'VIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            'https://tse2.mm.bing.net/th/id/OIP.eBdtn7ZmxyGWmo-MCxZJygAAAA?cb=ucfimg2ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFd94897),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '限时优惠',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                '专属绘本定制',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 统计已读、时长、收藏
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      StatCard(
                        emoji: '📚',
                        title: '已读',
                        value: '$readCount本',
                        color: Color(0xFFFF4081),
                      ),
                      const SizedBox(width: 12),
                      StatCard(
                        emoji: '⏱️',
                        title: '时长',
                        value: '${durationHours}h',
                        color: Color(0xFF673AB7),
                      ),
                      const SizedBox(width: 12),
                      StatCard(
                        emoji: '🎯',
                        title: '收藏',
                        value: '$collectionCount本',
                        color: Color(0xFFFF4081),
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
                    children: const [
                      CircularButton(
                        icon: Icons.star,
                        label: '创建绘本',
                        color: Color(0xFFdb519d),
                      ),
                      CircularButton(
                        icon: Icons.local_fire_department,
                        label: '热门广场',
                        color: Color(0xFFbf91fe),
                      ),
                      CircularButton(
                        icon: Icons.menu_book,
                        label: '我的作品',
                        color: Color(0xFFdb519d),
                      ),
                      CircularButton(
                        icon: Icons.schedule,
                        label: '浏览历史',
                        color: Color(0xFFbf91fe),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 广告牌
                const PromoButton(),
                const SizedBox(height: 20),

                // 阅读记录模块
                Column(
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
                          Icon(
                            Icons.watch_later_outlined,
                            color: Color(0xFFd94897),
                            size: 20,
                          ),
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
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('查看更多继续阅读')),
                              );
                            },
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

                    // 可滑动的卡片列表
                    SizedBox(
                      height: 200, // 设定高度以便 ListView 正确显示
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _readingList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemBuilder: (context, index) {
                          final item = _readingList[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == _readingList.length - 1
                                  ? 0
                                  : 12.0,
                            ),
                            child: ReadingItemCard(
                              title: item['title'] as String,
                              imageUrl: item['imageUrl'] as String,
                              progress: item['progress'] as double,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 滑动进度条
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ProgressIndicatorBar(
                        progress: _scrollPosition,
                        activeColor: Color(0xFFd94897),
                        inactiveColor: Colors.grey[300]!,
                      ),
                    ),
                  ],
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
                            Icon(
                              Icons.trending_up,
                              color: Color(0xFFd94897),
                              size: 20,
                            ),
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
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('查看更多热门榜单')),
                                );
                              },
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

                // 【新增：绘本广场模块】
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
                            Icon(
                              Icons.apps_rounded,
                              color: Color(0xFFd94897),
                              size: 20,
                            ),
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

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold();
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
