import 'package:flutter/material.dart';

class StorybookPlazaPage extends StatefulWidget {
  const StorybookPlazaPage({super.key});

  @override
  State<StorybookPlazaPage> createState() => _StorybookPlazaPageState();
}

class _StorybookPlazaPageState extends State<StorybookPlazaPage> {
  final List<String> categories = [
    "全部", "冒险", "奇幻", "科普", "友谊", "勇气", "自然"
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("内容广场"),
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 2,
          ),

          // 分类标签吸顶
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryHeaderDelegate(
              minExtent: 60,
              maxExtent: 60,
              child: _buildCategoryBar(),
            ),
          ),

          // 内容列表
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCard(index),
                childCount: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 分类导航栏
  Widget _buildCategoryBar() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          bool selected = index == currentIndex;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: selected,
            onSelected: (_) {
              setState(() => currentIndex = index);
            },
            backgroundColor: Colors.grey[200],
            selectedColor: Colors.blue.shade300,
          );
        },
      ),
    );
  }

  /// 绘本卡片
  Widget _buildCard(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.primaries[index % Colors.primaries.length],
      ),
      child: const Center(
        child: Icon(Icons.book, size: 40, color: Colors.white),
      ),
    );
  }
}

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
    return child;
  }

  @override
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) => true;
}
