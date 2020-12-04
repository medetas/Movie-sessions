import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_list/screens/sessions.dart';
import 'package:movie_list/screens/tags.dart';
import 'package:movie_list/util/fetchCinema.dart';

import 'package:movie_list/util/fetchMovie.dart';

class Cinema extends StatefulWidget {
  Map cinema;
  Cinema(this.cinema);

  @override
  _CinemaState createState() => _CinemaState(cinema);
}

class _CinemaState extends State<Cinema> {
  Map cinema;
  _CinemaState(this.cinema);

  RegExp reLi = new RegExp(r"(<([li>]+)>)");
  RegExp re = new RegExp(r"(<([^>]+)>)");
  String cinemaInfo;
  Image poster;
  Future<List> futureSessions;

  @override
  void initState() {
    super.initState();
    cinemaInfo = cinema['description'];
    cinemaInfo = cinemaInfo.replaceAll(reLi, " • ");
    cinemaInfo = cinemaInfo.replaceAll(re, "");

    CinemaFetcher instance = CinemaFetcher(id_cinema: cinema['id']);
    futureSessions = instance.fetchSessions();

    poster = cinema['big_poster'] != ''
        ? Image.network(
            cinema['big_poster'],
            fit: BoxFit.cover,
          )
        : Image.asset(
            'assets/poster_h.jpg',
            fit: BoxFit.cover,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: <
                Widget>[
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () {
              return;
            },
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 0),
              title: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(
                            left: 13,
                            right:
                                12), //TODO hardcoded width of title, width changing when swipped up
                        width: MediaQuery.of(context).size.width,
                        transform: Matrix4.translationValues(0, 5, 0),
                        child: Card(
                            elevation: 10,
                            color: Colors.green[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                cinema['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30),
                              ),
                            ))),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  poster,
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.8),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          Color(0xee000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                  transform: Matrix4.translationValues(0, -5, 0),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Card(
                      elevation: 10,
                      child: Flexible(
                        child: Text(cinemaInfo),
                      ))),
              Container(
                  padding: EdgeInsets.all(15),
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: TabBar(tabs: [
                            Tab(text: "Time"),
                            Tab(text: "Cinema"),
                            Tab(text: "Compact"),
                          ]),
                        ),
                        Container(
                            child: ListTile(
                          leading: Text('Время'),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Язык'),
                              Text('Дет.'),
                              Text('Студ.'),
                              Text('Взр.'),
                              Text('VIP'),
                            ],
                          ),
                        )),
                        Container(
                          //Add this to give height
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView(children: [
                            Sessions('Movie', futureSessions),
                            Sessions('Hall', futureSessions),
                            Container(
                              child: Text("User Body"),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ))
            ]),
          ),
        ]));
  }
}
