import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/constants/color_constant.dart';

@immutable
class AppTheme {
  const AppTheme(this.context);

  final BuildContext context;
  ThemeData get theme => ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        cardTheme: CardTheme(
          color: ColorConstant.white,
          elevation: 3,
          margin: context.padding.low,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorConstant.lightGreenAccent,
          elevation: 12,
          // shape: CircleBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(
              Size.fromWidth(context.sized.width / 2.5),
            ),
            backgroundColor:
                WidgetStateProperty.all<Color>(ColorConstant.lightBlueAccent),
            foregroundColor:
                WidgetStateProperty.all<Color>(ColorConstant.white),
            elevation: WidgetStateProperty.all<double>(12),
            padding: WidgetStateProperty.all<EdgeInsets>(
              context.padding.low,
            ),
            textStyle: WidgetStateProperty.all<TextStyle?>(
              context.general.textTheme.bodyLarge,
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(elevation: 12),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 12,
          type: BottomNavigationBarType.shifting,
          backgroundColor: ColorConstant.greyShade300,
          selectedItemColor: ColorConstant.selectedItemColor,
          unselectedItemColor: ColorConstant.unselectedItemColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        ),
        scaffoldBackgroundColor: ColorConstant.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConstant.white,
        ),
      );
}
