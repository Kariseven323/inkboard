import 'package:flutter/material.dart';
import 'facebook_colors.dart';
import 'facebook_text_styles.dart';
import 'facebook_sizes.dart';

/// Facebook风格主题系统
/// 整合颜色、文字、尺寸等设计token
class FacebookTheme {
  FacebookTheme._();

  /// 获取亮色主题
  static ThemeData getLightTheme() {
    final colorScheme = FacebookColors.getColorScheme();
    final textTheme = FacebookTextStyles.getTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: 'SF Pro Display',

      // AppBar主题
      appBarTheme: AppBarTheme(
        backgroundColor: FacebookColors.primary,
        foregroundColor: FacebookColors.textOnPrimary,
        elevation: 0,
        toolbarHeight: FacebookSizes.navBarHeight,
        titleTextStyle: FacebookTextStyles.headline6.copyWith(
          color: FacebookColors.textOnPrimary,
        ),
        centerTitle: false,
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        color: FacebookColors.surface,
        elevation: FacebookSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          side: const BorderSide(color: FacebookColors.border, width: 1),
        ),
        margin: FacebookSizes.marginVertical,
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FacebookColors.primary,
          foregroundColor: FacebookColors.textOnPrimary,
          elevation: 0,
          minimumSize: Size(0, FacebookSizes.buttonHeightMedium),
          padding: FacebookSizes.paddingHorizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
          ),
          textStyle: FacebookTextStyles.buttonMedium,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FacebookColors.primary,
          minimumSize: Size(0, FacebookSizes.buttonHeightMedium),
          padding: FacebookSizes.paddingHorizontal,
          side: const BorderSide(color: FacebookColors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
          ),
          textStyle: FacebookTextStyles.buttonMedium.copyWith(
            color: FacebookColors.primary,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FacebookColors.primary,
          minimumSize: Size(0, FacebookSizes.buttonHeightMedium),
          padding: FacebookSizes.paddingHorizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
          ),
          textStyle: FacebookTextStyles.buttonMedium.copyWith(
            color: FacebookColors.primary,
          ),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FacebookColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
          borderSide: const BorderSide(
            color: FacebookColors.inputBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
          borderSide: const BorderSide(
            color: FacebookColors.inputBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
          borderSide: const BorderSide(color: FacebookColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
          borderSide: const BorderSide(color: FacebookColors.error, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: FacebookSizes.spacing16,
          vertical: FacebookSizes.spacing12,
        ),
        hintStyle: FacebookTextStyles.placeholder,
        labelStyle: FacebookTextStyles.bodyMedium,
      ),

      // 列表主题
      listTileTheme: ListTileThemeData(
        contentPadding: FacebookSizes.paddingHorizontal,
        minVerticalPadding: FacebookSizes.spacing8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        ),
        titleTextStyle: FacebookTextStyles.bodyLarge,
        subtitleTextStyle: FacebookTextStyles.bodySmall,
      ),

      // 分割线主题
      dividerTheme: DividerThemeData(
        color: FacebookColors.divider,
        thickness: FacebookSizes.dividerThickness,
        space: FacebookSizes.spacing16,
      ),

      // 图标主题
      iconTheme: IconThemeData(
        color: FacebookColors.iconGray,
        size: FacebookSizes.iconMedium,
      ),

      // Scaffold主题
      scaffoldBackgroundColor: FacebookColors.background,

      // BottomNavigationBar主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: FacebookColors.surface,
        selectedItemColor: FacebookColors.primary,
        unselectedItemColor: FacebookColors.iconGray,
        type: BottomNavigationBarType.fixed,
        elevation: FacebookSizes.cardElevation,
        selectedLabelStyle: FacebookTextStyles.caption.copyWith(
          color: FacebookColors.primary,
        ),
        unselectedLabelStyle: FacebookTextStyles.caption,
      ),

      // FloatingActionButton主题
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: FacebookColors.primary,
        foregroundColor: FacebookColors.textOnPrimary,
        elevation: FacebookSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.fabSize / 2),
        ),
      ),

      // Chip主题
      chipTheme: ChipThemeData(
        backgroundColor: FacebookColors.inputBackground,
        disabledColor: FacebookColors.textDisabled,
        selectedColor: FacebookColors.primary.withValues(alpha: 0.1),
        secondarySelectedColor: FacebookColors.primary,
        labelStyle: FacebookTextStyles.bodySmall,
        secondaryLabelStyle: FacebookTextStyles.bodySmall.copyWith(
          color: FacebookColors.primary,
        ),
        brightness: Brightness.light,
        padding: EdgeInsets.symmetric(
          horizontal: FacebookSizes.spacing8,
          vertical: FacebookSizes.spacing4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
        ),
      ),

      // Dialog主题
      dialogTheme: const DialogThemeData(
        backgroundColor: FacebookColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: FacebookColors.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: FacebookColors.textPrimary,
        ),
      ),

      // SnackBar主题
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FacebookColors.textPrimary,
        contentTextStyle: FacebookTextStyles.bodyMedium.copyWith(
          color: FacebookColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // TabBar主题
      tabBarTheme: const TabBarThemeData(
        labelColor: FacebookColors.primary,
        unselectedLabelColor: FacebookColors.textSecondary,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 14),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: FacebookColors.primary, width: 2),
        ),
      ),

      // Switch主题
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FacebookColors.primary;
          }
          return FacebookColors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FacebookColors.primary.withValues(alpha: 0.3);
          }
          return FacebookColors.inputBackground;
        }),
      ),

      // Checkbox主题
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FacebookColors.primary;
          }
          return FacebookColors.surface;
        }),
        checkColor: WidgetStateProperty.all(FacebookColors.textOnPrimary),
        side: const BorderSide(color: FacebookColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusSmall),
        ),
      ),

      // Radio主题
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FacebookColors.primary;
          }
          return FacebookColors.textDisabled;
        }),
      ),
    );
  }

  /// 获取暗色主题
  static ThemeData getDarkTheme() {
    final lightTheme = getLightTheme();
    final darkColorScheme = FacebookColors.getColorScheme(isDark: true);

    return lightTheme.copyWith(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: const Color(0xFF18191A),
      cardTheme: lightTheme.cardTheme.copyWith(color: const Color(0xFF242526)),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF242526),
      ),
    );
  }

  /// 获取当前主题是否为暗色
  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 获取适应性颜色（根据当前主题）
  static Color getAdaptiveColor(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDarkTheme(context) ? darkColor : lightColor;
  }
}
