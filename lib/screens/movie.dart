import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/screens/tags.dart';

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
  Future<Map> futureMovie;
  List<Widget> tags;

  @override
  void initState() {
    super.initState();
    MovieFetcher instance = MovieFetcher(id_movie: id_movie);
    futureMovie = instance.fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: FutureBuilder(
          future: futureMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map movie_list = snapshot.data ?? {};
              tags = [
                Tags('rating', movie_list['rating']),
                Tags('age', movie_list['age_restriction'])
              ];
              //TODO remove last comma of genres
              String genres = movie_list['genre'] != null
                  ? movie_list['genre']
                  : movie_list['genres'].fold(
                      '', (sum, element) => sum + element['title'] + ',\n');
              List detailsValue = [
                movie_list['name_origin'],
                movie_list['production'],
                movie_list['director'],
                movie_list['duration'],
                genres,
                movie_list['premiere_kaz'],
              ];
              List detailsKey = [
                'Оригинальное название:',
                'Производство:',
                'Режиссер:',
                'Продолжительность:',
                'Жанр:',
                'Премьера:',
              ];
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
                                children: tags,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 13,
                                      right:
                                          12), //TODO hardcoded width of title
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
                                          movie_list['name_rus'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25),
                                        ),
                                      ))),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Card(
                                elevation: 10,
                                child: ListView.builder(
                                  //TODO change widget to scrollable one or/and make it collapsable
                                  shrinkWrap: true,
                                  itemCount: detailsKey.length,
                                  itemBuilder: (context, index) {
                                    return ListView(
                                      shrinkWrap:
                                          true, //TODO scrolling each item (fix it)
                                      children: [
                                        Row(
                                          //TODO if overflowed go to newline
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(detailsKey[index]),
                                            Text(detailsValue[index]),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                ))),
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
