import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sessions extends StatefulWidget {
  String tab;
  Future<List> futureSessions;
  Sessions(this.tab, this.futureSessions);
  @override
  _SessionsState createState() => _SessionsState(tab, futureSessions);
}

class _SessionsState extends State<Sessions> {
  String tab;
  Future<List> futureSessions;
  _SessionsState(this.tab, this.futureSessions);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: futureSessions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (listEquals(snapshot.data, ['empty'])) {
              return Text('NO SESSIONS');
            } else {
              List sessions = snapshot.data ?? [];
              if (tab == 'Cinema') {
                return ByCinema(sessions);
              } else if (tab == 'Time') {
                return ByTime(sessions);
              } else if (tab == 'Movie') {
                return ByMovie(sessions);
              } else {
                return ByHall(sessions);
              }
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ByTime extends StatelessWidget {
  List sessionsByTime;
  ByTime(this.sessionsByTime);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sessionsByTime.length,
        itemBuilder: (context, index) {
          // RegExp reg = new RegExp(r"(.+?\d)");
          // var hall = reg
          //     .firstMatch(sessionsByTime[index]['hall']['name'])
          //     .group(1);
          return ListTile(
            leading: Container(
                constraints: BoxConstraints(
                    maxWidth: 40), //TODO hardcoded time column width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(DateFormat('HH:mm').format(DateTime.parse(
                        sessionsByTime[index]['session']['session_date_tz']))),
                    Text(
                      sessionsByTime[index]['hall']['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                )),
            title: Text(sessionsByTime[index]['cinema']['name']),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(sessionsByTime[index]['session']['lang_label']),
                Text(sessionsByTime[index]['session']['child'].toString()),
                Text(sessionsByTime[index]['session']['student'].toString()),
                Text(sessionsByTime[index]['session']['adult'].toString()),
                Text(sessionsByTime[index]['session']['vip'].toString())
              ],
            ),
          );
        });
  }
}

class ByCinema extends StatelessWidget {
  //TODO change interface
  List sessions;
  ByCinema(this.sessions);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          List sessionsByCinema = List.from(sessions);
          sessionsByCinema
              .sort((a, b) => a['cinema']['id'].compareTo(b['cinema']['id']));
          return ListTile(
            leading: Container(
                constraints: BoxConstraints(
                    maxWidth: 40), //TODO hardcoded time column width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(DateFormat('HH:mm').format(DateTime.parse(
                        sessionsByCinema[index]['session']
                            ['session_date_tz']))),
                    Text(
                      sessionsByCinema[index]['hall']['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                )),
            title: Text(sessionsByCinema[index]['cinema']['name']),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(sessionsByCinema[index]['session']['lang_label']),
                Text(sessionsByCinema[index]['session']['child'].toString()),
                Text(sessionsByCinema[index]['session']['student'].toString()),
                Text(sessionsByCinema[index]['session']['adult'].toString()),
                Text(sessionsByCinema[index]['session']['vip'].toString())
              ],
            ),
          );
        });
  }
}

class ByMovie extends StatelessWidget {
  //TODO change interface
  List sessionsByMovie;
  ByMovie(this.sessionsByMovie);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: sessionsByMovie.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(sessionsByMovie[index]['movie']['name_rus']),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: sessionsByMovie[index]['items'].length,
                  itemBuilder: (context2, index2) {
                    return ListTile(
                        leading: Container(
                            constraints: BoxConstraints(maxWidth: 40),
                            child: Column(
                              children: [
                                Text(DateFormat('HH:mm').format(DateTime.parse(
                                    sessionsByMovie[index]['items'][index2]
                                        ['session']['session_date_tz']))),
                                Text(
                                  sessionsByMovie[index]['items'][index2]
                                      ['hall']['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )
                              ],
                            )),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(sessionsByMovie[index]['items'][index2]
                                ['session']['lang_label']),
                            Text(sessionsByMovie[index]['items'][index2]
                                    ['session']['child']
                                .toString()),
                            Text(sessionsByMovie[index]['items'][index2]
                                    ['session']['student']
                                .toString()),
                            Text(sessionsByMovie[index]['items'][index2]
                                    ['session']['adult']
                                .toString()),
                            Text(sessionsByMovie[index]['items'][index2]
                                    ['session']['vip']
                                .toString())
                          ],
                        ));
                  })
            ],
          );
        });
  }
}

class ByHall extends StatelessWidget {
  //TODO change interface
  List sessionsByHall;
  ByHall(this.sessionsByHall);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sessionsByHall.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
                constraints: BoxConstraints(
                    maxWidth: 40), //TODO hardcoded time column width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(DateFormat('HH:mm').format(DateTime.parse(
                        sessionsByHall[index]['session']['session_date_tz']))),
                    Text(
                      sessionsByHall[index]['hall']['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                )),
            title: Text(sessionsByHall[index]['cinema']['name']),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(sessionsByHall[index]['session']['lang_label']),
                Text(sessionsByHall[index]['session']['child'].toString()),
                Text(sessionsByHall[index]['session']['student'].toString()),
                Text(sessionsByHall[index]['session']['adult'].toString()),
                Text(sessionsByHall[index]['session']['vip'].toString())
              ],
            ),
          );
        });
  }
}
