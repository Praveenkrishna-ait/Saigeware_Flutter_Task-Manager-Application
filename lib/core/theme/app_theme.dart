import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration — Dark Gravity Edition
class AppTheme {
  AppTheme._();

  // ── Dark Palette ────────────────────────────────────────────────────────────
  static const Color backgroundDeep    = Color(0xFF070A14);
  static const Color backgroundBase    = Color(0xFF0B0F1F);
  static const Color surfaceDark       = Color(0xFF111827);
  static const Color surfaceCard       = Color(0xFF151D30);
  static const Color surfaceElevated   = Color(0xFF1C2640);

  static const Color primaryColor      = Color(0xFF7C6BFF);  // neon violet
  static const Color primaryDark       = Color(0xFF5A4ECC);
  static const Color primaryGlow       = Color(0x557C6BFF);
  static const Color accentColor       = Color(0xFF00F5D4);  // neon teal
  static const Color accentGlow        = Color(0x4400F5D4);

  static const Color errorColor        = Color(0xFFFF4E6A);
  static const Color errorGlow         = Color(0x55FF4E6A);
  static const Color warningColor      = Color(0xFFFFB347);
  static const Color successColor      = Color(0xFF00E676);
  static const Color successGlow       = Color(0x4400E676);

  static const Color dividerColor      = Color(0xFF1F2D45);
  static const Color textPrimary       = Color(0xFFF0F4FF);
  static const Color textSecondary     = Color(0xFF8892B0);
  static const Color textMuted         = Color(0xFF4A5568);

  // Priority Colors (neon)
  static const Color lowPriorityColor      = Color(0xFF00BCD4);
  static const Color mediumPriorityColor   = Color(0xFFFFB347);
  static const Color highPriorityColor     = Color(0xFFFF4E6A);

  // Spacing
  static const double spacing2  = 2;
  static const double spacing4  = 4;
  static const double spacing8  = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // Border Radius
  static const double radiusSmall  = 8;
  static const double radiusMedium = 16;
  static const double radiusLarge  = 24;
  static const double radiusXL     = 32;

  // ── Glassmorphism Card Decoration ───────────────────────────────────────────
  static BoxDecoration glassDecoration({
    Color borderColor = const Color(0xFF2A3555),
    Color bgColor = const Color(0xFF111827),
    double radius = radiusLarge,
    Color? glowColor,
  }) {
    return BoxDecoration(
      color: bgColor.withOpacity(0.72),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        if (glowColor != null)
          BoxShadow(
            color: glowColor.withOpacity(0.18),
            blurRadius: 32,
            spreadRadius: 2,
          ),
      ],
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: surfaceDark,
      ),
      scaffoldBackgroundColor: backgroundBase,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge:  GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary),
        displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary),
        displaySmall:  GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        headlineMedium:GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        headlineSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge:    GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium:   GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
        titleSmall:    GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
        bodyLarge:     GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium:    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: textPrimary),
        bodySmall:     GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge:    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
        labelMedium:   GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
        labelSmall:    GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: textMuted),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: spacing16, vertical: spacing12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: spacing16, vertical: spacing12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.all(spacing16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        errorStyle: GoogleFonts.inter(color: errorColor, fontSize: 12),
        prefixIconColor: textSecondary,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: Color(0xFF3A4A6B), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dividerTheme: const DividerThemeData(color: dividerColor, thickness: 1, space: spacing16),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 13),
        actionTextColor: accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        behavior: SnackBarBehavior.floating,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: dividerColor),
        ),
        textStyle: GoogleFonts.inter(color: textPrimary, fontSize: 13),
      ),
    );
  }

  // ── Priority Helpers ─────────────────────────────────────────────────────────
  static Color getPriorityColor(int priorityIndex) {
    switch (priorityIndex) {
      case 0: return lowPriorityColor;
      case 1: return mediumPriorityColor;
      case 2: return highPriorityColor;
      default: return lowPriorityColor;
    }
  }

  static String getPriorityLabel(int priorityIndex) {
    switch (priorityIndex) {
      case 0: return 'Low';
      case 1: return 'Medium';
      case 2: return 'High';
      default: return 'Low';
    }
  }

  static IconData getPriorityIcon(int priorityIndex) {
    switch (priorityIndex) {
      case 0: return Icons.arrow_downward_rounded;
      case 1: return Icons.remove_rounded;
      case 2: return Icons.arrow_upward_rounded;
      default: return Icons.arrow_downward_rounded;
    }
  }

  // ── Legacy light theme (kept for safety) ────────────────────────────────────
  static ThemeData get lightTheme => darkTheme;

  // Aliases for backward compat
  static const Color backgroundColor  = backgroundBase;
  static const Color primaryDarkColor = primaryDark;
}
