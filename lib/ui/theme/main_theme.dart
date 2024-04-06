import 'package:flutter/material.dart';

class MainTheme {
  final themeData = ThemeData(
    colorScheme: _colorScheme,
    useMaterial3: true,
    filledButtonTheme: _filledButtonTheme,
    outlinedButtonTheme: _outlineButtonTheme,
    dividerTheme: _dividerTheme,
    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: _appBarTheme,
    iconTheme: _iconTheme,
    textButtonTheme: _textButtonTheme,
    iconButtonTheme: _iconButtonTheme,
  );

  static const _colorScheme = ColorScheme.light(
    primary: Color(0xFF7E675E),
  );

  static const _filledButtonTheme = FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(0, 50)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      padding: MaterialStatePropertyAll(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      iconColor: MaterialStatePropertyAll(Color(0xFFF5EEE5)),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: Color(0xFFF5EEE5),
          fontSize: 16,
        ),
      ),
    ),
  );

  static const _outlineButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(0, 50)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      side: MaterialStatePropertyAll(BorderSide(color: Color(0xFF7E675E))),
      // textStyle: MaterialStatePropertyAll(
      //   TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight.w600,
      //   ),
      // ),
    ),
  );

  static const _dividerTheme = DividerThemeData(
    color: Colors.black54,
    thickness: 0.5,
    space: 0,
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    isCollapsed: true,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );

  static const _appBarTheme = AppBarTheme(
    iconTheme: IconThemeData(
      color: Color(0xFF7E675E),
    ),
  );

  static const _iconTheme = IconThemeData(
    color: Color(0xFF7E675E),
  );

  static const _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontSize: 16,
          color: Color(0xFF7E675E),
        ),
      ),
    ),
  );

  static const _iconButtonTheme = IconButtonThemeData(
      style: ButtonStyle(
    iconColor: MaterialStatePropertyAll(Color(0xFF7E675E)),
  ));
}

/* disabledColor, focusColor, scaffoldBackgroundColor, fontFamily, textTheme,
actionIconTheme, appBarTheme, bottomNavigationBarTheme, cardTheme, checkboxTheme,
dialogTheme, dropdownMenuTheme, iconButtonTheme, listTileTheme, progressIndicatorTheme,
*/
