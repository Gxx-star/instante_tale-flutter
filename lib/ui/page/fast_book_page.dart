import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app_globals.dart';
import '../../config/create_book_config.dart';
import '../../database/models/character.dart';
import '../../features/book/book_provider.dart';
import '../../features/character/character_provider.dart';
import '../../main.dart';
import '../component/my_snackbar.dart';
import 'create_book.dart';

class FastBookPage extends ConsumerStatefulWidget {
  const FastBookPage({super.key});

  @override
  ConsumerState<FastBookPage> createState() => _FastBookPageState();
}

class _FastBookPageState extends ConsumerState<FastBookPage> {
  final Set<CharacterCollection> _selectedCharacters =
      <CharacterCollection>{}; // 跟踪当前选中的人物ID
  @override
  Widget build(BuildContext context) {
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: characterViewModelProvider,
    );
    final charactersListAsync = ref.watch(characterListProvider);
    final Color primaryColor = CreateBookConfig.primaryColor;
    final Color accentColor = CreateBookConfig.accentColor;
    // 顶部渐变
    final headerGradient = CreateBookConfig.headerGradient;
    return charactersListAsync.when(
      data: (characterList) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            toolbarHeight: 40.0.h,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: const Color(0xfffbfafd),
                size: 24.w,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              '快速生成绘本',
              style: TextStyle(
                color: const Color(0xfffbfafd),
                fontWeight: FontWeight.w500,
                fontSize: 18.0.sp,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0.0.w,
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: headerGradient),
            ),
          ),
          body: Column(
            children: [
              // AppBar 下方的副标题
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10.0.w, 3.0.h, 20.0.w, 15.5.h),
                decoration: BoxDecoration(gradient: headerGradient),
                child: Text(
                  '选择一位角色即可生成一个绘本',
                  style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                ),
              ),
              // 滚动内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 创建新人物按钮
                      _buildCreateNewButton(context, ref),
                      SizedBox(height: 24.0.h),
                      Text(
                        '我的人物',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.0.h),
                      // 人物列表
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: characterList.length,
                        itemBuilder: (context, index) {
                          final character = characterList[index];
                          final isSelected = _selectedCharacters.contains(
                            character,
                          );
                          return _CharacterCard(
                            character: character,
                            isSelected: isSelected,
                            onPressed: () {
                              setState(() {
                                if (_selectedCharacters.contains(character)) {
                                  _selectedCharacters.remove(character);
                                } else {
                                  if (_selectedCharacters.length <
                                      CreateBookConfig.fastBookMaxCharacters) {
                                    _selectedCharacters.add(character);
                                  } else {
                                    MySnackBar.show(
                                      context,
                                      "最多选择${CreateBookConfig.fastBookMaxCharacters}个角色哦~",
                                    );
                                  }
                                }
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
        return Text('error', style: TextStyle(fontSize: 14.sp));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // "创建新人物" 按钮
  Widget _buildCreateNewButton(BuildContext context, WidgetRef ref) {
    const Color pinkAccent = Colors.pinkAccent;
    final double borderRadius = 12.0.r;

    return InkWell(
      onTap: () {
        context.push('/${AppRouteNames.createCharacter}');
      },
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: pinkAccent.withOpacity(0.4),
          strokeWidth: 1.w,
          radius: Radius.circular(borderRadius),
          dashWidth: 5.w,
          dashSpace: 3.w,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 26.0.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: [
              // 左侧：圆形粉色背景的加号
              Container(
                width: 65.w,
                height: 65.w,
                decoration: BoxDecoration(
                  color: pinkAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 45.w),
              ),
              SizedBox(width: 16.0.w),
              // 右侧：两列文字
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 第一行文字：创建新人物
                  Text(
                    '创建新人物',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.0.h),
                  // 第二行文字：上传照片，生成专属绘本主角
                  Text(
                    '上传照片，生成专属绘本主角',
                    style: TextStyle(
                      color: Colors.black54, // 灰色半透明
                      fontSize: 13.0.sp,
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

  // 底部 "开始生成" 按钮
  Widget _buildConfirmButton(BuildContext context, Color accentColor) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 12.0.h),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedCharacters.isNotEmpty
                ? () {
                    // 开始生成
                    ref.read(bookReaderViewModelProvider.notifier).createFastBook(
                      _selectedCharacters.map((character)=>character.characterId).toList(),
                    );
                    context.pop();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              elevation: 0,
              // 禁用时的颜色
              disabledBackgroundColor: const Color(0xffeeadd1),
              disabledForegroundColor: const Color(0xfffdf6fa),
            ),
            child: Text(
              '✨ 开始生成',
              style: TextStyle(
                color: const Color(0xfffceef6),
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
      margin: EdgeInsets.only(bottom: 12.0.h),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? selectedBgColor : Colors.white,
          padding: EdgeInsets.all(14.0.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0.r),
          ),
          side: BorderSide(
            color: isSelected ? selectedBorderColor : defaultBorderColor,
            width: isSelected ? 1.5.w : 1.0.w,
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
            SizedBox(width: 16.0.w),
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
          radius: 33.w,
          backgroundImage: CachedNetworkImageProvider(character.avatarUrl),
        ),
        // 选中时的对勾
        if (isSelected)
          Positioned(
            bottom: -2.w,
            right: -2.w,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 14.w),
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
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0.sp,
            ),
          ),
          SizedBox(height: 6.0.h),
          // 人物的小标签Tags
          Row(
            children: [
              _InfoTag(
                text: '${character.characterName}',
                color: const Color(0xfff7e8f2),
              ),
              SizedBox(width: 8.0.w),
              _InfoTag(
                text:
                    '创建时间：${AppGlobals().formatTimestamp(character.createdAt)}',
                color: const Color(0xfff7e8f2),
              ),
            ],
          ),
          SizedBox(height: 8.0.h),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String text;
  final Color color;

  const _InfoTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 3.0.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.0.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontSize: 12.0.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
