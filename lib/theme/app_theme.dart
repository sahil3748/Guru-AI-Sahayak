import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the educational mobile application.
/// Implements Contemporary Educational Minimalism with Warm Academic Palette.
class AppTheme {
  AppTheme._();

  // Warm Academic Palette - Brand Colors
  static const Color primaryBlue = Color(0xFF3182CE);
  static const Color alertRed = Color(0xFFE53E3E);
  static const Color successGreen = Color(0xFF38A169);
  static const Color warningYellow = Color(0xFFFBD38D);

  // Surface and Background Colors
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF7FAFC);
  static const Color backgroundOffWhite = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1A202C);
  static const Color surfaceDark = Color(0xFF2D3748);
  static const Color surfaceVariantDark = Color(0xFF4A5568);

  // Text Colors - Light Theme
  static const Color onSurfacePrimary = Color(0xFF4A5568);
  static const Color onSurfaceSecondary = Color(0xFF718096);
  static const Color onSurfaceDisabled = Color(0xFFA0AEC0);

  // Text Colors - Dark Theme
  static const Color onSurfacePrimaryDark = Color(0xFFE2E8F0);
  static const Color onSurfaceSecondaryDark = Color(0xFFCBD5E0);
  static const Color onSurfaceDisabledDark = Color(0xFF718096);

  // Outline and Border Colors
  static const Color outlineLight = Color(0xFFE2E8F0);
  static const Color outlineDark = Color(0xFF4A5568);

  // Shadow Colors
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x1F000000);

  /// Light theme optimized for educational mobile applications
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: surfaceWhite,
      primaryContainer: primaryBlue.withValues(alpha: 0.1),
      onPrimaryContainer: primaryBlue,
      secondary: successGreen,
      onSecondary: surfaceWhite,
      secondaryContainer: successGreen.withValues(alpha: 0.1),
      onSecondaryContainer: successGreen,
      tertiary: warningYellow,
      onTertiary: onSurfacePrimary,
      tertiaryContainer: warningYellow.withValues(alpha: 0.2),
      onTertiaryContainer: onSurfacePrimary,
      error: alertRed,
      onError: surfaceWhite,
      errorContainer: alertRed.withValues(alpha: 0.1),
      onErrorContainer: alertRed,
      surface: surfaceWhite,
      onSurface: onSurfacePrimary,
      onSurfaceVariant: onSurfaceSecondary,
      outline: outlineLight,
      outlineVariant: outlineLight.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: surfaceDark,
      onInverseSurface: onSurfacePrimaryDark,
      inversePrimary: primaryBlue.withValues(alpha: 0.8),
      surfaceContainerHighest: surfaceVariant,
      surfaceContainer: surfaceVariant.withValues(alpha: 0.5),
    ),
    scaffoldBackgroundColor: backgroundOffWhite,
    cardColor: surfaceWhite,
    dividerColor: outlineLight,

    // AppBar Theme - Clean and minimal
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceWhite,
      foregroundColor: onSurfacePrimary,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurfacePrimary,
        letterSpacing: -0.2,
      ),
      iconTheme: const IconThemeData(
        color: onSurfacePrimary,
        size: 24,
      ),
    ),

    // Card Theme - Subtle elevation with rounded corners
    cardTheme: CardThemeData(
      color: surfaceWhite,
      elevation: 2.0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceWhite,
      selectedItemColor: primaryBlue,
      unselectedItemColor: onSurfaceSecondary,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button Theme - Contextual appearance
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: surfaceWhite,
      elevation: 4.0,
      shape: CircleBorder(),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceWhite,
        backgroundColor: primaryBlue,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Text Theme - Inter font family for optimal mobile readability
    textTheme: _buildTextTheme(isLight: true),

    // Input Decoration Theme - Clean forms with clear focus states
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: outlineLight, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: outlineLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: alertRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: alertRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: onSurfaceSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: onSurfaceDisabled,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: alertRed,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return onSurfaceDisabled;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.3);
        }
        return outlineLight;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(surfaceWhite),
      side: const BorderSide(color: outlineLight, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return onSurfaceSecondary;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: outlineLight,
      circularTrackColor: outlineLight,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withValues(alpha: 0.2),
      inactiveTrackColor: outlineLight,
      trackHeight: 4.0,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryBlue,
      unselectedLabelColor: onSurfaceSecondary,
      indicatorColor: primaryBlue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfacePrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfacePrimary,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceWhite,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: warningYellow,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),

    // Expansion Tile Theme for Progressive Disclosure
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: surfaceWhite,
      collapsedBackgroundColor: surfaceWhite,
      iconColor: onSurfaceSecondary,
      collapsedIconColor: onSurfaceSecondary,
      textColor: onSurfacePrimary,
      collapsedTextColor: onSurfacePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onSurfacePrimary,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurfaceSecondary,
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceWhite),
  );

  /// Dark theme optimized for educational mobile applications
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlue.withValues(alpha: 0.8),
      onPrimary: backgroundDark,
      primaryContainer: primaryBlue.withValues(alpha: 0.2),
      onPrimaryContainer: primaryBlue.withValues(alpha: 0.8),
      secondary: successGreen.withValues(alpha: 0.8),
      onSecondary: backgroundDark,
      secondaryContainer: successGreen.withValues(alpha: 0.2),
      onSecondaryContainer: successGreen.withValues(alpha: 0.8),
      tertiary: warningYellow,
      onTertiary: backgroundDark,
      tertiaryContainer: warningYellow.withValues(alpha: 0.2),
      onTertiaryContainer: warningYellow,
      error: alertRed.withValues(alpha: 0.8),
      onError: backgroundDark,
      errorContainer: alertRed.withValues(alpha: 0.2),
      onErrorContainer: alertRed.withValues(alpha: 0.8),
      surface: surfaceDark,
      onSurface: onSurfacePrimaryDark,
      onSurfaceVariant: onSurfaceSecondaryDark,
      outline: outlineDark,
      outlineVariant: outlineDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceWhite,
      onInverseSurface: onSurfacePrimary,
      inversePrimary: primaryBlue,
      surfaceContainerHighest: surfaceVariantDark,
      surfaceContainer: surfaceVariantDark.withValues(alpha: 0.5),
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: outlineDark,

    // AppBar Theme - Dark variant
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: onSurfacePrimaryDark,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurfacePrimaryDark,
        letterSpacing: -0.2,
      ),
      iconTheme: const IconThemeData(
        color: onSurfacePrimaryDark,
        size: 24,
      ),
    ),

    // Card Theme - Dark variant
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 4.0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation Theme - Dark variant
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryBlue.withValues(alpha: 0.8),
      unselectedItemColor: onSurfaceSecondaryDark,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button Theme - Dark variant
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue.withValues(alpha: 0.8),
      foregroundColor: backgroundDark,
      elevation: 4.0,
      shape: const CircleBorder(),
    ),

    // Button Themes - Dark variants
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundDark,
        backgroundColor: primaryBlue.withValues(alpha: 0.8),
        elevation: 2.0,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: primaryBlue.withValues(alpha: 0.8), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Text Theme - Dark variant
    textTheme: _buildTextTheme(isLight: false),

    // Input Decoration Theme - Dark variant
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: outlineDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: outlineDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: primaryBlue.withValues(alpha: 0.8), width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: alertRed.withValues(alpha: 0.8), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: alertRed.withValues(alpha: 0.8), width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: onSurfaceSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: onSurfaceDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: alertRed.withValues(alpha: 0.8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch Theme - Dark variant
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.8);
        }
        return onSurfaceDisabledDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.3);
        }
        return outlineDark;
      }),
    ),

    // Checkbox Theme - Dark variant
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.8);
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundDark),
      side: const BorderSide(color: outlineDark, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio Theme - Dark variant
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.8);
        }
        return onSurfaceSecondaryDark;
      }),
    ),

    // Progress Indicator Theme - Dark variant
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryBlue.withValues(alpha: 0.8),
      linearTrackColor: outlineDark,
      circularTrackColor: outlineDark,
    ),

    // Slider Theme - Dark variant
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue.withValues(alpha: 0.8),
      thumbColor: primaryBlue.withValues(alpha: 0.8),
      overlayColor: primaryBlue.withValues(alpha: 0.2),
      inactiveTrackColor: outlineDark,
      trackHeight: 4.0,
    ),

    // Tab Bar Theme - Dark variant
    tabBarTheme: TabBarThemeData(
      labelColor: primaryBlue.withValues(alpha: 0.8),
      unselectedLabelColor: onSurfaceSecondaryDark,
      indicatorColor: primaryBlue.withValues(alpha: 0.8),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip Theme - Dark variant
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfacePrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme - Dark variant
    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfacePrimaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: warningYellow,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),

    // Expansion Tile Theme - Dark variant
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: surfaceDark,
      collapsedBackgroundColor: surfaceDark,
      iconColor: onSurfaceSecondaryDark,
      collapsedIconColor: onSurfaceSecondaryDark,
      textColor: onSurfacePrimaryDark,
      collapsedTextColor: onSurfacePrimaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // List Tile Theme - Dark variant
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onSurfacePrimaryDark,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurfaceSecondaryDark,
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceDark),
  );

  /// Helper method to build text theme based on brightness using Inter font
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? onSurfacePrimary : onSurfacePrimaryDark;
    final Color textMediumEmphasis =
        isLight ? onSurfaceSecondary : onSurfaceSecondaryDark;
    final Color textDisabled =
        isLight ? onSurfaceDisabled : onSurfaceDisabledDark;

    return TextTheme(
      // Display styles - Large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Section headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Card and component titles
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Main content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Buttons and form labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}
