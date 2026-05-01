import 'package:flutter/material.dart';

class AppLocales {
  const AppLocales._();

  static const String ar = 'ar';
  static const String en = 'en';

  static const List<Locale> supportedLocales = [
    Locale(ar),
    Locale(en),
  ];
}
