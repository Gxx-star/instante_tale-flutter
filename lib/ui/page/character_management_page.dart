import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/features/character/character_provider.dart';

import '../../database/models/character.dart';

class CharacterManagementPage extends ConsumerStatefulWidget {
  const CharacterManagementPage({super.key});

  @override
  ConsumerState<CharacterManagementPage> createState() =>
      _CharacterManagementPageState();
}

class _CharacterManagementPageState
    extends ConsumerState<CharacterManagementPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late bool _showAvatar = true;

  // 字母导航条：A-Z + #
  final List<String> _initials = List.generate(
    26,
    (index) => String.fromCharCode('A'.codeUnitAt(0) + index),
  ).toList()..add('#');

  // 用于存储每个字母组的第一个列表项的 GlobalKey
  final Map<String, GlobalKey> _initialKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(characterViewModelProvider.notifier).updateSearchKeyword('');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 滚动到对应字母组
  void _scrollToInitial(String initial) {
    final key = _initialKeys[initial];
    if (key != null) {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox
            .localToGlobal(Offset.zero, ancestor: context.findRenderObject())
            .dy;
        // 减去 AppBar 和搜索框的高度，确保字母组正好在顶部
        const headerHeight = kToolbarHeight + 60;
        _scrollController.animateTo(
          _scrollController.offset + position - headerHeight,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // 顶部导航栏
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: const BoxDecoration(color: Color(0xFFF0F0FF)),
      child: Column(
        children: [
          // 返回键和标题
          Row(
            children: [
              _glassButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => context.pop(),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '角色管理',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A4C75),
                    ),
                  ),
                ),
              ),
              // 右侧占位保持居中
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 15),
          // 搜索框
          TextField(
            controller: _searchController,
            onChanged: (value) {
              ref
                  .read(characterViewModelProvider.notifier)
                  .updateSearchKeyword(value);
            },
            decoration: InputDecoration(
              hintText: '搜索角色名字',
              hintStyle: TextStyle(
                color: const Color(0xFF5A4C75).withOpacity(0.6),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF5A4C75),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.85),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF5A4C75)),
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(characterViewModelProvider.notifier)
                            .updateSearchKeyword('');
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
            ),
            cursorColor: const Color(0xFFBFA2FF),
          ),
        ],
      ),
    );
  }

  // 玻璃拟态按钮组件
  Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF5A4C75), size: 20),
          ),
        ),
      ),
    );
  }

  // 角色卡片
  void _showCharacterCard(CharacterCollection character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFBFA2FF),
                blurRadius: 15,
                spreadRadius: -5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 顶部把手
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // 头像
              StatefulBuilder(
                builder: (context, setState) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAvatar = !_showAvatar;
                      });
                    },
                    child: _showAvatar
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(character.avatarUrl),
                            backgroundColor: const Color(0xFFF0EBFF),
                          )
                        : Image.network(character.threeViewUrl, height: 200),
                  );
                },
              ),
              Text('点击切换头像/三视图', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              // 名字
              Text(
                character.characterName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A4C75),
                ),
              ),
              const SizedBox(height: 8),
              // 描述
              Text(
                character.desc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '创建时间：${AppGlobals().formatTimestamp(character.createdAt)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              // 删除按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // 关闭卡片
                    _showDeleteConfirmation(context, character);
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '删除角色',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9F9F), // 柔和的红色
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 删除确认框
  void _showDeleteConfirmation(
    BuildContext context,
    CharacterCollection character,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "确认删除",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A4C75),
            ),
          ),
          content: Text(
            "角色删除之后绘本中将查询不到该角色的信息噢~，确认要删除【${character.characterName}】吗？",
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消
              },
              child: const Text(
                '取消',
                style: TextStyle(color: Color(0xFFBFA2FF), fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭确认框
                // 执行删除操作
                ref
                    .read(characterViewModelProvider.notifier)
                    .deleteCharacter(character.characterId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9F9F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: const Text(
                '确认删除',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  // 主页面
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterViewModelProvider);
    final characterViewModel = ref.read(characterViewModelProvider.notifier);
    AsyncValue<Map<String, List<CharacterCollection>>> _charactersAsync = ref
        .watch(groupedCharactersProvider);
    // 获取排序后的字母键
    final groupedKeys = _charactersAsync.value?.keys.toList() ?? [];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: _buildAppBar(),
      ),
      backgroundColor: const Color(0xFFF5F0FF), // 柔和背景色
      body: Stack(
        children: [
          // 列表内容
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _charactersAsync.when(
                data: (groupedMap) {
                  if (groupedMap.isEmpty && state.searchKeyword == '') {
                    return SliverFillRemaining(
                      child: Center(child: Text("暂无角色信息")),
                    );
                  } else {
                    if (state.searchKeyword == '') {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          groupedKeys.expand((initial) {
                            final group = groupedMap[initial]!;

                            // 头部字母分组
                            final header = Container(
                              key: _initialKeys.putIfAbsent(
                                initial,
                                () => GlobalKey(),
                              ), // 记录头部 Key
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 8,
                                bottom: 4,
                              ),
                              color: const Color(0xFFEBE0FF), // 浅紫色背景
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF5A4C75),
                                ),
                              ),
                            );

                            // 列表项
                            final items = group.map((character) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    character.avatarUrl,
                                  ),
                                  backgroundColor: const Color(0xFFF0EBFF),
                                ),
                                title: Text(
                                  character.characterName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                subtitle: Text(
                                  character.desc,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                onTap: () => _showCharacterCard(character),
                              );
                            }).toList();
                            return [header, ...items];
                          }).toList(),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final character = state.filteredList[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                character.avatarUrl,
                              ),
                              backgroundColor: const Color(0xFFF0EBFF),
                            ),
                            title: Text(
                              character.characterName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            subtitle: Text(
                              character.desc,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            onTap: () => _showCharacterCard(character),
                          );
                        }, childCount: state.filteredList.length),
                      );
                    }
                  }
                },
                error: (err, stack) => SliverFillRemaining(
                  child: Center(child: Text("加载失败：$err")),
                ),
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFBFA2FF)),
                  ),
                ),
              ),
            ],
          ),

          // 侧边字母导航条 (A-Z)
          if (!state.isLoading &&
              state.searchKeyword.isEmpty &&
              (_charactersAsync.value?.isNotEmpty ?? false))
            Positioned(
              right: 0,
              top: 100, // 避开顶部 AppBar
              bottom: 0,
              child: _buildSideIndexBar(context, groupedKeys),
            ),
        ],
      ),
    );
  }

  // 侧边导航条 UI
  Widget _buildSideIndexBar(BuildContext context, List<String> activeKeys) {
    return Container(
      width: 30,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      alignment: Alignment.center,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          // 计算拖动位置对应哪个字母
          final box = context.findRenderObject() as RenderBox;
          final y =
              details.globalPosition.dy - box.localToGlobal(Offset.zero).dy;

          final heightPerItem = box.size.height / _initials.length;
          final index = (y / heightPerItem).floor().clamp(
            0,
            _initials.length - 1,
          );
          final initial = _initials[index];

          if (activeKeys.contains(initial)) {
            _scrollToInitial(initial);
          }
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _initials.length,
          itemBuilder: (context, index) {
            final initial = _initials[index];
            final isActive = activeKeys.contains(initial);

            return GestureDetector(
              onTap: isActive ? () => _scrollToInitial(initial) : null,
              child: Container(
                alignment: Alignment.center,
                height: 20, // 设定每个字母的高度
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? const Color(0xFFBFA2FF)
                        : Colors.grey.withOpacity(0.4),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
