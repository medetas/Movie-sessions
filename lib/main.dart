import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_list/screens/mainMovies.dart';
import 'package:movie_list/screens/cinemas.dart';
import 'package:movie_list/screens/cities.dart';
import 'package:movie_list/stylize/stylize.dart';
import 'package:movie_list/util/fetchHome.dart';
import 'package:movie_list/util/fetchCities.dart';

//TODO  CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate(handshake.cc:354))
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//TODO check if wait time of connection to net is too long
void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Variables to stylize
  int selectedIndex = 0;
  double fontSize = 16;

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

    HomeFetcher instance2 = HomeFetcher(id_city: 2);
    futureSoon = instance2.fetchSoon(); //fetching soon movies
    futureTodays = instance2.fetchTodays(); //fetching todays movies

    Fetcher instance = Fetcher(id_cinema: 2);
    futureCinemas =
        instance.fetchCinemas(); //fetching cinemas list of selected city
    futureCities = instance.fetchCities(); // fetching cities list

    widgets = [
      MainMovies(futureSoon, futureTodays), // screen of soon and todays movies
      Cinemas(2, futureCinemas, futureCities) // screen of cinemas list
    ];
    titles = ['Фильмы', 'Кинотеатры'];
  }

  // On screen change
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Update on city selected
  void onBack(result) {
    setState(() {
      if (result != null) {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StylizeColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: StylizeColor.backgroundColor,
        title: Text(titles[selectedIndex]),
        actions: [
          //Selected city label
          Container(
            alignment: Alignment.center,
            child: Text(
              labelCity,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.location_on,
                color: StylizeColor.selectedTextColor,
              ),
              tooltip: 'Выбрать город',
              onPressed: () async {
                // On icon pressed => screen of cities list => select city and go back
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cities(futureCities),
                    )).then((result) => onBack(result));
              })
        ],
      ),
      body: widgets[selectedIndex], // Screens of movies and cinemas
      //Bottom tabbar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: StylizeColor.backgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Фильмы'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Кинотеатры'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: StylizeColor.selectedTextColor,
        unselectedItemColor: StylizeColor.textColor,
        onTap: onItemTapped,
      ),
    );
  }
}
