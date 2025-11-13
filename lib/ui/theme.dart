import 'package:flutter/material.dart';

// ==================== 自定义颜色类（非标准主题色）====================

class CustomColors {
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  const CustomColors({
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });
}

// 统一主题管理类（所有颜色直接硬编码，无转换逻辑）
class AppTheme {
  // ==================== 通用常量（亮色/暗色共用）====================
  static const double baseFontSize = 16.0;
  static final BorderRadius baseRadius = BorderRadius.circular(12.0);
  static const String defaultFontFamily = 'Inter';

  // ==================== 存储自定义颜色映射 ====================
  static final Map<ThemeData, CustomColors> _customColorsMap = {};

  static void _attachCustomColors(ThemeData theme, CustomColors customColors) {
    _customColorsMap[theme] = customColors;
  }

  // ==================== 亮色主题（全硬编码颜色）====================
  static ThemeData get light {
    final customColors = const CustomColors(
      sidebar: Color(0xFFFAFAFA),
      sidebarForeground: Color(0xFF282828),
      sidebarPrimary: Color(0xFF030213),
      sidebarPrimaryForeground: Color(0xFFFAFAFA),
      sidebarAccent: Color(0xFFF9F9F9),
      sidebarAccentForeground: Color(0xFF353535),
      sidebarBorder: Color(0xFFEBEBEB),
      sidebarRing: Color(0xFFB6B6B6),
      chart1: Color(0xFFC17E69),
      chart2: Color(0xFF819389),
      chart3: Color(0xFF5D6569),
      chart4: Color(0xFFDCC586),
      chart5: Color(0xFFC7A97D),
    );

    final theme = ThemeData(
      brightness: Brightness.light,
      fontFamily: defaultFontFamily,
      scaffoldBackgroundColor: const Color(0xFFFAFBFF),
      cardColor: const Color(0xFFFFFFFF),
      primaryColor: const Color(0xFFA78BFA),
      hintColor: const Color(0xFF9CA3AF),
      dividerColor: const Color(0x14000000),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFA78BFA),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFFFCE7F3),
        onSecondary: Color(0xFF030213),
        error: Color(0xFFD4183D),
        onError: Color(0xFFFFFFFF),
        background: Color(0xFFFAFBFF),
        onBackground: Color(0xFF282828),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF282828),
        surfaceVariant: Color(0xFFFEF3F8),
        tertiary: Color(0xFFF3E8FF),
        surfaceTint: Color(0xFFA78BFA),
        inverseSurface: Color(0xFF282828),
        inversePrimary: Color(0xFFC4AFFF),
        outline: Color(0x14000000),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.normal,
          color: Color(0xFF282828),
        ),
        headlineLarge: TextStyle(
          fontSize: baseFontSize * 1.5,
          fontWeight: FontWeight.w500,
          color: Color(0xFF282828),
        ),
        headlineMedium: TextStyle(
          fontSize: baseFontSize * 1.25,
          fontWeight: FontWeight.w500,
          color: Color(0xFF282828),
        ),
        headlineSmall: TextStyle(
          fontSize: baseFontSize * 1.125,
          fontWeight: FontWeight.w500,
          color: Color(0xFF282828),
        ),
        titleMedium: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w500,
          color: Color(0xFF282828),
        ),
        labelMedium: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w500,
          color: Color(0xFF282828),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF282828),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: const Color(0xFFA78BFA),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: baseRadius),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA78BFA),
          foregroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(borderRadius: baseRadius),
          textStyle: const TextStyle(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFA78BFA), // 文本及图标颜色（对应primaryColor）
          textStyle: const TextStyle(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w500,
            fontFamily: defaultFontFamily,
          ),
          shape: RoundedRectangleBorder(borderRadius: baseRadius), // 统一圆角样式
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 默认内边距
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFFEF3F8),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: baseRadius,
          borderSide: const BorderSide(color: Color(0x14000000)),
        ),
      ),
    );

    _attachCustomColors(theme, customColors);
    return theme;
  }

  // ==================== 暗色主题（全硬编码颜色）====================
  static ThemeData get dark {
    final customColors = const CustomColors(
      sidebar: Color(0xFF282828),
      sidebarForeground: Color(0xFFFAFAFA),
      sidebarPrimary: Color(0xFF655490),
      sidebarPrimaryForeground: Color(0xFFFAFAFA),
      sidebarAccent: Color(0xFF494949),
      sidebarAccentForeground: Color(0xFFFAFAFA),
      sidebarBorder: Color(0xFF494949),
      sidebarRing: Color(0xFF707070),
      chart1: Color(0xFF655490),
      chart2: Color(0xFF90B08E),
      chart3: Color(0xFFC7A97D),
      chart4: Color(0xFF7A64C2),
      chart5: Color(0xFFB47271),
    );

    final theme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: defaultFontFamily,
      scaffoldBackgroundColor: const Color(0xFF282828),
      cardColor: const Color(0xFF282828),
      primaryColor: const Color(0xFFFAFAFA),
      hintColor: const Color(0xFFB6B6B6),
      dividerColor: const Color(0xFF494949),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFFAFAFA),
        onPrimary: Color(0xFF353535),
        secondary: Color(0xFF494949),
        onSecondary: Color(0xFFFAFAFA),
        error: Color(0xFF724A4B),
        onError: Color(0xFFC9797A),
        background: Color(0xFF282828),
        onBackground: Color(0xFFFAFAFA),
        surface: Color(0xFF282828),
        onSurface: Color(0xFFFAFAFA),
        surfaceVariant: Color(0xFF282828),
        tertiary: Color(0xFF494949),
        surfaceTint: Color(0xFFFAFAFA),
        inverseSurface: Color(0xFFFAFAFA),
        inversePrimary: Color(0xFF9E9E9E),
        outline: Color(0xFF494949),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.normal,
          color: Color(0xFFFAFAFA),
        ),
        headlineLarge: TextStyle(
          fontSize: baseFontSize * 1.5,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFAFAFA),
        ),
        headlineMedium: TextStyle(
          fontSize: baseFontSize * 1.25,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFAFAFA),
        ),
        headlineSmall: TextStyle(
          fontSize: baseFontSize * 1.125,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFAFAFA),
        ),
        titleMedium: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFAFAFA),
        ),
        labelMedium: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFAFAFA),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF282828),
        foregroundColor: Color(0xFFFAFAFA),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA),
          foregroundColor: const Color(0xFF353535),
          shape: RoundedRectangleBorder(borderRadius: baseRadius),
          textStyle: const TextStyle(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFAFAFA), // 文本及图标颜色（对应primaryColor）
          textStyle: const TextStyle(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w500,
            fontFamily: defaultFontFamily,
          ),
          shape: RoundedRectangleBorder(borderRadius: baseRadius), // 统一圆角样式
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 默认内边距
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFF494949),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: baseRadius,
          borderSide: const BorderSide(color: Color(0xFF494949)),
        ),
      ),
    );

    _attachCustomColors(theme, customColors);
    return theme;
  }
}


