import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart';

class CinemaFetcher {
  String url;
  int id_cinema;
  RegExp re = new RegExp(r"/_next/static/(\S*?)/_buildManifest.js");
  CinemaFetcher({this.id_cinema});

  Future<List> fetchSessions() async {
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);

    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Response response = await get(
        'https://kino.kz/api/cinema/sessions?cinemaId=$id_cinema&date=$date');
    Map data = jsonDecode(utf8.decode(response.bodyBytes));

    if (data['result']['sessions'] != null) {
      return data['result']['sessions'];
    } else {
      return ['empty'];
    }
  }
}
