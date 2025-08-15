import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightForeground = Color(0xFF252525);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardForeground = Color(0xFF252525);
  static const Color lightPrimary = Color(0xFF030213);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFF3F3F5);
  static const Color lightSecondaryForeground = Color(0xFF030213);
  static const Color lightMuted = Color(0xFFECECF0);
  static const Color lightMutedForeground = Color(0xFF717182);
  static const Color lightAccent = Color(0xFFE9EBEF);
  static const Color lightAccentForeground = Color(0xFF030213);
  static const Color lightDestructive = Color(0xFFD4183D);
  static const Color lightDestructiveForeground = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  static const Color lightInputBackground = Color(0xFFF3F3F5);
  static const Color lightSwitchBackground = Color(0xFFCBCED4);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF252525);
  static const Color darkForeground = Color(0xFFFBFBFB);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkCardForeground = Color(0xFFFBFBFB);
  static const Color darkPrimary = Color(0xFFFBFBFB);
  static const Color darkPrimaryForeground = Color(0xFF353535);
  static const Color darkSecondary = Color(0xFF454545);
  static const Color darkSecondaryForeground = Color(0xFFFBFBFB);
  static const Color darkMuted = Color(0xFF454545);
  static const Color darkMutedForeground = Color(0xFFB5B5B5);
  static const Color darkAccent = Color(0xFF454545);
  static const Color darkAccentForeground = Color(0xFFFBFBFB);
  static const Color darkDestructive = Color(0xFF662B37);
  static const Color darkDestructiveForeground = Color(0xFFA86B6B);
  static const Color darkBorder = Color(0xFF454545);
  static const Color darkInputBackground = Color(0xFF454545);
  static const Color darkSwitchBackground = Color(0xFF454545);

  // Chart colors for light theme
  static const Color chartColor1Light = Color(0xFFB8860B);
  static const Color chartColor2Light = Color(0xFF4682B4);
  static const Color chartColor3Light = Color(0xFF483D8B);
  static const Color chartColor4Light = Color(0xFF32CD32);
  static const Color chartColor5Light = Color(0xFFFF6347);

  // Chart colors for dark theme
  static const Color chartColor1Dark = Color(0xFF9370DB);
  static const Color chartColor2Dark = Color(0xFF20B2AA);
  static const Color chartColor3Dark = Color(0xFFFF6347);
  static const Color chartColor4Dark = Color(0xFFBA55D3);
  static const Color chartColor5Dark = Color(0xFFFF4500);

  // Sidebar colors
  static const Color lightSidebar = Color(0xFFFBFBFB);
  static const Color lightSidebarForeground = Color(0xFF252525);
  static const Color lightSidebarPrimary = Color(0xFF030213);
  static const Color lightSidebarPrimaryForeground = Color(0xFFFBFBFB);
  static const Color lightSidebarAccent = Color(0xFFF8F8F8);
  static const Color lightSidebarAccentForeground = Color(0xFF353535);
  static const Color lightSidebarBorder = Color(0xFFEBEBEB);

  static const Color darkSidebar = Color(0xFF353535);
  static const Color darkSidebarForeground = Color(0xFFFBFBFB);
  static const Color darkSidebarPrimary = Color(0xFF9370DB);
  static const Color darkSidebarPrimaryForeground = Color(0xFFFBFBFB);
  static const Color darkSidebarAccent = Color(0xFF454545);
  static const Color darkSidebarAccentForeground = Color(0xFFFBFBFB);
  static const Color darkSidebarBorder = Color(0xFF454545);
}

