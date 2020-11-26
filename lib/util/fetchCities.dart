import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:http/http.dart';

class Fetcher {
  Map cities = {};
  Map cinemas = {};
  Map movies = {};
  String url;
  int id_cinema;
  Fetcher({this.id_cinema});
  RegExp re = new RegExp(r"/_next/static/(\S*?)/_buildManifest.js");

  Future<Map> fetchCities() async {
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);

    Response json_response =
        await get('https://kino.kz/_next/data/$url/index.json');
    Map data = jsonDecode(utf8.decode(json_response.bodyBytes));
    data['pageProps']['cities'].forEach((element) {
      cities[element['id']] = element['name'];
    });
    print(cities);
    return cities;
    //   if (html_response.statusCode == 200) {
    //     // If the server did return a 200 OK response,
    //     // then parse the JSON.
    //     return Album.fromJson(jsonDecode(html_response.body));
    //   } else {
    //     // If the server did not return a 200 OK response,
    //     // then throw an exception.
    //     throw Exception('Failed to load album');
    //   }
    // }
  }

  Future<List> fetchCinemas() async {
    //TODO Make html response as 1 func in init (delete repeatition)
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);

    Response response = await get(
        'https://kino.kz/_next/data/$url/cinemas.json?cityId=$id_cinema');
    print(url);
    print(id_cinema);
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    data['pageProps']['cinemas'].forEach((element) {
      cinemas[element['id']] = element['name'];
    });
    // print('AAAAAAAAAAa');
    // print(data['pageProps']['cinemas'][14]['small_poster']);
    return data['pageProps']['cinemas'];
  }

  Future<Map> fetchMovies() async {
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Response response = await get(
        'https://kino.kz/api/cinema/sessions?cinemaId=$id_cinema&date=2020-11-24'); //TODO change date
    print('movie');
    print(id_cinema);
    print(date);
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);
    data['result']['sessions'].forEach((element) {
      movies[element['movie']['name_rus']] = element['movie'];
    });
    print(movies);
    return movies;
  }
}
