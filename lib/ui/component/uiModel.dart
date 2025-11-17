import 'package:flutter/material.dart';

// 定义人物数据模型
class CharacterItem {
  final String name;
  final String? gender;
  final int? age;
  final DateTime createdAt; // 创作时间，用于排序
  final String imageUrl;
  final int storyCount;

  CharacterItem({
    required this.name,
    this.gender,
    this.age,
    required this.createdAt,
    required this.imageUrl,
    required this.storyCount,
  });
}

// 定义绘本数据模型
class BookItem {
  final String name;
  final String author;
  final int pages;
  final int clicks; // 用于排序的主要 int 值 (点击数)，越大越靠前
  final int liked;
  final String imageUrl; // 绘本封面图片 URL
  final DateTime? favoritedTimestamp; // 【新增】收藏时间，null表示未收藏

  BookItem({
    required this.name,
    required this.author,
    required this.pages,
    required this.clicks,
    required this.liked,
    required this.imageUrl,
    this.favoritedTimestamp, // 设为可选
  });
}
