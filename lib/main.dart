import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_list/screens/mainMovies.dart';
import 'package:movie_list/screens/movie.dart';
import 'package:movie_list/screens/cinemas.dart';
import 'package:movie_list/screens/cities.dart';
import 'package:movie_list/util/fetchHome.dart';
import 'package:movie_list/util/fetchCities.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  // MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  Color textColor = Color(0xffE9ECE4);
  Color backgroundColor = Colors.white;

  Future<List> futureCinemas;
  Future<List> futureSoon;
  Future<List> futureTodays;
  Future<Map> futureCities;

  List<Widget> widgets;
  List<String> titles;

  String labelCity = 'Алматы';
  @override
  void initState() {
    super.initState();

    HomeFetcher instance2 = HomeFetcher(id_city: 3);
    futureSoon = instance2.fetchSoon();
    futureTodays = instance2.fetchTodays();

    Fetcher instance = Fetcher(id_cinema: 2);
    futureCinemas = instance.fetchCinemas();
    futureCities = instance.fetchCities();
    // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');
    // print(cinemas_list.length);
    // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');

    widgets = [
      MainMovies(futureSoon, futureTodays),
      Cinemas(2, futureCinemas, futureCities)
    ];
    titles = ['Фильмы', 'Кинотеатры'];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onBack(result) {
    setState(() {
      labelCity = result[1];
      Fetcher instance = Fetcher(id_cinema: result[0]);
      futureCinemas = instance.fetchCinemas();

      HomeFetcher instance2 = HomeFetcher(id_city: result[0]);
      futureSoon = instance2.fetchSoon();
      futureTodays = instance2.fetchTodays();

      widgets = [
        MainMovies(futureSoon, futureTodays),
        Cinemas(result[0], futureCinemas, futureCities)
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        actions: [
          Text(
            labelCity,
            textAlign: TextAlign.center,
          ),
          IconButton(
              icon: Icon(Icons.location_on),
              tooltip: 'Выбрать город',
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cities(futureCities),
                    )).then((result) => onBack(result));
              })
        ],
      ),
      body: widgets[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Фильмы'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Кинотеатры'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: onItemTapped,
      ),
    );
  }
}
