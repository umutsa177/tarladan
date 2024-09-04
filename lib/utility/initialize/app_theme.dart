import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/enums/double_constant.dart';

@immutable
class AppTheme {
  const AppTheme(this.context);

  final BuildContext context;
  ThemeData get theme => ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        cardTheme: CardTheme(
          color: ColorConstant.white,
          elevation: DoubleConstant.twelve.value / 4,
          margin: context.padding.low / 2,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ColorConstant.lightGreenAccent,
          elevation: DoubleConstant.twelve.value,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(
              Size.fromWidth(context.sized.width / 2.5),
            ),
            backgroundColor:
                WidgetStateProperty.all<Color>(ColorConstant.green),
            foregroundColor:
                WidgetStateProperty.all<Color>(ColorConstant.white),
            elevation:
                WidgetStateProperty.all<double>(DoubleConstant.twelve.value),
            padding: WidgetStateProperty.all<EdgeInsets>(
              context.padding.low,
            ),
            textStyle: WidgetStateProperty.all<TextStyle?>(
              context.general.textTheme.bodyLarge,
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          elevation: DoubleConstant.twelve.value,
          contentTextStyle: const TextStyle(color: ColorConstant.white),
          backgroundColor: ColorConstant.green,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: DoubleConstant.twelve.value,
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
          centerTitle: true,
        ),
        cardColor: ColorConstant.greyShade200,
        chipTheme: const ChipThemeData(
          side: BorderSide(style: BorderStyle.none),
        ),
      );
}
