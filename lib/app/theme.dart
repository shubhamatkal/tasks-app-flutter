import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── DayTask Design Tokens ───────────────────────────────────────────────────
const kBgColor = Color(0xFF212832);
const kSurfaceColor = Color(0xFF263238);
const kInputColor = Color(0xFF455A64);
const kPrimaryColor = Color(0xFFFED36A);
const kTextWhite = Colors.white;
const kTextMuted = Color(0xFF8CAAB9);
const kTextDark = Color(0xFF212832);
const kToggleBlue = Color(0xFF0A7AFF);
const kErrorColor = Color(0xFFCF6679);

// ── Theme ───────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: kBgColor,
    colorScheme: const ColorScheme.dark(
      primary: kPrimaryColor,
      onPrimary: kTextDark,
      surface: kSurfaceColor,
      onSurface: kTextWhite,
      error: kErrorColor,
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: kTextWhite,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: kTextWhite,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: kTextWhite,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: kTextWhite,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: kTextWhite,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: kTextMuted,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kTextDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kInputColor,
      hintStyle: GoogleFonts.inter(color: kTextMuted, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kErrorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kErrorColor, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: kTextDark,
        minimumSize: const Size(double.infinity, 67),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kBgColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: kTextWhite,
      ),
      iconTheme: const IconThemeData(color: kTextWhite),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kSurfaceColor,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: kTextMuted,
      selectedLabelStyle: TextStyle(fontSize: 10),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kSurfaceColor,
      contentTextStyle: GoogleFonts.inter(color: kTextWhite),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kToggleBlue;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(kTextWhite),
      side: const BorderSide(color: kTextMuted, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}
