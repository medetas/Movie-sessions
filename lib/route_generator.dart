import 'package:flutter/material.dart';
import 'package:movie_list/main.dart';
import 'package:movie_list/screens/cities.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.arguments) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp());
      case '/cities':
        return MaterialPageRoute(builder: (_) => Cities(args));
    }
  }
}