class AppTheme {
  static const double fontSize = 14.0;
  static const double radiusSmall = 6.0; // --radius - 4px (10 - 4)
  static const double radiusMedium = 8.0; // --radius - 2px (10 - 2)
  static const double radiusLarge = 10.0; // --radius
  static const double radiusXLarge = 14.0; // --radius + 4px (10 + 4)

  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'DefaultFont', // Substitua pela fonte desejada
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightPrimaryForeground,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightSecondaryForeground,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightCardForeground,
      error: AppColors.lightDestructive,
      onError: AppColors.lightDestructiveForeground,
      outline: AppColors.lightBorder,
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        textStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        textStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        textStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28, // 2xl equivalent
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.lightForeground,
      ),
      headlineMedium: TextStyle(
        fontSize: 20, // xl equivalent
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.lightForeground,
      ),
      headlineSmall: TextStyle(
        fontSize: 18, // lg equivalent
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.lightForeground,
      ),
      titleMedium: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.lightForeground,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightNormal,
        height: 1.5,
        color: AppColors.lightForeground,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightNormal,
        height: 1.5,
        color: AppColors.lightMutedForeground,
      ),
      labelLarge: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.lightForeground,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightPrimary;
        }
        return AppColors.lightSwitchBackground;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightPrimary.withValues(alpha: 0.5);
        }
        return AppColors.lightSwitchBackground;
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'DefaultFont', // Substitua pela fonte desejada
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkPrimaryForeground,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkSecondaryForeground,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkCardForeground,
      error: AppColors.darkDestructive,
      onError: AppColors.darkDestructiveForeground,
      outline: AppColors.darkBorder,
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        textStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        textStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        textStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeightMedium,
        ),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28, // 2xl equivalent
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.darkForeground,
      ),
      headlineMedium: TextStyle(
        fontSize: 20, // xl equivalent
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.darkForeground,
      ),
      headlineSmall: TextStyle(
        fontSize: 18, // lg equivalent
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.darkForeground,
      ),
      titleMedium: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.darkForeground,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightNormal,
        height: 1.5,
        color: AppColors.darkForeground,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightNormal,
        height: 1.5,
        color: AppColors.darkMutedForeground,
      ),
      labelLarge: TextStyle(
        fontSize: fontSize, // base
        fontWeight: fontWeightMedium,
        height: 1.5,
        color: AppColors.darkForeground,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkPrimary;
        }
        return AppColors.darkSwitchBackground;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkPrimary.withValues(alpha: 0.5);
        }
        return AppColors.darkSwitchBackground;
      }),
    ),
  );
}

// Exemplo de uso no MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Usa o tema do sistema
      home: const Scaffold(
        body: Center(
          child: Text('Flutter App com Tema Customizado'),
        ),
      ),
    );
  }
}

// Classe para acessar cores customizadas facilmente
extension AppColorsExtension on BuildContext {
  CustomAppColors get colors => Theme.of(this).brightness == Brightness.light
      ? _LightCustomAppColors()
      : _DarkCustomAppColors();
}

abstract class CustomAppColors {
  Color get chartColor1;
  Color get chartColor2;
  Color get chartColor3;
  Color get chartColor4;
  Color get chartColor5;
  Color get sidebarBackground;
  Color get sidebarForeground;
  Color get sidebarPrimary;
  Color get sidebarPrimaryForeground;
  Color get sidebarAccent;
  Color get sidebarAccentForeground;
  Color get sidebarBorder;
  Color get mutedForeground;
  Color get accent;
  Color get accentForeground;
}

class _LightCustomAppColors extends CustomAppColors {
  Color get chartColor1 => AppColors.chartColor1Light;
  Color get chartColor2 => AppColors.chartColor2Light;
  Color get chartColor3 => AppColors.chartColor3Light;
  Color get chartColor4 => AppColors.chartColor4Light;
  Color get chartColor5 => AppColors.chartColor5Light;
  Color get sidebarBackground => AppColors.lightSidebar;
  Color get sidebarForeground => AppColors.lightSidebarForeground;
  Color get sidebarPrimary => AppColors.lightSidebarPrimary;
  Color get sidebarPrimaryForeground => AppColors.lightSidebarPrimaryForeground;
  Color get sidebarAccent => AppColors.lightSidebarAccent;
  Color get sidebarAccentForeground => AppColors.lightSidebarAccentForeground;
  Color get sidebarBorder => AppColors.lightSidebarBorder;
  Color get mutedForeground => AppColors.lightMutedForeground;
  Color get accent => AppColors.lightAccent;
  Color get accentForeground => AppColors.lightAccentForeground;
}

class _DarkCustomAppColors extends CustomAppColors {
  Color get chartColor1 => AppColors.chartColor1Dark;
  Color get chartColor2 => AppColors.chartColor2Dark;
  Color get chartColor3 => AppColors.chartColor3Dark;
  Color get chartColor4 => AppColors.chartColor4Dark;
  Color get chartColor5 => AppColors.chartColor5Dark;
  Color get sidebarBackground => AppColors.darkSidebar;
  Color get sidebarForeground => AppColors.darkSidebarForeground;
  Color get sidebarPrimary => AppColors.darkSidebarPrimary;
  Color get sidebarPrimaryForeground => AppColors.darkSidebarPrimaryForeground;
  Color get sidebarAccent => AppColors.darkSidebarAccent;
  Color get sidebarAccentForeground => AppColors.darkSidebarAccentForeground;
  Color get sidebarBorder => AppColors.darkSidebarBorder;
  Color get mutedForeground => AppColors.darkMutedForeground;
  Color get accent => AppColors.darkAccent;
  Color get accentForeground => AppColors.darkAccentForeground;
}