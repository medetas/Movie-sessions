import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_list/screens/cinemas.dart';
import 'package:movie_list/util/fetchCities.dart';

class Cities extends StatefulWidget {
  Future<Map> futureCities;
  Cities(this.futureCities);
  // Cities({Key key}) : super(key: key);
  @override
  _CitiesState createState() => _CitiesState(futureCities);
}

class _CitiesState extends State<Cities> {
  Future<Map> futureCities;
  _CitiesState(this.futureCities);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cities'),
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
                        title: Text(city),
                        onTap: () {
                          print(cities_list.keys.elementAt(index));
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
