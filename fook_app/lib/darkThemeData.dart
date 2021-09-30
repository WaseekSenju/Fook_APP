import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        
        dividerColor: isDarkTheme ? Color(0xff353D4F) : Color(0xffE4E7F0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor:
              isDarkTheme ? Color(0xffA7B2CD) : Color(0xff636A7D),
          selectedItemColor: Color(
            0xFfE02C87,
          ),
          backgroundColor: isDarkTheme ? Color(0xff262B3B) : Colors.white,
        ),
        primarySwatch: createMaterialColor(
          Color(
            0xFfE02C87,
          ),
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: isDarkTheme ? Color(0xffF4F6FA) : Color(0xff222735),
          ),
          headline2: TextStyle(
            color: Colors.grey,
          ),
          headline3: TextStyle(
            color: Color(0xff636A7D),
          ),
          headline4: TextStyle(
            color: isDarkTheme ? Color(0xffA7B2CD) : Color(0xff636A7D),
          ),
          bodyText1: TextStyle(
            color: Color(0xFFF1833D),
          ),
          bodyText2: TextStyle(color: Colors.white),
        ),
        primaryColor: createMaterialColor(
          Color(
            0xFfE02C87,
          ),
        ),
        backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
        indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
            ),
          ),
        ),
        hintColor: isDarkTheme ? Color(0xff6C748B) : Color(0xffA7B2CD),
        highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
        hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
        focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        cardColor: isDarkTheme ? Color(0xFF353D4F) : Colors.white,
        canvasColor: isDarkTheme ? Color(0xff222735) : Color(0xffF4F6FA),
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme ? Color(0xff262B3B) : Colors.white,
          elevation: 0.0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          secondary: Color(0xffA7B2CD),
        ));
  }
}

