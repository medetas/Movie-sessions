import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_list/screens/movie.dart';
import 'package:movie_list/screens/tags.dart';
import 'package:movie_list/stylize/stylize.dart';

class SoonToday extends StatefulWidget {
  String title;
  Future<List> futureMovieList;
  SoonToday(this.title, this.futureMovieList);
  @override
  _SoonTodayState createState() => _SoonTodayState(title, futureMovieList);
}

class _SoonTodayState extends State<SoonToday> {
  String title;
  Future<List> futureMovieList;
  _SoonTodayState(this.title, this.futureMovieList);

  List<Widget> tags;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: futureMovieList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List movies_list = snapshot.data ?? {};
            List<String> imageList = [];
            movies_list.forEach((element) {
              element['small_poster'] != ''
                  ? imageList.add((element['small_poster']))
                  : imageList.add('null');
            });

            return Column(children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 5, bottom: 5),
                  child: Text(title,
                      style: TextStyle(
                          color: StylizeColor.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold))),
              Container(
                  child: CarouselSlider.builder(
                itemCount: imageList.length,
                options: CarouselOptions(
                  autoPlay: false,
                  viewportFraction: 0.4,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (context, index) {
                  tags = [
                    Tags('rating', movies_list.elementAt(index)['rating']),
                    Tags('age', movies_list.elementAt(index)['age_restriction'])
                  ];

                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Movie(
                                  'movie', movies_list.elementAt(index)['id']),
                            ));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageList[index] != 'null'
                                    ? NetworkImage(
                                        imageList[index],
                                      )
                                    : AssetImage('assets/poster_v.jpg'),
                                fit: BoxFit.fill,
                              )),
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: tags,
                          ))));
                },
              )),
            ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
