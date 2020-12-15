import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_list/stylize/stylize.dart';

class Cities extends StatefulWidget {
  Future<Map> futureCities;
  Cities(this.futureCities);
  @override
  _CitiesState createState() => _CitiesState(futureCities);
}

class _CitiesState extends State<Cities> {
  Future<Map> futureCities;
  _CitiesState(this.futureCities);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: StylizeColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: StylizeColor.backgroundColor,
          title: Text('Выберите город'),
        ),
        body: FutureBuilder<Map>(
            future: futureCities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map cities_list = snapshot.data ?? {};
                return ListView.builder(
                    itemCount: cities_list.length,
                    itemBuilder: (context, index) {
                      String city = cities_list.values.elementAt(index);
                      int id_city = cities_list.keys.elementAt(index);
                      return new ListTile(
                        title: Container(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: StylizeColor.textColor,
                              width: 2,
                            ))),
                            child: Text(
                              city,
                              style: TextStyle(
                                  color: StylizeColor.textColor, fontSize: 22),
                              textAlign: TextAlign.center,
                            )),
                        onTap: () {
                          Navigator.pop(context, [id_city, city]);
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
