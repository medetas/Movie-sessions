// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart';

// class Fetcher {
//   int id;
//   List cinemas = [];

//   Fetcher({this.id});

//   Future<List> fetchAlbum() async {
//     Response response = await get(
//         'https://kino.kz/_next/data/VTVBdK3iSlWCuILjAJ2VZ/cinemas.json?cityId=$id');
//     Map data = jsonDecode(utf8.decode(response.bodyBytes));
//     data['pageProps']['cinemas'].forEach((element) {
//       cinemas.add(element['name']);
//     });
//     print(cinemas);
//     return cinemas;
//     // if (response.statusCode == 200) {
//     //   // If the server did return a 200 OK response,
//     //   // then parse the JSON.
//     //   return Album.fromJson(jsonDecode(response.body));
//     // } else {
//     //   // If the server did not return a 200 OK response,
//     //   // then throw an exception.
//     //   throw Exception('Failed to load album');
//     // }
//   }
// }

// // class Album {
// // final String name_rus;
// // final String name_origin;
// // final double rating;

// //   Album({this.name_rus, this.name_origin, this.rating});

// //   factory Album.fromJson(Map<String, dynamic> json) {
// //     return Album(
// //       name_rus: json['result']['sessions'][0]['movie']['name_rus'],
// //       name_origin: json['result']['sessions'][0]['movie']['name_origin'],
// //       rating: json['result']['sessions'][0]['movie']['rating'],
// //     );
// //   }
// // }
