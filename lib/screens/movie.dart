import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:movie_list/util/fetchMovie.dart';

class Movie extends StatefulWidget {
  int id_movie;
  Movie(this.id_movie);

  @override
  _MovieState createState() => _MovieState(id_movie);
}

class _MovieState extends State<Movie> {
  int id_movie;
  _MovieState(this.id_movie);
  Future<Map> futureList;

  @override
  void initState() {
    super.initState();
    MovieFetcher instance = MovieFetcher(id_movie: id_movie);
    futureList = instance.fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: FutureBuilder(
          future: futureList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map movie_list = snapshot.data ?? {};
              return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      movie_list['rating'] != null
                                          ? (movie_list['rating'])
                                              .toStringAsFixed(1)
                                          : '-',
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                ),
                                child: Text(
                                  movie_list['name_rus'],
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              movie_list['posters']['p1192x597'],
                              fit: BoxFit.cover,
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.5),
                                  end: Alignment(0.0, 0.0),
                                  colors: <Color>[
                                    Color(0x60000000),
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
                          child: Card(
                            elevation: 10,
                            child: Text(movie_list['description']),
                          ),
                        ),
                      ]),
                    ),
                  ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
