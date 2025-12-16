import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 新增导入

class StorybookPlazaPage extends StatefulWidget {
  const StorybookPlazaPage({super.key});

  @override
  State<StorybookPlazaPage> createState() => _StorybookPlazaPageState();
}

class _StorybookPlazaPageState extends State<StorybookPlazaPage> {
  final List<Map<String,dynamic>> categories = [
    {
      "name": "全部","icon": Icons.all_inclusive
    },
    {
      "name": "冒险","icon": Icons.assistant_photo
    },
    {
      "name": "奇幻","icon": Icons.flare
    },
    {
      "name": "科普","icon": Icons.science
    },
    {
      "name": "友谊","icon": Icons.thumb_up
    },
    {
      "name": "勇气","icon": Icons.security
    },
    {
      "name": "自然","icon": Icons.eco
    }
  ];
  int currentIndex = 0;

  // 定义卡片的颜色和渐变，模仿首页风格
  final List<List<Color>> cardGradients = [
    [const Color(0xFF6dd5ed), const Color(0xFF2193b0)], // 绿色/蓝色系
    [const Color(0xFFee9ca7), const Color(0xFFffdde1)], // 粉色系
    [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // 浅绿色系
    [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)], // 紫色/粉色系
    [const Color(0xFFfda085), const Color(0xFFf6d365)], // 橙色/黄色系
    [const Color(0xFF5ee7df), const Color(0xFFb490ca)], // 青色/紫色系
  ];
  // 定义卡片的数据（简化）
  final List<Map<String, dynamic>> storybooks = [
    {"title": "森林守护者的秘密", "author": "自然故事家", "views": 12543, "likes": 856},
    {"title": "好朋友的冒险", "author": "友谊桥", "views": 9876, "likes": 678},
    {"title": "8个故事", "isFolder": true},
    // 添加更多数据以填充列表
    {"title": "魔法森林", "author": "小魔法师", "views": 5421, "likes": 321},
    {"title": "星空探索", "author": "天文迷", "views": 7890, "likes": 501},
    {"title": "勇敢的小船", "author": "航海家", "views": 3122, "likes": 190},
    {"title": "色彩的世界", "author": "画笔", "views": 6789, "likes": 450},
    {"title": "恐龙时代", "author": "考古学家", "views": 9012, "likes": 612},
    {"title": "小小建筑师", "author": "工程师", "views": 4567, "likes": 289},
  ];
  // 定义主题背景渐变色
  static final LinearGradient themeGradient = LinearGradient(
    colors: [const Color(0xFFfbc2eb), const Color(0xFFa6c1ee)], // 浅粉色到浅蓝色
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 定义主色调（用于选中状态等）
  static const Color primaryColor = Color(0xFF5ee7df); // 青色

  @override
  Widget build(BuildContext context) {
    // 确保返回Scaffold作为根Widget
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeGradient,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                "内容广场",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // 标题颜色改为白色或深色，这里选用白色
                ),
              ),
              // 设置App Bar背景为透明，以便看到下方的渐变
              pinned: true,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.w), // 返回箭头改为白色 + 尺寸适配
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            // 分类标签吸顶
            SliverPersistentHeader(
              pinned: true,
              delegate: _CategoryHeaderDelegate(
                minExtent: 60.h, // 高度适配
                maxExtent: 60.h, // 高度适配
                child: _buildCategoryBar(primaryColor),
              ),
            ),
            // 内容列表
            SliverPadding(
              padding: EdgeInsets.all(12.w), // 内边距适配
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h, // 纵向间距适配
                  crossAxisSpacing: 12.w, // 横向间距适配
                  childAspectRatio: 0.65, // 比例保持不变
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildCard(index),
                  childCount: storybooks.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  } // <-- build方法结束

  /// 分类导航栏
  Widget _buildCategoryBar(Color primaryColor) {
    return Container(
      // 背景使用柔和的半透明色，让底层渐变透出
      color: Colors.white.withOpacity(0.3),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), // 内边距适配
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w), // 间距适配
        itemBuilder: (_, index) {
          bool selected = index == currentIndex;
          final category = categories[index];

          return ChoiceChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r), // 圆角适配
            ),
            label: Text(
              category["name"],
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87, // 保持选中白色，未选中深色
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            avatar: Icon(
              category["icon"],
              size: 16.w, // 图标尺寸适配
              color: selected ? Colors.white : Colors.black54, // 图标颜色调整
            ),
            selected: selected,
            onSelected: (_) {
              setState(() => currentIndex = index);
            },
            selectedColor: primaryColor,
            backgroundColor: Colors.white.withOpacity(0.8), // 使用带透明度的白色作为未选中背景
            elevation: 0,
          );
        },
      ),
    );
  }

  /// 绘本卡片 - 保持不变，因为卡片本身颜色就很鲜艳
  Widget _buildCard(int index) {
    final book = storybooks[index % storybooks.length];
    final isFolder = book["isFolder"] ?? false;
    final gradient = cardGradients[index % cardGradients.length];

    if (isFolder) {
      // 文件夹样式
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r), // 圆角适配
          color: const Color(0xFFa18cd1),
        ),
        padding: EdgeInsets.all(16.w), // 内边距适配
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), // 内边距适配
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r), // 圆角适配
              ),
              child: Text(
                '${book["title"]}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp, // 字体适配
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Icon(Icons.folder_open, size: 40.w, color: Colors.white), // 图标尺寸适配
          ],
        ),
      );
    }

    // 普通绘本卡片
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r), // 圆角适配
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.4),
            blurRadius: 8.w, // 阴影模糊适配
            offset: Offset(0, 4.h), // 阴影偏移适配
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.book_outlined, size: 60.w, color: Colors.white.withOpacity(0.8)), // 图标尺寸适配
          ),

          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              width: 30.w, // 宽度适配
              height: 30.h, // 高度适配
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border, size: 18.w, color: Colors.white), // 图标尺寸适配
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(12.w), // 内边距适配
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18.r), // 圆角适配
                  bottomRight: Radius.circular(18.r), // 圆角适配
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 14.w, color: Colors.white), // 图标尺寸适配
                      SizedBox(width: 4.w), // 间距适配
                      Text(
                        '${book["views"]}',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp), // 字体适配
                      ),
                      SizedBox(width: 8.w), // 间距适配
                      Icon(Icons.favorite, size: 14.w, color: Colors.white), // 图标尺寸适配
                      SizedBox(width: 4.w), // 间距适配
                      Text(
                        '${book["likes"]}',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp), // 字体适配
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h), // 间距适配
                  Text(
                    book["title"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp, // 字体适配
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h), // 间距适配
                  Text(
                    'by ${book["author"]}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp, // 字体适配
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 保持不变的Delegate（仅修改尺寸单位）
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _CategoryHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 使用ClipRRect确保分类栏的半透明背景在吸顶时不会超出边界
    return ClipRRect(
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) => true;
}
