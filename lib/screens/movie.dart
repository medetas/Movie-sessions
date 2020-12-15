import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_list/screens/sessions.dart';
import 'package:movie_list/screens/tags.dart';
import 'package:movie_list/stylize/stylize.dart';
import 'package:movie_list/util/fetchCinema.dart';
import 'package:movie_list/util/fetchMovie.dart';

class Movie extends StatefulWidget {
  String movieOrCinema;
  int id_movieOrCinema;
  Movie(this.movieOrCinema, this.id_movieOrCinema);

  @override
  _MovieState createState() => _MovieState(movieOrCinema, id_movieOrCinema);
}

class _MovieState extends State<Movie> {
  String movieOrCinema;
  int id_movieOrCinema;
  _MovieState(this.movieOrCinema, this.id_movieOrCinema);
  Future<Map> futureMovieOrCinema;
  Future<List> futureSessions;

  @override
  void initState() {
    super.initState();
    if (movieOrCinema == 'movie') {
      MovieFetcher instance = MovieFetcher(id_movie: id_movieOrCinema);
      futureMovieOrCinema = instance.fetchMovie();
      futureSessions = instance.fetchSessions();
    } else {
      CinemaFetcher instance = CinemaFetcher(id_cinema: id_movieOrCinema);
      futureSessions = instance.fetchSessions();
      futureMovieOrCinema = instance.fetchCinema();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: StylizeColor.backgroundColor,
        body: FutureBuilder(
          future: futureMovieOrCinema,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map movie_list = snapshot.data ?? {};

              return InfoScreen(movieOrCinema, movie_list, futureSessions);
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

class InfoScreen extends StatefulWidget {
  String movieOrCinema;
  Map movie_list;
  Future<List> futureSessions;
  InfoScreen(this.movieOrCinema, this.movie_list, this.futureSessions);
  @override
  _InfoScreenState createState() =>
      _InfoScreenState(movieOrCinema, movie_list, futureSessions);
}

class _InfoScreenState extends State<InfoScreen> {
  String movieOrCinema;
  Map info_list;
  Future<List> futureSessions;
  _InfoScreenState(this.movieOrCinema, this.info_list, this.futureSessions);
  List<Widget> tags;
  List detailsKey, detailsValue;
  List<Widget> infoAndSessions;
  Image poster;
  RegExp re = new RegExp(r"(<([^>]+)>)");
  String title;
  List<String> tabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (movieOrCinema == 'movie') {
      title = info_list['name_rus'];
      //TODO check if null
      poster = info_list['posters']['p1192x597'] != ''
          ? Image.network(
              info_list['posters']['p1192x597'],
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/poster_h.jpg',
              fit: BoxFit.cover,
            );
      tabs = ["По времени", "По кинотеатрам"];

      tags = [
        Tags('rating', info_list['rating']),
        Tags('age', info_list['age_restriction'])
      ];
      //TODO remove last comma of genres, check if data is not null for all detailsValue, check also if genres is not null
      String genres = info_list['genre'] ??
          info_list['genres'].fold('', (sum, element) {
            String separator = ', ';
            if (element == info_list['genres'].last) {
              separator = '';
            }
            return sum + element['title'] + separator;
          }) ??
          '-';

      detailsValue = [
        info_list['name_origin'] != '' && info_list['name_origin'] != null
            ? info_list['name_origin']
            : '-',
        info_list['production'] != '' && info_list['production'] != null
            ? info_list['production']
            : '-',
        info_list['director'] != '' && info_list['director'] != null
            ? info_list['director']
            : '-',
        info_list['duration'] != '' && info_list['duration'] != null
            ? info_list['duration']
            : '-',
        genres,
        info_list['premiere_kaz'] != '' && info_list['premiere_kaz'] != null
            ? DateFormat('dd.MM.yyyy')
                .format(DateTime.parse(info_list['premiere_kaz']))
            : '-',
        info_list['actors'] != '' && info_list['actors'] != null
            ? info_list['actors']
            : '-',
        info_list['description'] != '' && info_list['description'] != null
            ? info_list['description'].replaceAll(re, "")
            : '-',
      ];
      detailsKey = [
        'Оригинальное название:',
        'Производство:',
        'Режиссер:',
        'Продолжительность:',
        'Жанр:',
        'Премьера:',
        'Актеры:',
        'Описание:',
      ];
      infoAndSessions = [
        MovieInfo(detailsKey, detailsValue),
        SessionInfo(tabs, futureSessions),
      ];
    } else {
      RegExp reLi = new RegExp(r"(<([li>]+)>)");

      String cinemaInfo;
      title = info_list['name'];
      cinemaInfo = info_list['description'];
      cinemaInfo = cinemaInfo.replaceAll(reLi, " • ");
      cinemaInfo = cinemaInfo.replaceAll(re, "");

      poster = info_list['big_poster'] != ''
          ? Image.network(
              info_list['big_poster'],
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/poster_h.jpg',
              fit: BoxFit.cover,
            );

      tabs = ["По фильмам", "По залам"];

      infoAndSessions = [
        MovieInfo([''], [cinemaInfo]),
        SessionInfo(tabs, futureSessions),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: StylizeColor.backgroundColor,
            stretch: true,
            onStretchTrigger: () {
              return;
            },
            expandedHeight: 295,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 0),
              title: AppBarBox(tags, title, movieOrCinema),
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
                          Color.fromRGBO(22, 22, 32, 1),
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
            delegate: SliverChildListDelegate(infoAndSessions),
          ),
        ]);
  }
}

class AppBarBox extends StatelessWidget {
  List<Widget> tags;
  String title, movieOrCinema;
  AppBarBox(this.tags, this.title, this.movieOrCinema);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          movieOrCinema == 'movie'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: tags,
                )
              : Container(),
          Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width /
                      28), //TODO hardcoded width of title, width changing when swipped up
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
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: StylizeColor.textColor,
                          fontSize: MediaQuery.of(context).size.width / 28),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))),
        ],
      ),
    );
  }
}

