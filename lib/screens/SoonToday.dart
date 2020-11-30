import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_list/screens/movie.dart';
import 'package:movie_list/screens/tags.dart';

class SoonToday extends StatefulWidget {
  Future<List> futureList2;
  SoonToday(this.futureList2);
  @override
  _SoonTodayState createState() => _SoonTodayState(futureList2);
}

class _SoonTodayState extends State<SoonToday> {
  Future<List> futureList2;
  _SoonTodayState(this.futureList2);

  int selectedIndex = 0;
  Color textColor = Color(0xffE9ECE4);
  Color backgroundColor = Colors.white;
  Color cardColor = Color(0xff013766);

  Map ageList = {
    0: [Colors.yellow[600], Colors.yellow[800]],
    6: [Colors.amber[600], Colors.amber[800]],
    12: [Colors.deepOrange[400], Colors.deepOrange[800]],
    18: [Colors.red[600], Colors.red[900]],
  };

  List<Widget> tags;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: futureList2,
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
              Text('Скоро в кино',
                  style: TextStyle(color: textColor, fontSize: 20)),
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
                              builder: (context) =>
                                  Movie(movies_list.elementAt(index)['id']),
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
