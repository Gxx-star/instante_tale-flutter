import 'package:flutter/material.dart';

class CreateBookConfig {
  static final totalPages = 4;
  static final maxStyles = 3;
  static final modelOptions = [
    {
      'title': '极速模型',
      'subtitle': '生成速度快，但是质量稍逊色',
      'themeColor': Colors.pinkAccent, // 粉色
      'model': 'FAST',
    },
    {
      'title': '普通模型',
      'subtitle': '生成速度较快，质量相对好一点',
      'themeColor': Colors.orangeAccent, // 橙色
      'model': 'AUTO',
    },
    {
      'title': '专业模型',
      'subtitle': '生成速度慢，生成的质量好',
      'themeColor': Colors.lightGreen, // 绿色
      'model': 'PRO',
    },
    {
      'title': '默认模型',
      'subtitle': '生成速度很慢，生成的质量中等，但故事连贯',
      'themeColor': Colors.lightBlueAccent, // 蓝色
      'model': 'DEFAULT',
    },
  ];
  static final styleOptions = [
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
  static final primaryColor = Color(0xFFfaf3f8);
  static final accentColor = Colors.pinkAccent;
  static final headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFedb2d8), // Top-left light pink
      Color(0xFFe8d4f6), // Bottom-right softer pink
    ],
  );
  static final themeOptions = [
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
  static final maxCharacters = 3;
  static final fastBookMaxCharacters = 1;
}
