import 'dart:ui';

import 'package:flutter/material.dart';

import '../ui/component/my_snackbar.dart';
import '../ui/component/setting_item.dart';

class MainPageConfig {
  static final swiperImages = [
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-c523e00b552859928cef368b7b77e566.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-14f0801056b5516cb69a762f62b60ae0.png',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-09d03e52070451ce993880bff5484b08.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-429fed69e4a55c08841eaac1ed81dfe0.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-5c29d9ed9583598ba4ecabb63569231c.jpg',
    'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-3fbf8ae1450353c2ad9db108c587d00a.jpg',
  ];
  static final rankingList = [
    {
      'rank': 1,
      'title': '森林里的秘密',
      'description': '自然故事家',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-30057b9671fa544bab038cb83c3215ec.jpg',
      'likes': 9, // 0.9k
      'reads': 12.5, // 12.5k
    },
    {
      'rank': 2,
      'title': '魔法世界探险',
      'description': '魔法创作者',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-c0312588d70f5a238877ef88b3e6bbb9.jpg',
      'likes': 19, // 1.9k
      'reads': 23.5, // 23.5k
    },
    {
      'rank': 3,
      'title': '海洋生物图鉴',
      'description': '小小科学家',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-a723f22b34355ddca9ba2fb08d720ef4.jpg',
      'likes': 5, // 0.5k
      'reads': 8.2, // 8.2k
    },
  ];
  static final squareList = [
    {
      'title': '彩色的梦想',
      'author': '梦想家',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-99bf8f20d53f5995bd41150fa8fdb17b.jpg',
      'tagText': '热门',
      'tagColor': Color(0xFFE91E63),
    },
    {
      'title': '奇妙之旅',
      'author': '旅行者',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-cef72bbabead5df8beb38a5bc4306b57.jpg',
      'tagText': '推荐',
      'tagColor': Color(0xFF673AB7),
    },
    {
      'title': '动物王国',
      'author': '自然之友',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-935a7e64393a5719837d03ad2d0aca4b.jpg',
      'tagText': '新品',
      'tagColor': Color(0xFF4CAF50),
    },
    {
      'title': '星空物语',
      'author': '星空讲述者',
      'imageUrl':
          'https://book-1369048677.cos.ap-beijing.myqcloud.com/img-70c6ff6d13f65be1af553703c9d0348c.jpg',
      'tagText': '精选',
      'tagColor': Color(0xFF2196F3), // 精选 (蓝色)
    },
  ];
  static final settingsData = [
    {
      "iconData": Icons.person_outline,
      "iconColor": const Color(0xFF42A5F5),
      // 蓝色
      "iconBackgroundColor": const Color(0xFFE3F2FD),
      // 浅蓝色
      "title": '个人资料',
      "subtitle": '编辑昵称、头像等信息',
    },
    {
      "iconData": Icons.notifications_none,
      "iconColor": Color(0xFFAB47BC),
      // 紫色
      "iconBackgroundColor": Color(0xFFF3E5F5),
      // 浅紫色
      "title": '通知设置',
      "subtitle": '管理推送通知',
    },
    {
      "iconData": Icons.security,
      // 更换为盾牌 icon
      "iconColor": Color(0xFF66BB6A),
      // 翠绿色
      "iconBackgroundColor": Color(0xFFE8F5E9),
      // 浅绿色
      "title": '隐私与安全',
      "subtitle": '密码、隐私设置',
    },
    {
      "iconData": Icons.help_outline,
      "iconColor": Color(0xFFFF7043),
      // 橙色
      "iconBackgroundColor": Color(0xFFFFF3E0),
      // 浅橙色
      "title": '帮助与反馈',
      "subtitle": '常见问题、联系客服',
    },
    {
      "iconData": Icons.star_outline,
      "iconColor": Color(0xFFFFCA28),
      // 深黄色
      "iconBackgroundColor": Color(0xFFFFFDE7),
      // 浅黄色
      "title": '关于我们',
      "subtitle": '版本 1.0.0',
    },
  ];
}
