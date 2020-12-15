import 'package:flutter/material.dart';
import 'package:movie_list/screens/SoonToday.dart';

class MainMovies extends StatefulWidget {
  // get data from main.dart
  Future<List> futureSoon, futureTodays;
  MainMovies(this.futureSoon, this.futureTodays);

  @override
  _MainMoviesState createState() => _MainMoviesState(futureSoon, futureTodays);
}

class _MainMoviesState extends State<MainMovies> {
  Future<List> futureSoon, futureTodays;
  _MainMoviesState(this.futureSoon, this.futureTodays);

  List<Widget> widgets;
  @override
  void initState() {
    super.initState();

    widgets = [
      SoonToday('Скоро в кино', futureSoon),
      Divider(
        height: 20,
      ),
      SoonToday('Сегодня в кино', futureTodays)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      //display soon and todays movies
      children: widgets,
    );
  }
}
