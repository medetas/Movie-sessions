import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_list/stylize/stylize.dart';

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
              if (tab == 'По кинотеатрам') {
                List sessionsByCinema = [];
                //TODO optimize code
                sessions.forEach((element) {
                  var index = sessionsByCinema.indexWhere((value) =>
                      value['movie']['id'] == element['cinema']['id']);
                  if (!index.isNegative) {
                    sessionsByCinema[index]['items'].add(
                      {
                        'session': {
                          'session_date_tz': element['session']
                              ['session_date_tz'],
                          'lang_label': element['session']['lang_label'],
                          'child': element['session']['child'],
                          'student': element['session']['student'],
                          'adult': element['session']['adult'],
                          'vip': element['session']['vip'],
                        },
                        'hall': {
                          'name': element['hall']['name'],
                        }
                      },
                    );
                  } else {
                    sessionsByCinema.add({
                      'movie': {
                        'id': element['cinema']['id'],
                        'name_rus': element['cinema']['name'],
                        'address': element['cinema']['address'],
                      },
                      'items': [
                        {
                          'session': {
                            'session_date_tz': element['session']
                                ['session_date_tz'],
                            'lang_label': element['session']['lang_label'],
                            'child': element['session']['child'],
                            'student': element['session']['student'],
                            'adult': element['session']['adult'],
                            'vip': element['session']['vip'],
                          },
                          'hall': {
                            'name': element['hall']['name'],
                          }
                        },
                      ],
                    });
                  }
                });

                return ByCinema(tab, sessionsByCinema);
              } else if (tab == 'По времени') {
                return ByTime(sessions);
              } else if (tab == 'По фильмам') {
                return ByCinema(tab, sessions);
              } else {
                List sessionsByHall = [];
                //TODO optimize code
                sessions.forEach((element) {
                  element['items'].forEach((itemsElems) {
                    var index = sessionsByHall.indexWhere((value) =>
                        value['hall']['id'] == itemsElems['hall']['id']);
                    if (!index.isNegative) {
                      sessionsByHall[index]['items'].add(
                        {
                          'session': {
                            'session_date_tz': itemsElems['session']
                                ['session_date_tz'],
                            'lang_label': itemsElems['session']['lang_label'],
                            'child': itemsElems['session']['child'],
                            'student': itemsElems['session']['student'],
                            'adult': itemsElems['session']['adult'],
                            'vip': itemsElems['session']['vip'],
                          },
                          'movie': {
                            'id': element['movie']['id'],
                            'name_rus': element['movie']['name_rus'],
                          },
                        },
                      );
                    } else {
                      sessionsByHall.add({
                        'hall': {
                          'id': itemsElems['hall']['id'],
                          'name': itemsElems['hall']['name'],
                        },
                        'items': [
                          {
                            'session': {
                              'session_date_tz': itemsElems['session']
                                  ['session_date_tz'],
                              'lang_label': itemsElems['session']['lang_label'],
                              'child': itemsElems['session']['child'],
                              'student': itemsElems['session']['student'],
                              'adult': itemsElems['session']['adult'],
                              'vip': itemsElems['session']['vip'],
                            },
                            'movie': {
                              'id': element['movie']['id'],
                              'name_rus': element['movie']['name_rus'],
                            },
                          },
                        ],
                      });
                    }
                  });
                });
                return ByHall(sessionsByHall);
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
    return Container(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: sessionsByTime.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.only(bottom: 5),
                leading: SessionTime(
                    sessionsByTime[index]['session']['session_date_tz']),
                title: SessionCinema(sessionsByTime[index]),
                subtitle: SessionPrices(sessionsByTime[index]['session']),
              );
            }));
  }
}

class ByCinema extends StatelessWidget {
  //TODO change interface
  String tab;
  List sessionsByCinema;
  ByCinema(this.tab, this.sessionsByCinema);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sessionsByCinema.length,
        itemBuilder: (context, index) {
          String subtitle = tab == 'По кинотеатрам'
              ? sessionsByCinema[index]['movie']['address']
              : 'Возрастной рейтинг: с ' +
                  sessionsByCinema[index]['movie']['age_restriction']
                      .toString() +
                  ' лет';
          return Column(
            children: [
              ListTile(
                title: Text(
                  sessionsByCinema[index]['movie']['name_rus'],
                  style: TextStyle(
                      color: StylizeColor.selectedTextColor, fontSize: 20),
                ),
                subtitle: Text(subtitle,
                    style: TextStyle(color: Colors.grey[300], fontSize: 14)),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sessionsByCinema[index]['items'].length,
                  itemBuilder: (context2, index2) {
                    return ListTile(
                      leading: SessionTime(sessionsByCinema[index]['items']
                          [index2]['session']['session_date_tz']),
                      title: Text(
                        sessionsByCinema[index]['items'][index2]['hall']
                            ['name'],
                        style: TextStyle(color: StylizeColor.textColor),
                      ),
                      subtitle: SessionPrices(
                          sessionsByCinema[index]['items'][index2]['session']),
                    );
                  })
            ],
          );
        });
  }
}

