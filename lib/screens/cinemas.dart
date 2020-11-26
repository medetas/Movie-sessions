import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_list/screens/movies.dart';
import 'package:movie_list/screens/cities.dart';
import 'package:movie_list/util/fetchCities.dart';

class Cinemas extends StatefulWidget {
  // Cinemas({Key key}) : super(key: key);
  int id;
  Future<List> futureCinemas;
  Future<Map> futureCities;
  Cinemas(this.id, this.futureCinemas, this.futureCities);
  @override
  _CinemasState createState() => _CinemasState(id, futureCinemas, futureCities);
}

class _CinemasState extends State<Cinemas> {
  // List<Fetcher> locations = [
  //   Fetcher(id: 2),
  // ];
  int id_cinema;
  Future<List> futureCinemas;
  Future<Map> futureCities;
  _CinemasState(this.id_cinema, this.futureCinemas, this.futureCities);

  // List cinemas_list;

  // @override
  // void initState() {
  //   super.initState();
  //   Fetcher instance = Fetcher(id_cinema: id_cinema);
  //   futureCinemas = instance.fetchCinemas();
  //   // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');
  //   // print(cinemas_list.length);
  //   // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');
  // }

  // void updateTime(index) async {
  //   Fetcher instance = locations[index];
  //   await instance.fetchAlbum();
  //   Navigator.pop(context, {
  //     'cinemas': instance.cinemas,
  //   });
  // }

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
                        title: Text(cinema),
                        leading: Image(
                          image: cinemas_list[index]['small_poster'] != ''
                              ? NetworkImage(
                                  cinemas_list[index]['small_poster'])
                              : AssetImage('assets/poster_v.jpg'),
                        ),
                        subtitle: Text(cinemas_list[index]['address']),
                        onTap: () {
                          // print(cinemas_list[index]['id']);
                          // dynamic result = Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           Movies(cinemas_list[index]['id']),
                          //     ));
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
