import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart';

class MovieFetcher {
  String url;
  int id_movie;
  RegExp re = new RegExp(r"/_next/static/(\S*?)/_buildManifest.js");
  MovieFetcher({this.id_movie});

  Future<Map> fetchMovie() async {
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);
    print(url);
    print(id_movie);
    Response response =
        await get('https://kino.kz/_next/data/$url/movie/$id_movie.json');
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data['pageProps']['movie']);
    return data['pageProps']['movie'];
  }

  Future<List> fetchSessions() async {
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);

    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Response response = await get(
        'https://kino.kz/api/movie/sessions?movieId=$id_movie&date=$date&city_id=2'); //TODO change date
    Map data = jsonDecode(utf8.decode(response.bodyBytes));

    return data['result']['sessions'] ?? ['empty'];
  }
}
