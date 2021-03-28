import 'package:flutter/material.dart';

class SizeConfig {
  SizeConfig._();

  static final SizeConfig _instance = SizeConfig._();

  factory SizeConfig() => _instance;
  MediaQueryData _mediaQueryData;
  double screenWidth;
  double screenHeight;
  double blockSizeHorizontal;
  double blockSizeVertical;

  double _safeAreaHorizontal;
  double _safeAreaVertical;
  double safeBlockHorizontal;
  double safeBlockVertical;

  double profileDrawerWidth;
  double refHeight;
  double refWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    refHeight = 896;
    refWidth = 423;

    if (screenHeight < 1200) {
      blockSizeHorizontal = screenWidth / 100;
      blockSizeVertical = screenHeight / 100;

      _safeAreaHorizontal =
          _mediaQueryData.padding.left + _mediaQueryData.padding.right;
      _safeAreaVertical =
          _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
      safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
      safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    } else {
      blockSizeHorizontal = screenWidth / 120;
      blockSizeVertical = screenHeight / 120;

      _safeAreaHorizontal =
          _mediaQueryData.padding.left + _mediaQueryData.padding.right;
      _safeAreaVertical =
          _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
      safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 120;
      safeBlockVertical = (screenHeight - _safeAreaVertical) / 120;
    }
  }

  double getWidthRatio(double val) {
    var res = (val / refWidth) * 100;
    var temp = res * blockSizeHorizontal;

    return temp;
  }

  double getHeightRatio(double val) {
    var res = (val / refHeight) * 100;
    var temp = res * blockSizeVertical;
    return temp;
  }

  double getFontRatio(double val) {
    var res = (val / refWidth) * 100;
    var temp = 0.0;
    if (screenWidth < screenHeight) {
      temp = res * safeBlockHorizontal;
    } else {
      temp = res * safeBlockVertical;
    }
    return temp;
  }
}

extension SizeUtils on num {
  double get toWidth => SizeConfig().getWidthRatio(toDouble());

  double get toHeight => SizeConfig().getHeightRatio(toDouble());

  double get toHeightClamped =>
      SizeConfig().getHeightRatio(toDouble()).clamp(toDouble(), toDouble() * 2);

  double get toFont => SizeConfig().getFontRatio(toDouble());
}