// class ByMovie extends StatelessWidget {
//   //TODO change interface
//   String tab;
//   List sessionsByCinema;
//   ByMovie(this.tab, this.sessionsByCinema);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: sessionsByCinema.length,
//         itemBuilder: (context, index) {
//           String subtitle = tab == 'По кинотеатрам'
//               ? sessionsByCinema[index]['movie']['address']
//               : sessionsByCinema[index]['movie']['age_restriction'].toString();
//           return Column(
//             children: [
//               ListTile(
//                 title: Text(
//                   sessionsByCinema[index]['movie']['name_rus'],
//                   style: TextStyle(
//                       color: StylizeColor.selectedTextColor, fontSize: 18),
//                 ),
//                 subtitle: Text(subtitle,
//                     style: TextStyle(color: Colors.grey[300], fontSize: 12)),
//               ),
//               ListView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: sessionsByCinema[index]['items'].length,
//                   itemBuilder: (context2, index2) {
//                     return ListTile(
//                       leading: SessionTime(sessionsByCinema[index]['items']
//                           [index2]['session']['session_date_tz']),
//                       title: Text(
//                         sessionsByCinema[index]['items'][index2]['hall']
//                             ['name'],
//                         style: TextStyle(color: StylizeColor.textColor),
//                       ),
//                       subtitle: SessionPrices(
//                           sessionsByCinema[index]['items'][index2]['session']),
//                     );
//                   })
//             ],
//           );
//         });
//   }
// }

class ByHall extends StatelessWidget {
  //TODO change interface
  List sessionsByHall;
  ByHall(this.sessionsByHall);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sessionsByHall.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  sessionsByHall[index]['hall']['name'],
                  style: TextStyle(
                      color: StylizeColor.selectedTextColor, fontSize: 24),
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sessionsByHall[index]['items'].length,
                  itemBuilder: (context2, index2) {
                    return ListTile(
                      leading: SessionTime(sessionsByHall[index]['items']
                          [index2]['session']['session_date_tz']),
                      title: Text(
                        sessionsByHall[index]['items'][index2]['movie']
                            ['name_rus'],
                        style: TextStyle(color: StylizeColor.textColor),
                      ),
                      subtitle: SessionPrices(
                          sessionsByHall[index]['items'][index2]['session']),
                    );
                  })
            ],
          );
        });
  }
}

class SessionTime extends StatelessWidget {
  String time;
  SessionTime(this.time);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            border:
                Border.all(color: StylizeColor.selectedTextColor, width: 2)),
        child: Text(
          DateFormat('HH:mm').format(DateTime.parse(time)),
          style: TextStyle(color: StylizeColor.textColor, fontSize: 24),
        ));
  }
}

class SessionCinema extends StatelessWidget {
  Map cinema;
  SessionCinema(this.cinema);
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cinema['cinema']['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: StylizeColor.textColor, fontSize: 17),
          ),
          Text(
            cinema['hall']['name'],
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: Colors.grey[300], fontSize: 13),
          )
        ]);
  }
}

class SessionPrices extends StatelessWidget {
  Map prices;
  SessionPrices(this.prices);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          prices['lang_label'],
          style: TextStyle(color: StylizeColor.textColor, fontSize: 15),
        ),
        Text(
          priceChecker(prices['child']),
          style: TextStyle(color: StylizeColor.textColor, fontSize: 15),
        ),
        Text(
          priceChecker(prices['student']),
          style: TextStyle(color: StylizeColor.textColor, fontSize: 15),
        ),
        Text(
          priceChecker(prices['adult']),
          style: TextStyle(color: StylizeColor.textColor, fontSize: 15),
        ),
        Text(
          priceChecker(prices['vip']),
          style: TextStyle(color: StylizeColor.textColor, fontSize: 15),
        )
      ],
    );
  }
}

String priceChecker(price) {
  return price != 0 ? price.toString() : '-';
}
