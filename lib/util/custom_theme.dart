import 'package:flutter/material.dart';

import '../util/view_const.dart';

ThemeData themeData = ThemeData(
//        brightness: Brightness.dark,
  primaryColor: Colors.black,
//  accentColor: Colors.black,
  indicatorColor: Colors.cyan[600],
  bottomAppBarColor: Colors.orange,
  backgroundColor: Colors.blue,
  // メニューのDrawerHeader以外の背景色
  canvasColor: Colors.grey[200],
  // 画面の背景色（未設定ならcanvasColorの色が使用される）
  scaffoldBackgroundColor: Colors.grey[100],
  //Colors.lime[50],
  toggleableActiveColor: Colors.pink[400],
  cardColor: Colors.white,
  hoverColor: Colors.blue[400],
  primaryTextTheme: TextTheme(
      headline: TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  ).merge(ViewConst.font_size_18)),
  accentTextTheme: TextTheme(
      headline: TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  ).merge(ViewConst.font_size_18)),
  textTheme: TextTheme(
    headline: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ).merge(ViewConst.font_size_18),
    body2: TextStyle(color: Colors.grey, height: 1)
        .merge(ViewConst.font_normal)
        .merge(ViewConst.font_size_15),
    body1: TextStyle(
      color: Colors.black54,
    ).merge(ViewConst.font_normal).merge(ViewConst.font_size_15),
    button: TextStyle(
      color: Colors.orange,
    ).merge(ViewConst.font_medium).merge(ViewConst.font_size_18),
//          title: TextStyle(
//            color: Colors.teal,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_17),
//          subtitle: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          display4: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          display3: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          display2: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          display1: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          subhead: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          caption: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
//          overline: TextStyle(
//            color: Colors.amberAccent,
//          ).merge(ViewConst.font_medium).merge(ViewConst.font_size_16),
  ),
);
