import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_list/screens/movie.dart';
import 'package:movie_list/util/fetchCities.dart';

class Movies extends StatefulWidget {
  // Movies({Key key}) : super(key: key);
  int id;
  Movies(this.id);
  @override
  _MoviesState createState() => _MoviesState(id);
}

class _MoviesState extends State<Movies> {
  // List<Fetcher> locations = [
  //   Fetcher(id: 2),
  // ];
  int id_cinema;
  _MoviesState(this.id_cinema);

  Future<Map> futureList;

  // List cinemas_list;

  @override
  void initState() {
    super.initState();
    Fetcher instance = Fetcher(id_cinema: id_cinema);
    futureList = instance.fetchMovies();
    // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');
    // print(cinemas_list.length);
    // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');
  }

  // void updateTime(index) async {
  //   Fetcher instance = locations[index];
  //   await instance.fetchAlbum();
  //   Navigator.pop(context, {
  //     'cinemas': instance.cinemas,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // int id_cinema = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
        ),
        body: FutureBuilder<Map>(
            future: futureList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map movies_list = snapshot.data ?? {};
                return ListView.builder(
                    itemCount: movies_list.length,
                    itemBuilder: (context, index) {
                      String movie = movies_list.keys.elementAt(index);
                      return new ListTile(
                        title: Text(movie),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Movie(
                                    movies_list.values.elementAt(index)['id']),
                              ));
                        },

                        // leading: CircleAvatar(
                        //   backgroundImage: AssetImage(user.profilePicture),
                        // ),
                        // trailing: user.icon,
                        // title: new Text(user.name),
                        // onTap: () {
                        //   Navigator.push(context,
                        //       new MaterialPageRoute(builder: (context) => new Home()));
                        // },
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
