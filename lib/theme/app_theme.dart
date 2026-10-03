import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (Forest Green Palette)
  static const Color primary = Color(0xFF1B4332); // Forest green
  static const Color secondary = Color(0xFF6B9080); // Sage
  static const Color tertiary = Color(0xFFD4A373); // Warm tan
  
  // Background & Surface
  static const Color lightBackground = Color(0xFFF1F8F4);
  static const Color darkBackground = Color(0xFF081C15);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF10241A);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1B2E22);
  static const Color textPrimaryDark = Color(0xFFE8F5E9);
  static const Color textMuted = Color(0xFF52796F);
  
  // Semantic Colors
  static const Color success = Color(0xFF40916C);
  static const Color warning = Color(0xFFE9A23B);
  static const Color errorColor = Color(0xFFBC4749);

  // Layout & UI values
  static const double borderRadius = 12.0;

  static TextTheme buildTextTheme(TextTheme base, {
    String? headingFontFamily,
    String? bodyFontFamily,
    String? monoFontFamily,
  }) {
    final String actualHeading = headingFontFamily ?? GoogleFonts.newsreader().fontFamily!;
    final String actualBody = bodyFontFamily ?? GoogleFonts.plusJakartaSans().fontFamily!;
    final String actualMono = monoFontFamily ?? GoogleFonts.jetBrainsMono().fontFamily!;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontFamily: actualHeading),
      displayMedium: base.displayMedium?.copyWith(fontFamily: actualHeading),
      displaySmall: base.displaySmall?.copyWith(fontFamily: actualHeading),
      headlineLarge: base.headlineLarge?.copyWith(fontFamily: actualHeading),
      headlineMedium: base.headlineMedium?.copyWith(fontFamily: actualHeading),
      headlineSmall: base.headlineSmall?.copyWith(fontFamily: actualHeading),
      titleLarge: base.titleLarge?.copyWith(fontFamily: actualHeading),
      titleMedium: base.titleMedium?.copyWith(fontFamily: actualBody),
      titleSmall: base.titleSmall?.copyWith(fontFamily: actualBody),
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: actualBody),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: actualBody),
      bodySmall: base.bodySmall?.copyWith(fontFamily: actualBody),
      labelLarge: base.labelLarge?.copyWith(fontFamily: actualBody),
      labelMedium: base.labelMedium?.copyWith(fontFamily: actualMono),
      labelSmall: base.labelSmall?.copyWith(fontFamily: actualMono),
    );
  }

  static ThemeData get lightTheme => buildTheme(Brightness.light);
  static ThemeData get darkTheme => buildTheme(Brightness.dark);

  static ThemeData buildTheme(Brightness brightness, {
    String? headingFontFamily,
    String? bodyFontFamily,
    String? monoFontFamily,
  }) {
    final isDark = brightness == Brightness.dark;
    
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      tertiary: tertiary,
      onTertiary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surface: isDark ? darkSurface : lightSurface,
      onSurface: isDark ? textPrimaryDark : textPrimaryLight,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? darkBackground : lightBackground,
    );

    return baseTheme.copyWith(
      textTheme: buildTextTheme(
        baseTheme.textTheme,
        headingFontFamily: headingFontFamily,
        bodyFontFamily: bodyFontFamily,
        monoFontFamily: monoFontFamily,
      ).apply(
        bodyColor: isDark ? textPrimaryDark : textPrimaryLight,
        displayColor: isDark ? textPrimaryDark : textPrimaryLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: textMuted.withValues(alpha: 0.2), width: 1),
        ),
      ),
    );
  }
}
