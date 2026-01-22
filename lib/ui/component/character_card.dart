import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/database/models/character.dart';
import 'package:instant_tale/main.dart';

// 已有人物卡片
class CharacterCard extends StatelessWidget {
  final CharacterCollection character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 仅保留水平右侧和垂直间距，单位区分w/h
      padding: EdgeInsets.only(right: 8.w, top: 4.h, bottom: 4.h),
      child: InkWell(
        onTap: () {
          context.push('/${AppRouteNames.characterManagementPage}');
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          // 1. 移除固定宽高，改用最小宽度+自适应高度（核心修复卡片截断）
          constraints: BoxConstraints(
            minWidth: 110.w, // 最小宽度保证卡片不压缩
            maxWidth: 120.w, // 最大宽度限制避免过宽
            minHeight: 200.h,
            maxHeight: 250.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            // 2. 修复边框宽度单位（borderWidth不能用r，改用固定dp）
            border: Border.all(color: Colors.grey[300]!, width: 1.0),
          ),
          // 3. 用Padding替代固定高度，让内容自适应
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.max, // 高度自适应内容（关键）
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 圆形人物图片（半径适配+容错）
                CircleAvatar(
                  radius: 27.w,
                  backgroundImage: CachedNetworkImageProvider(character.avatarUrl),
                  backgroundColor: Colors.grey[200],
                  // 图片加载失败兜底
                  child: character.avatarUrl.isEmpty
                      ? Icon(Icons.person, size: 32.w, color: Colors.grey[500])
                      : null,
                ),
                SizedBox(height: 8.h), // 高度用h（修复之前w混用问题）
                // 人物姓名（强制溢出省略）
                Text(
                  character.characterName,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center, // 居中避免偏左溢出
                ),
                SizedBox(height: 4.h), // 高度用h
                // 描述（核心修复文本溢出）
                Container(
                  constraints: BoxConstraints(maxWidth: 90.w), // 限制最大宽度
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r), // 圆角适度缩小
                  ),
                  child: Text(
                    character.desc.isEmpty ? '无描述' : character.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // 强制溢出省略
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center, // 居中显示
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
