import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_list/screens/SoonToday.dart';

import 'package:movie_list/screens/movie.dart';
import 'package:movie_list/screens/cities.dart';
import 'package:movie_list/util/fetchHome.dart';

class MainMovies extends StatefulWidget {
  Future<List> futureSoon, futureTodays;
  MainMovies(this.futureSoon, this.futureTodays);

  @override
  _MainMoviesState createState() => _MainMoviesState(futureSoon, futureTodays);
}

class _MainMoviesState extends State<MainMovies> {
  Future<List> futureSoon, futureTodays;
  _MainMoviesState(this.futureSoon, this.futureTodays);

  int selectedIndex = 0;
  Color textColor = Color(0xffE9ECE4);
  Color backgroundColor = Colors.white;
  Color cardColor = Color(0xff013766);

  Map ageList = {
    0: [Colors.yellow[600], Colors.yellow[800]],
    6: [Colors.amber[600], Colors.amber[800]],
    12: [Colors.deepOrange[400], Colors.deepOrange[800]],
    18: [Colors.red[600], Colors.red[900]],
  };

  List<Widget> widgets;
  @override
  void initState() {
    super.initState();

    widgets = [SoonToday(futureSoon), SoonToday(futureTodays)];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widgets,
    );
  }
}
