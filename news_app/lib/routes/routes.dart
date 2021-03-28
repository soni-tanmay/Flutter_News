import 'package:flutter/material.dart';
import 'package:news_app/routes/route_names.dart';
import 'package:news_app/screens/news/news_screen.dart';

class SetupRoutes {
  // Set initial route here
  static String initialRoute = Routes.NEWS_SCREEN;

  /// Add entry for new route here
  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.NEWS_SCREEN: (context) => NewsScreen(),
    };
  }

  static Future push(BuildContext context, String value,
      {Object arguments, Function callbackAfterNavigation}) {
    return Navigator.of(context)
        .pushNamed(value, arguments: arguments)
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }

  static replace(BuildContext context, String value,
      {dynamic arguments, Function callbackAfterNavigation}) {
    Navigator.of(context)
        .pushReplacementNamed(value, arguments: arguments)
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }

  static pushAndRemoveAll(BuildContext context, String value,
      {dynamic arguments, Function callbackAfterNavigation}) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(
      value,
      (_) => false,
      arguments: arguments,
    )
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }
}
