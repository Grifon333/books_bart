import 'package:flutter/material.dart';

const color1 = Color(0xFF7E675E);
const color2 = Color(0xFFF5EEE5);

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
    elevatedButtonTheme: _elevatedButtonTheme,
  );

  static const _colorScheme = ColorScheme.light(
    primary: color1,
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
      iconColor: MaterialStatePropertyAll(color2),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: color2,
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
      side: MaterialStatePropertyAll(BorderSide(color: color1)),
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
    titleTextStyle: TextStyle(
      fontSize: 24,
      color: color1,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(
      color: color1,
    ),
  );

  static const _iconTheme = IconThemeData(
    color: color1,
  );

  static const _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontSize: 16,
          color: color1,
        ),
      ),
    ),
  );

  static const _iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(color1),
    ),
  );

  static const _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(0, 50)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      backgroundColor: MaterialStatePropertyAll(color1),
      padding: MaterialStatePropertyAll(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}

/* disabledColor, focusColor, scaffoldBackgroundColor, fontFamily, textTheme,
actionIconTheme, bottomNavigationBarTheme, cardTheme, checkboxTheme, dialogTheme,
dropdownMenuTheme, listTileTheme, progressIndicatorTheme,
*/
