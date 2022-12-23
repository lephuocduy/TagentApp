import 'package:flutter/material.dart';

import '../constants/app_color.dart';

ThemeData getConfigTheme() {
  return ThemeData(
    fontFamily: 'Roboto',
    primaryColor: AppColor.primary,
    splashColor: AppColor.primary,
    cardTheme: CardTheme(
      color: AppColor.white,
      shadowColor: AppColor.grey,
      elevation: 4,
    ),
  );
}
