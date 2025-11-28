import 'package:flutter/material.dart';
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
      // 【修改】移除左侧 Padding，使其在 ListView 中能紧贴左侧边缘
      padding: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
      child: InkWell(
        onTap: () {
          context.push('/${AppRouteNames.characterManagementPage}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 110, // 固定宽度
          height: 160, // 固定高度
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1.0), // 灰色实线边框
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 顶部对齐以匹配 AddCharacterCard
            children: [
              const SizedBox(height: 24), // 调整此高度以确保人物头像的垂直中心与星形图标的垂直中心对齐
              // 圆形人物图片
              CircleAvatar(
                radius: 32, // 直径 64，与 AddCharacterCard 保持一致
                backgroundImage: NetworkImage(character.avatarUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 12),
              // 人物姓名
              Text(
                character.characterName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600, // 加粗以匹配 CharacterCard 的名字
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // 描述
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // 圆角灰色背景
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  character.desc,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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