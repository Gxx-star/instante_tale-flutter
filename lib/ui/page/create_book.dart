import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/features/book/book_view_model.dart';
import 'package:instant_tale/features/character/character_provider.dart';
import 'package:instant_tale/ui/component/my_snackbar.dart';
import '../../database/models/character.dart';
import '../../features/book/book_provider.dart';
import '../../features/book/book_state.dart';
import '../../features/character/character_state.dart';
import '../../features/character/character_viewmodel.dart';

class CreateBookPage extends ConsumerStatefulWidget {
  const CreateBookPage({super.key});

  @override
  ConsumerState<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends ConsumerState<CreateBookPage> {
  late CharacterViewModel _characterViewModel;
  late CharacterState _characterState;
  late BookViewModel _bookViewModel;
  late BookState _bookState;
  final int _totalPages = 4;
  int _currentPage = 0;
  final PageController _pageController = PageController();
  int _selectedBookType = 0;
  String? _selectedCharacterId = null;
  String? _selectedCharacterName;
  final Set<String> _selectedStyles = {};
  final int _maxStyles = 3;
  bool _isCollectionBook = false;
  String _storyTheme = '';
  int? _selectedVoiceIndex;

  // 故事风格选项
  final List<Map<String, dynamic>> _styleOptions = [
    {
      'name': '冒险',
      'emoji': '🗺️',
      'tagColor': const Color(0xfff1f6fe),
      'tagTextColor': const Color(0xff5588ff),
    },
    {
      'name': '奇幻',
      'emoji': '🦄',
      'tagColor': const Color(0xffeedfff),
      'tagTextColor': const Color(0xff9944dd),
    },
    {
      'name': '科普',
      'emoji': '🔬',
      'tagColor': const Color(0xfffff4d7),
      'tagTextColor': const Color(0xffe6a300),
    },
    {
      'name': '友谊',
      'emoji': '🤝',
      'tagColor': const Color(0xfffceef6),
      'tagTextColor': const Color(0xffe95796),
    },
    {
      'name': '勇气',
      'emoji': '💪',
      'tagColor': const Color(0xfff7e7da),
      'tagTextColor': const Color(0xffa87342),
    },
    {
      'name': '自然',
      'emoji': '🌿',
      'tagColor': const Color(0xffddf2e4),
      'tagTextColor': const Color(0xff3fa06b),
    },
  ];

  // 页面跳转
  void _navigateToPage(int page) {
    if (page < 0 || page >= _totalPages) return;
    setState(() {
      _currentPage = page;
    });
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Page1：选择绘本类型
  void _handleBookTypeSelection(int type) {
    setState(() {
      _selectedBookType = type;
      if (type == 1) {
        _selectedCharacterId = null;
        _selectedCharacterName = null;
      }
    });
  }

  // Page1: 选择角色之后的回调
  void _handleCharacterSelection(String? id, String? name) {
    setState(() {
      _selectedCharacterId = id;
      _selectedCharacterName = name;
    });
  }

  // Page2：选择故事风格之后的回调
  void _handleStyleToggle(String styleName) {
    setState(() {
      if (_selectedStyles.contains(styleName)) {
        _selectedStyles.remove(styleName);
      } else {
        if (_selectedStyles.length < _maxStyles) {
          _selectedStyles.add(styleName);
        } else {
          // 提示
        }
      }
    });
  }

  // Page3：故事主题输入框的回调
  void _handleStoryThemeChanged(String theme) {
    setState(() {
      _storyTheme = theme.trim();
    });
  }

  // Page4：选择音色之后的回调
  void _handleVoiceSelection(int? index) {
    setState(() {
      _selectedVoiceIndex = index;
    });
  }

  // 判断是否允许下一步
  bool get _isNextButtonEnabled {
    switch (_currentPage) {
      case 0:
        if (_selectedBookType == 1) {
          return true;
        }
        if (_selectedBookType == 2) {
          return _selectedCharacterId != null;
        }
        return false;
      case 1:
        return _selectedStyles.isNotEmpty;
      case 2:
        return _storyTheme.isNotEmpty;
      case 3:
        return _selectedVoiceIndex != null;
      default:
        return true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _characterViewModel = ref.watch(characterViewModelProvider.notifier);
    _characterState = ref.watch(characterViewModelProvider);
    _bookViewModel = ref.watch(bookViewModelProvider.notifier);
    _bookState = ref.watch(bookViewModelProvider);
    ref.listen<String?>(
      bookViewModelProvider.select((state) => state.message),
      (previous, next) {
        if (next != null) {
          MySnackBar.show(context, next);
        }
      },
    );
    const Color primaryColor = Color(0xFFfaf3f8);
    const Color accentColor = Colors.pinkAccent;
    const _headerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFecaed5), Color(0xFFf0d0e7)],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      appBar: AppBar(
        toolbarHeight: 40.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xfffbfafd)),
          onPressed: () => context.pop(),
        ),
        // 标题
        title: const Text(
          '创建绘本',
          style: TextStyle(
            color: Color(0xfffbfafd),
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: _headerGradient),
        ),
      ),
      body: Column(
        children: [
          // 上方进度条
          Container(
            decoration: const BoxDecoration(gradient: _headerGradient),
            child: StepIndicator(
              totalPages: _totalPages,
              currentPage: _currentPage,
            ),
          ),
          // 内容区域
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Page1Type(
                  selectedBookType: _selectedBookType,
                  onSelectionChanged: _handleBookTypeSelection,
                  onCharacterSelected: _handleCharacterSelection,
                  hasCharacterSelected: _selectedCharacterId != null,
                  selectedCharacterName: _selectedCharacterName,
                ),
                Page2Style(
                  selectedStyles: _selectedStyles,
                  isCollectionBook: _isCollectionBook,
                  maxStyles: _maxStyles,
                  styleOptions: _styleOptions,
                  onStyleToggle: _handleStyleToggle,
                  onCollectionToggle: (value) {
                    setState(() {
                      _isCollectionBook = value;
                    });
                  },
                ),
                Page3Content(
                  initialStoryTheme: _storyTheme,
                  onThemeChanged: _handleStoryThemeChanged,
                ),
                Page4Voice(
                  selectedVoiceIndex: _selectedVoiceIndex,
                  onVoiceChanged: _handleVoiceSelection,
                ),
              ],
            ),
          ),
          _buildNavigationButtons(accentColor),
        ],
      ),
    );
  }

  // 底部按钮：”上一步“和”下一步“
  Widget _buildNavigationButtons(Color accentColor) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              if (_currentPage > 0)
                // ”上一步“按钮
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _navigateToPage(_currentPage - 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfffafbff),
                      foregroundColor: const Color(0xff0a0a0a),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '上一步',
                      style: TextStyle(
                        color: Color(0xff3e3547),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),

              if (_currentPage > 0) const SizedBox(width: 10.0),
              // “下一步”按钮
              Expanded(
                child: ElevatedButton(
                  onPressed: _isNextButtonEnabled
                      ? () {
                          if (_currentPage < _totalPages - 1) {
                            _navigateToPage(_currentPage + 1);
                          } else {
                            List<String> characters = [];
                            final List<String> storyTypes = _selectedStyles
                                .toList();
                            final List<String> storyQualities = [_storyTheme];
                            if (_selectedCharacterId != null) {
                              characters.add(_selectedCharacterId!);
                              _bookViewModel.createExclusiveBook(
                                storyTypes,
                                storyQualities,
                                characters,
                              );
                            } else {
                              _bookViewModel.createBook(
                                storyTypes,
                                storyQualities,
                              );
                            }
                            context.pop();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: const Color(0xffeeadd1),
                    disabledForegroundColor: const Color(0xfffdf6fa),
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? '✨ 开始生成' : '下一步',
                    style: const TextStyle(
                      color: Color(0xfffceef6),
                      fontSize: 15.0,
                    ),
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

// “选择专属人物”页面
class SelectCharacterPage extends ConsumerStatefulWidget {
  const SelectCharacterPage({super.key});

  @override
  ConsumerState<SelectCharacterPage> createState() =>
      _SelectCharacterPageState();
}

class _SelectCharacterPageState extends ConsumerState<SelectCharacterPage> {
  CharacterCollection? _selectedCharacter; // 跟踪当前选中的人物ID

  @override
  Widget build(BuildContext context) {
    final _charactersListAsync = ref.watch(characterListProvider);
    const Color primaryColor = Color(0xFFfaf3f8);
    const Color accentColor = Colors.pinkAccent;

    // 顶部渐变
    const _headerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFedb2d8), // Top-left light pink
        Color(0xFFe8d4f6), // Bottom-right softer pink
      ],
    );
    return _charactersListAsync.when(
      data: (_characterList) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            toolbarHeight: 40.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xfffbfafd)),
              onPressed: () => Navigator.of(context).pop(), // 默认返回 null
            ),
            title: const Text(
              '选择专属人物',
              style: TextStyle(
                color: Color(0xfffbfafd),
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0.0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(gradient: _headerGradient),
            ),
          ),
          body: Column(
            children: [
              // AppBar 下方的副标题
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10.0, 3.0, 20.0, 15.5),
                decoration: const BoxDecoration(gradient: _headerGradient),
                child: const Text(
                  '为绘本选择一个专属主角，让故事更生动',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
              // 滚动内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. 创建新人物按钮 (虚线边框)
                      _buildCreateNewButton(context),
                      const SizedBox(height: 24.0),

                      // 2. "我的人物" 标题
                      const Text(
                        '我的人物',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // 3. 人物列表
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _characterList.length,
                        itemBuilder: (context, index) {
                          final character = _characterList[index];
                          final isSelected =
                              _selectedCharacter?.characterId ==
                              character.characterId;
                          return _CharacterCard(
                            character: character,
                            isSelected: isSelected,
                            onPressed: () {
                              setState(() {
                                _selectedCharacter = character;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 底部 "确认选择" 按钮
              _buildConfirmButton(context, accentColor),
            ],
          ),
        );
      },
      error: (e, s) {
        return Text('error');
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // "创建新人物" 按钮 - *** IMPLEMENTATION START ***
  Widget _buildCreateNewButton(BuildContext context) {
    const Color pinkAccent = Colors.pinkAccent;
    const double borderRadius = 12.0;

    return InkWell(
      onTap: () {
        // Handle navigation to character creation page
      },
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: pinkAccent.withOpacity(0.4),
          strokeWidth: 1,
          radius: const Radius.circular(borderRadius),
          dashWidth: 5,
          dashSpace: 3,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 26.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: [
              // 左侧：圆形粉色背景的加号
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: pinkAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 45),
              ),
              const SizedBox(width: 16.0),
              // 右侧：两列文字
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 第一行文字：创建新人物
                  Text(
                    '创建新人物',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  // 第二行文字：上传照片，生成专属绘本主角
                  Text(
                    '上传照片，生成专属绘本主角',
                    style: TextStyle(
                      color: Colors.black54, // 灰色半透明
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 底部 "确认选择" 按钮
  Widget _buildConfirmButton(BuildContext context, Color accentColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: SafeArea(
        top: false, // 只关心底部
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedCharacter == null
                ? null
                : () {
                    // 确认选择，关闭此页面并返回选中的ID
                    Navigator.of(context).pop(_selectedCharacter);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
              // 禁用时的颜色
              disabledBackgroundColor: Color(0xffeeadd1),
              disabledForegroundColor: Color(0xfffdf6fa),
            ),
            child: const Text(
              '确认选择',
              style: TextStyle(
                color: Color(0xfffceef6),
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 人物卡片
class _CharacterCard extends StatelessWidget {
  final CharacterCollection character;
  final bool isSelected;
  final VoidCallback onPressed;

  const _CharacterCard({
    required this.character,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color selectedBgColor = Color(0xfffaf2f8);
    const Color selectedBorderColor = Colors.pinkAccent;
    final Color defaultBorderColor = Colors.grey[300]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? selectedBgColor : Colors.white,
          padding: const EdgeInsets.all(14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          side: BorderSide(
            color: isSelected ? selectedBorderColor : defaultBorderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          elevation: isSelected ? 3.0 : 0,
          shadowColor: isSelected
              ? selectedBorderColor.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // 左侧图片和选中标记
            _buildCharacterAvatar(context),
            const SizedBox(width: 16.0),
            // 右侧信息
            _buildCharacterInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterAvatar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 33,
          backgroundImage: NetworkImage(character.avatarUrl),
        ),
        // 选中时的对勾
        if (isSelected)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildCharacterInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            character.characterName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 6.0),
          // 人物的小标签Tags
          Row(
            children: [
              _InfoTag(
                text: '${character.characterName}',
                color: const Color(0xfff7e8f2),
              ),
              const SizedBox(width: 8.0),
              _InfoTag(
                text: '创建时间：${AppGlobals().formatTimestamp(character.createdAt)}',
                color: const Color(0xfff7e8f2),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

// 年龄/性别 的小标签
class _InfoTag extends StatelessWidget {
  final String text;
  final Color color;

  const _InfoTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Page1
class Page1Type extends StatelessWidget {
  final int selectedBookType;
  final Function(int) onSelectionChanged;
  final Function(String? id, String? name) onCharacterSelected;
  final bool hasCharacterSelected;
  final String? selectedCharacterName;

  const Page1Type({
    super.key,
    required this.selectedBookType,
    required this.onSelectionChanged,
    required this.onCharacterSelected,
    required this.hasCharacterSelected,
    this.selectedCharacterName,
  });

  // 选择专属人物后的绿色提示框
  Widget _buildSelectedCharacterInfoBox(BuildContext context) {
    const Color successColor = Color(0xff4CAF50);
    const Color successBgColor = Color(0xffE8F5E9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: successBgColor,
        border: Border.all(color: successColor.withOpacity(0.5), width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.check, color: successColor, size: 22.0),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '已选择专属人物',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    selectedCharacterName ?? '未知人物',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right side: Change Character button
          SizedBox(
            height: 32.0, // Set button height
            child: TextButton(
              onPressed: () {
                // Trigger character re-selection logic
                _handleSelectCharacter(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                // White background
                foregroundColor: Colors.grey[700],
                // Text color
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0), // Rounded corners
                  side: BorderSide(color: Colors.grey[300]!), // Light border
                ),
                elevation: 0,
              ),
              child: const Text(
                '更换人物', // Change Character
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 点击选择人物之后的回调
  void _handleSelectCharacter(BuildContext context) async {
    final CharacterCollection? selectedCharacter =
        await Navigator.push<CharacterCollection?>(
          context,
          MaterialPageRoute<CharacterCollection?>(
            builder: (context) => const SelectCharacterPage(),
          ),
        );
    if (selectedCharacter == null) {
      return;
    }
    onCharacterSelected(
      selectedCharacter.characterId,
      selectedCharacter.characterName,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color infoBoxBgColor = Color(0xfff1f6fe);
    const Color infoBoxBorderColor = Color(0xffb2cfff);
    final bool hasSelectedExclusiveCharacter =
        selectedBookType == 2 && hasCharacterSelected;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 选择绘本类型
            Row(
              children: [
                const Icon(
                  Icons.palette_outlined,
                  color: Colors.pinkAccent,
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                const Text(
                  '选择绘本类型',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),

            // 普通绘本
            _TypeSelectionButton(
              emoji: '📖',
              title: '普通绘本',
              subtitle: '经典绘本故事',
              type: 1,
              selectedBookType: selectedBookType,
              onPressed: () => onSelectionChanged(1),
              onSelectCharacter: () {},
              hasCharacterSelected: false,
              selectedCharacterName: null,
            ),
            const SizedBox(height: 10.0),
            // 专属绘本
            _TypeSelectionButton(
              emoji: '✨',
              title: '专属绘本',
              subtitle: '孩子成为故事主角',
              type: 2,
              selectedBookType: selectedBookType,
              hasCharacterSelected: hasCharacterSelected,
              selectedCharacterName: selectedCharacterName,
              onPressed: () => onSelectionChanged(2),
              onSelectCharacter: () => _handleSelectCharacter(context),
            ),
            const SizedBox(height: 14.0),
            if (selectedBookType == 2)
              if (hasSelectedExclusiveCharacter)
                _buildSelectedCharacterInfoBox(context)
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: infoBoxBgColor,
                    border: Border.all(
                      color: infoBoxBorderColor.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '💡 选择专属绘本后，需要选择或创建一个人物角色',
                          style: TextStyle(
                            color: Color(0xff313eb1),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// Page1: 绘本类型选择按钮
class _TypeSelectionButton extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final int type;
  final int selectedBookType;
  final VoidCallback onPressed;
  final VoidCallback onSelectCharacter;
  final bool hasCharacterSelected;
  final String? selectedCharacterName;

  const _TypeSelectionButton({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.selectedBookType,
    required this.onPressed,
    required this.onSelectCharacter,
    required this.hasCharacterSelected,
    this.selectedCharacterName,
  });

  bool get isSelected => type == selectedBookType;

  bool get isExpanded => isSelected && type == 2 && !hasCharacterSelected;

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Colors.pinkAccent;
    const Color selectedBorderColor = accentColor;
    final Color defaultBorderColor = Colors.grey[300]!;
    const Color expandedBgColor = Color(0xfffaf2f8);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isExpanded ? expandedBgColor : Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          side: BorderSide(
            color: isSelected ? selectedBorderColor : defaultBorderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          elevation: isSelected ? 3.0 : 0,
          shadowColor: isSelected
              ? selectedBorderColor.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 20.0),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 40.0)),
                  const SizedBox(width: 16.0),
                  // Right two lines of text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      (type == 2 && hasCharacterSelected)
                          ? Icons.check_circle
                          : Icons.check,
                      color: accentColor,
                      size: 24.0,
                    ),
                ],
              ),
            ),
            if (isExpanded) ...[
              Divider(
                color: accentColor.withOpacity(0.3),
                height: 1.0,
                thickness: 1.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                child: Container(
                  width: double.infinity,
                  height: 44.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor.withOpacity(0.9), accentColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    onPressed: onSelectCharacter,
                    icon: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      '选择专属人物',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Page2
class Page2Style extends StatelessWidget {
  final Set<String> selectedStyles;
  final bool isCollectionBook;
  final int maxStyles;
  final List<Map<String, dynamic>> styleOptions;
  final Function(String) onStyleToggle;
  final Function(bool) onCollectionToggle;

  const Page2Style({
    super.key,
    required this.selectedStyles,
    required this.isCollectionBook,
    required this.maxStyles,
    required this.styleOptions,
    required this.onStyleToggle,
    required this.onCollectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部的 "选择故事风格" 文本
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  color: Colors.pinkAccent,
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                const Text(
                  '选择故事风格',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),

            // 六个风格选择按钮 (3x2 GridView)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 两列
                crossAxisSpacing: 10.0, // 按钮之间的水平间距
                mainAxisSpacing: 10.0, // 按钮之间的垂直间距
                childAspectRatio: 1.34,
              ),
              itemCount: styleOptions.length,
              itemBuilder: (context, index) {
                final option = styleOptions[index];
                final styleName = option['name'] as String;
                final isSelected = selectedStyles.contains(styleName);

                return _StyleSelectionButton(
                  emoji: option['emoji'] as String,
                  styleName: styleName,
                  tagColor: option['tagColor'] as Color,
                  tagTextColor: option['tagTextColor'] as Color,
                  isSelected: isSelected,
                  onPressed: () => onStyleToggle(styleName),
                );
              },
            ),
            const SizedBox(height: 0.0),
            // _BookCollectionCheckbox(
            //   value: isCollectionBook,
            //   onChanged: onCollectionToggle,
            // ),
            // const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}

// Page2：故事风格选择按钮
class _StyleSelectionButton extends StatelessWidget {
  final String emoji;
  final String styleName;
  final Color tagColor;
  final Color tagTextColor;
  final bool isSelected;
  final VoidCallback onPressed;

  const _StyleSelectionButton({
    required this.emoji,
    required this.styleName,
    required this.tagColor,
    required this.tagTextColor,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color selectedBgColor = Color(0xfffaf2f8);
    const Color selectedBorderColor = Colors.pinkAccent;
    final Color defaultBorderColor = Colors.grey[300]!;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? selectedBgColor : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        side: BorderSide(
          color: isSelected ? selectedBorderColor : defaultBorderColor,
          width: isSelected ? 1.5 : 1.0,
        ),
        elevation: isSelected ? 3.0 : 0,
        shadowColor: isSelected
            ? selectedBorderColor.withOpacity(0.3)
            : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 34.0)),
          const SizedBox(height: 6.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              styleName,
              style: TextStyle(
                color: tagTextColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Page2：绘本集选择框
class _BookCollectionCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BookCollectionCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final Color defaultBorderColor = Colors.grey[300]!;
    const Color checkedBgColor = Color(0xffd7e6fd);
    const Color checkedIconColor = Color(0xff5588ff);
    const Color uncheckedBgColor = Colors.black;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: defaultBorderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: value ? checkedBgColor : Colors.grey[400]!,
                  width: 1.0,
                ),
                color: value ? checkedBgColor : uncheckedBgColor,
              ),
              child: value
                  ? const Icon(Icons.check, size: 18.0, color: checkedIconColor)
                  : null,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '创建绘本集',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '将多个故事组合成一个系列',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page3
class Page3Content extends StatefulWidget {
  final String initialStoryTheme;
  final Function(String) onThemeChanged;

  const Page3Content({
    super.key,
    required this.initialStoryTheme,
    required this.onThemeChanged,
  });

  @override
  State<Page3Content> createState() => _Page3ContentState();
}

class _Page3ContentState extends State<Page3Content> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _selectedThemeIndex;

  // 主题集
  final List<Map<String, dynamic>> _themeOptions = [
    {
      'title': '太空探险',
      'icon': Icons.rocket_launch,
      'colors': [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // 紫色渐变
    },
    {
      'title': '森林冒险',
      'icon': Icons.forest,
      'colors': [Color(0xFF56ab2f), Color(0xFFa8e063)], // 绿色渐变
    },
    {
      'title': '海底世界',
      'icon': Icons.scuba_diving, // 模拟鱼/海底
      'colors': [Color(0xFF2193b0), Color(0xFF6dd5ed)], // 蓝色渐变
    },
    {
      'title': '魔法学校',
      'icon': Icons.auto_fix_high, // 魔法棒
      'colors': [Color(0xFFec008c), Color(0xFFfc6767)], // 粉红渐变
    },
    {
      'title': '恐龙时代',
      'icon': Icons.pets, // 脚印 (模拟恐龙)
      'colors': [Color(0xFFe65c00), Color(0xFFF9D423)], // 橙黄渐变
    },
    {
      'title': '城市英雄',
      'icon': Icons.location_city,
      'colors': [Color(0xFF6190E8), Color(0xFFA7BFE8)], // 灰蓝渐变
    },
    {
      'title': '农场生活',
      'icon': Icons.agriculture,
      'colors': [Color(0xFFB24592), Color(0xFFF15F79)], // 橙红/紫混合
    },
    {
      'title': '动物朋友',
      'icon': Icons.cruelty_free, // 爪印/动物
      'colors': [Color(0xFFc31432), Color(0xFF240b36)], // 深紫红
    },
  ];

  @override
  void initState() {
    super.initState();
    final int matchIndex = _themeOptions.indexWhere(
      (option) => option['title'] == widget.initialStoryTheme,
    );
    if (matchIndex != -1) {
      _selectedThemeIndex = matchIndex;
      _controller.text = '';
    } else {
      _selectedThemeIndex = null;
      _controller.text = widget.initialStoryTheme;
    }
    _controller.addListener(() {
      if (_selectedThemeIndex == null) {
        widget.onThemeChanged(_controller.text);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 处理主题选择
  void _handleThemeSelection(int index) {
    if (_controller.text.isNotEmpty) {
      return;
    }

    setState(() {
      if (_selectedThemeIndex == index) {
        // 取消选中，恢复空状态
        _selectedThemeIndex = null;
        widget.onThemeChanged('');
      } else {
        // 选中新的，将卡片标题作为主题传递
        _selectedThemeIndex = index;
        widget.onThemeChanged(_themeOptions[index]['title']);
      }
    });
  }

  // “或”字渐变分隔线
  Widget _buildDividerWithText(Color dividerColor) {
    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
    );

    Widget line(Alignment begin, Alignment end, bool isLeft) {
      return Expanded(
        child: Container(
          height: 1.3,
          margin: EdgeInsets.symmetric(
            horizontal: isLeft ? 0 : 7.0,
            vertical: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [
                isLeft ? Colors.transparent : dividerColor.withOpacity(0.5),
                dividerColor.withOpacity(0.9),
                isLeft ? dividerColor.withOpacity(0.5) : Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          line(Alignment.centerLeft, Alignment.centerRight, true),
          Text('  或 ', style: textStyle),
          line(Alignment.centerLeft, Alignment.centerRight, false),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Colors.pinkAccent;
    // 互斥逻辑: 只要选中了任意按钮，输入框即被锁定 (enabled = false)
    final bool isInputLocked = _selectedThemeIndex != null;
    // 互斥逻辑: 只要输入框有字，按钮即被禁用
    final bool areButtonsDisabled = _controller.text.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: accentColor,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              const Text(
                '设置故事主题',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17.0),

          // 内容区域
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: isInputLocked
                    ? Colors.grey.withOpacity(0.2)
                    : accentColor.withOpacity(0.3),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.edit_note,
                      color: isInputLocked ? Colors.grey : accentColor,
                      size: 26.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '自定义主题',
                      style: TextStyle(
                        color: isInputLocked ? Colors.grey : Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isInputLocked) ...[
                      const Spacer(),
                      const Text(
                        '(已选择主题模版)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 18.0),
                // 提示
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: isInputLocked ? Colors.grey[300] : Colors.amber,
                      size: 15.5,
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: Text(
                        '描述你想要的故事主题，让AI为你创作独特的绘本故事',
                        style: TextStyle(
                          color: isInputLocked
                              ? Colors.grey[400]
                              : Colors.black.withOpacity(0.7),
                          fontSize: 14.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 输入框
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !isInputLocked,
                  maxLines: 4,
                  cursorColor: accentColor,
                  decoration: InputDecoration(
                    hintText:
                        '例如 : 一只勇敢的小兔子在森林里寻找失踪的朋友，途中遇到了许多有趣的动物，他们一起克服困难...',
                    hintMaxLines: 3,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15.0,
                    ),
                    filled: true,
                    fillColor: isInputLocked
                        ? Colors.grey[100]
                        : const Color(0xfffbf3f8),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: accentColor,
                        width: 1.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 7.0),
              ],
            ),
          ),

          // 分割线
          _buildDividerWithText(Colors.grey),

          const SizedBox(height: 5),

          // 选择主题模板
          _buildThemeSelectionSection(areButtonsDisabled),

          // 底部增加一些留白
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildThemeSelectionSection(bool isDisabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: isDisabled ? Colors.grey : const Color(0xFF9C27B0),
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              '选择主题模版',
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isDisabled) ...[
              const Spacer(),
              const Text(
                '(已选择自定义主题)',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10.0),
        // Subtitle
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
            '快速开始，从热门主题中挑选一个',
            style: TextStyle(
              color: isDisabled ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14.5,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: List.generate(_themeOptions.length, (index) {
                final double cardWidth = (constraints.maxWidth - 12.0) / 2;

                return ThemeCard(
                  width: cardWidth,
                  data: _themeOptions[index],
                  isSelected: _selectedThemeIndex == index,
                  isDisabled: isDisabled,
                  onTap: () => _handleThemeSelection(index),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

// 主题模板的卡片组件
class ThemeCard extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const ThemeCard({
    super.key,
    required this.width,
    required this.data,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.12,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isDisabled) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isDisabled) return;

    widget.onTap();

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  void _handleTapCancel() {
    if (widget.isDisabled) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = widget.data['colors'] as List<Color>;
    const double cardHeight = 110.0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: 1.0 - _controller.value, child: child);
        },
        child: Opacity(
          opacity: widget.isDisabled ? 0.4 : 1.0,
          child: Stack(
            children: [
              Container(
                width: widget.width,
                height: cardHeight,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: widget.isSelected
                        ? Colors.pinkAccent
                        : Colors.grey.withOpacity(0.1),
                    width: widget.isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isSelected
                          ? Colors.pinkAccent.withOpacity(0.15)
                          : Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.isDisabled
                              ? [Colors.grey, Colors.grey]
                              : gradientColors,
                        ),
                      ),
                      child: Icon(
                        widget.data['icon'] as IconData,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.data['title'] as String,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.isSelected)
                Positioned(
                  top: 13.5,
                  right: 13.5,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Page4
class Page4Voice extends StatefulWidget {
  final int? selectedVoiceIndex;
  final Function(int?) onVoiceChanged;

  const Page4Voice({
    super.key,
    required this.selectedVoiceIndex,
    required this.onVoiceChanged,
  });

  @override
  State<Page4Voice> createState() => _Page4VoiceState();
}

class _Page4VoiceState extends State<Page4Voice> {
  // 音色列表
  final List<Map<String, dynamic>> _voiceOptions = [
    {
      'title': '甜美',
      'subtitle': '温柔甜美的女声',
      'themeColor': Colors.pinkAccent, // 粉色
    },
    {
      'title': '温暖',
      'subtitle': '温暖亲切的男声',
      'themeColor': Colors.orangeAccent, // 橙色
    },
    {
      'title': '活泼',
      'subtitle': '活泼有趣的童声',
      'themeColor': Colors.lightGreen, // 绿色
    },
    {
      'title': '轻柔',
      'subtitle': '轻柔舒缓的女声',
      'themeColor': Colors.lightBlueAccent, // 蓝色
    },
    {
      'title': '无声',
      'subtitle': '安静享受绘本世界',
      'themeColor': Colors.blueGrey, // 灰色
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域：麦克风图标 + 文本
          Row(
            children: [
              const Icon(
                Icons.mic_none_rounded,
                color: Colors.pinkAccent,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              const Text(
                '选择朗读音色',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // 音色列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _voiceOptions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final option = _voiceOptions[index];
              final bool isSelected = widget.selectedVoiceIndex == index;
              final Color themeColor = option['themeColor'];

              return _buildVoiceCard(
                index: index,
                title: option['title'],
                subtitle: option['subtitle'],
                themeColor: themeColor,
                isSelected: isSelected,
              );
            },
          ),

          // 底部留白
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // 音色卡片
  Widget _buildVoiceCard({
    required int index,
    required String title,
    required String subtitle,
    required Color themeColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          widget.onVoiceChanged(null);
        } else {
          widget.onVoiceChanged(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? themeColor : Colors.grey.withOpacity(0.2),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13.0),
                  ),
                ],
              ),
            ),

            // 右侧圆形指示器
            _buildRadioIndicator(isSelected, themeColor),
          ],
        ),
      ),
    );
  }

  // 右侧的圆形选择指示器
  Widget _buildRadioIndicator(bool isSelected, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? color : Colors.transparent,
        border: isSelected
            ? null
            : Border.all(color: Colors.grey.withOpacity(0.4), width: 1.5),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8.0,
                height: 8.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

// 虚线边框
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Radius radius;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.radius = const Radius.circular(0),
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    path.addRRect(rrect);

    PathMetric pathMetric = path.computeMetrics().first;
    double totalLength = pathMetric.length;
    double currentDistance = 0.0;

    while (currentDistance < totalLength) {
      final double dashLength = min(dashWidth, totalLength - currentDistance);
      canvas.drawPath(
        pathMetric.extractPath(currentDistance, currentDistance + dashLength),
        paint,
      );
      currentDistance += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is DashedBorderPainter) {
      return oldDelegate.color != color ||
          oldDelegate.strokeWidth != strokeWidth ||
          oldDelegate.radius != radius ||
          oldDelegate.dashWidth != dashWidth ||
          oldDelegate.dashSpace != dashSpace;
    }
    return true;
  }
}

// 进度条组件
class StepIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const StepIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 12, 12.0, 24.0),
      child: Row(
        children: List.generate(totalPages, (index) {
          return Expanded(
            child: Container(
              height: 4.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: index <= currentPage
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
