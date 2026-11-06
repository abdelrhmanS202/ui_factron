import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Refined Executive Deep Blue & White Industrial Theme Palette
/// - Deep Executive Blue: #0B1A30 / #0F172A
/// - Royal Primary Blue: #1D4ED8 / #2563EB
/// - Accent Sky Blue: #3B82F6
/// - Light Canvas: #F8FAFC
/// - Pure Card Surface: #FFFFFF
/// - Primary Text: #0F172A
/// - Secondary Text: #475569
/// - Muted Text: #94A3B8
/// - Border: #E2E8F0
class AppColors {
  static const Color primaryBlue = Color(0xFF0B1A30); // Deep Executive Blue
  static const Color primaryBlueLight = Color(0xFF1D4ED8); // Royal Blue
  static const Color accentBlue = Color(0xFF2563EB); // Vibrant Sky Blue
  static const Color deepNavy = Color(0xFF070F1E);

  static const Color sidebarBackground = Color(0xFF0B1A30); // Deep Blue Sidebar
  static const Color sidebarActiveBg = Color(0xFF1E293B); // Active item bg
  static const Color sidebarActiveIndicator = Color(0xFF3B82F6); // Active bar

  static const Color darkBackground = Color(0xFFF8FAFC); // Crisp Light Slate Canvas
  static const Color secondarySurface = Color(0xFFFFFFFF); // White Header & Nav
  static const Color cardSurface = Color(0xFFFFFFFF); // White Card Surface
  static const Color elevatedSurface = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0); // Subtle neutral border

  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A); // Dark Slate Primary Text
  static const Color textSecondary = Color(0xFF475569); // Slate Secondary Text
  static const Color textMuted = Color(0xFF94A3B8); // Muted Text

  // Backward compatibility aliases
  static const Color primaryPurple = Color(0xFF0B1A30);
  static const Color deepPurple = Color(0xFF070F1E);
  static const Color accentLavender = Color(0xFF2563EB);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFEFF6FF);

  static const Color purpleGlow = Color(0x0D000000);
}

class AppTheme {
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.light();

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primaryBlue,
      textTheme: GoogleFonts.cairoTextTheme(baseTheme.textTheme),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentBlue,
        surface: AppColors.cardSurface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.cairo(color: AppColors.textMuted, fontSize: 13),
        labelStyle: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentBlue,
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF1F5F9),
        selectedColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 12),
      ),
    );
  }
}
