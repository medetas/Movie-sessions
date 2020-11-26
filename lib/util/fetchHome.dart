import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart';

class HomeFetcher {
  String url;
  int id_city;
  RegExp re = new RegExp(r"/_next/static/(\S*?)/_buildManifest.js");

  HomeFetcher({this.id_city});

  Future<List> fetchSoon() async {
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);
    print(url);

    Response response = await get(
        'https://kino.kz/_next/data/$url/movies_list.json?filter=soon');
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    // data['pageProps'].forEach((element) {
    //   print(element);
    // });
    print(data['pageProps']['movies']);
    return data['pageProps']['movies'];
  }

  Future<List> fetchTodays() async {
    Response html_response = await get('https://kino.kz/cinemas');
    var document = (html_response.body);
    url = re.firstMatch(document).group(1);
    print(url);

    Response response = await get(
        'https://kino.kz/_next/data/$url/movies_list.json?city=$id_city'); //TODO check if return is null(empty)
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    // data['pageProps'].forEach((element) {
    //   print(element);
    // });
    print(data['pageProps']['movies']);
    return data['pageProps']['movies'];
  }
}
