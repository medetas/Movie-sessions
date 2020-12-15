import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_list/screens/cinema.dart';
import 'package:movie_list/screens/movie.dart';
import 'package:movie_list/stylize/stylize.dart';
import 'package:movie_list/util/fetchCities.dart';

class Cinemas extends StatefulWidget {
  int id;
  Future<List> futureCinemas;
  Future<Map> futureCities;
  Cinemas(this.id, this.futureCinemas, this.futureCities);
  @override
  _CinemasState createState() => _CinemasState(id, futureCinemas, futureCities);
}

class _CinemasState extends State<Cinemas> {
  int id_cinema;
  Future<List> futureCinemas;
  Future<Map> futureCities;
  _CinemasState(this.id_cinema, this.futureCinemas, this.futureCities);

  String labelCity = 'Alma';
  void onBack(result) {
    setState(() {
      labelCity = result[1];
      Fetcher instance = Fetcher(id_cinema: result[0]);
      futureCinemas = instance.fetchCinemas();
    });
  }

  @override
  Widget build(BuildContext context) {
    // int id_cinema = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: StylizeColor.backgroundColor,
        body: FutureBuilder<List>(
            future: futureCinemas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List cinemas_list = snapshot.data ?? {};
                return ListView.builder(
                    itemCount: cinemas_list.length,
                    itemBuilder: (context, index) {
                      String cinema = cinemas_list[index]['name'];
                      return ListTile(
                        isThreeLine: true,
                        title: Text(
                          cinema,
                          style: TextStyle(
                              color: StylizeColor.textColor, fontSize: 18),
                        ),
                        leading: Image(
                          image: cinemas_list[index]['small_poster'] != ''
                              ? NetworkImage(
                                  cinemas_list[index]['small_poster'])
                              : AssetImage('assets/poster_v.jpg'),
                        ),
                        subtitle: Text(cinemas_list[index]['address'],
                            style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          print(cinemas_list[index]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Movie('cinema', cinemas_list[index]['id']),
                              ));
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