class MovieInfo extends StatelessWidget {
  List detailsKey, detailsValue;
  MovieInfo(this.detailsKey, this.detailsValue);
  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -5, 0),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: detailsKey == ['']
                  ? Container(
                      transform: Matrix4.translationValues(0, -5, 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Card(
                          elevation: 10,
                          child: Flexible(
                            child: Text(detailsValue[0]),
                          )))
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      //TODO change widget to scrollable one or/and make it collapsable
                      shrinkWrap: true,
                      itemCount: detailsKey.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            detailsKey[index],
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            detailsValue[index],
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    ))),
    );
  }
}

class SessionInfo extends StatefulWidget {
  List<String> tabs;
  Future<List> futureSessions;
  SessionInfo(this.tabs, this.futureSessions);

  @override
  _SessionInfoState createState() => _SessionInfoState(tabs, futureSessions);
}

class _SessionInfoState extends State<SessionInfo>
    with SingleTickerProviderStateMixin {
  List<String> tabs;
  Future<List> futureSessions;
  _SessionInfoState(this.tabs, this.futureSessions);

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: tabs[0]),
            Tab(text: tabs[1]),
          ],
          labelPadding: EdgeInsets.symmetric(horizontal: 0),
          indicatorColor: StylizeColor.selectedTextColor,
          indicatorWeight: 4,
          labelColor: StylizeColor.selectedTextColor,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedLabelColor: StylizeColor.textColor,
          unselectedLabelStyle: TextStyle(fontSize: 14),
        ),

        Container(
          child: ListTile(
              leading: Container(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  'Время',
                  style: TextStyle(color: StylizeColor.textColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              title: Container(
                margin: EdgeInsets.only(left: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Язык',
                        style: TextStyle(color: StylizeColor.textColor)),
                    Text('Дет.',
                        style: TextStyle(color: StylizeColor.textColor)),
                    Text('Студ.',
                        style: TextStyle(color: StylizeColor.textColor)),
                    Text('Взр.',
                        style: TextStyle(color: StylizeColor.textColor)),
                    Text('VIP',
                        style: TextStyle(color: StylizeColor.textColor)),
                  ],
                ),
              )),
        ),
        //TODO pass through not futureSessions (result), try another solution of fitting to container
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          child: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Sessions(tabs[0], futureSessions)),
            Container(child: Sessions(tabs[1], futureSessions)),
          ][_tabController.index],
        )
      ],
    );
  }
}
