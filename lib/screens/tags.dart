import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  String tagName;
  var tagValue;
  Tags(this.tagName, this.tagValue);

  @override
  _TagsState createState() => _TagsState(tagName, tagValue);
}

class _TagsState extends State<Tags> {
  String tagName;
  var tagValue;
  _TagsState(this.tagName, this.tagValue);

  Color textColor = Color(0xffE9ECE4);

  @override
  Widget build(BuildContext context) {
    if (tagName == 'age') {
      List<Color> ageColor;
      Map ageList = {
        0: [Colors.yellow[600], Colors.yellow[800]],
        6: [Colors.amber[600], Colors.amber[800]],
        12: [Colors.deepOrange[400], Colors.deepOrange[800]],
        18: [Colors.red[600], Colors.red[900]],
      };

      if (0 <= tagValue && tagValue < 6) {
        ageColor = ageList[0];
      } else if (6 <= tagValue && tagValue < 12) {
        ageColor = ageList[6];
      } else if (12 <= tagValue && tagValue < 18) {
        ageColor = ageList[12];
      } else {
        ageColor = ageList[18];
      }
      return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ageColor)),
          child: Text(
            tagValue.toString() + '+',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      String rating = tagValue != 0 ? tagValue.toStringAsFixed(1) : '-';
      return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green[400], Colors.green[900]])),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  rating,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      );
    }
  }
}
