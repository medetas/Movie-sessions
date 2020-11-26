// import 'package:flutter/material.dart';

// class Tags extends StatefulWidget {
//   String tagValue;
//   Tags(this.tagValue);

//   @override
//   _TagsState createState() => _TagsState(tagValue);
// }

// class _TagsState extends State<Tags> {

//   String tagValue;
//   _TagsState(this.tagValue);

// Color textColor = Color(0xffE9ECE4);
// List<Color> ageColor;
//                   int age_restriction =
//                       movies_list.elementAt(index)['age_restriction'];
//                   if (0 <= age_restriction && age_restriction < 6) {
//                     ageColor = ageList[0];
//                   } else if (6 <= age_restriction && age_restriction < 12) {
//                     ageColor = ageList[6];
//                   } else if (12 <= age_restriction && age_restriction < 18) {
//                     ageColor = ageList[12];
//                   } else {
//                     ageColor = ageList[18];
//                   }

//                   String rating = movies_list.elementAt(index)['rating'] != 0
//                       ? movies_list
//                           .elementAt(index)['rating']
//                           .toStringAsFixed(1)
//                       : '-';

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: ageColor)),
//         child: Text(
//           age_restriction.toString() + '+',
//           style: TextStyle(
//             color: textColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
