import 'package:flutter/material.dart';
import 'package:mini_notes/consts.dart';

enum TileColors { c1, c2, c3, c4, c5, c6, c7 }

class KGridTile extends StatelessWidget {
  const KGridTile(
      {Key? key,
      required this.title,
      required this.date,
      required this.color,
      required this.maxLines,
      required this.isEndDate})
      : super(key: key);

  final String title;
  final String date;
  final int color;
  final int maxLines;
  final bool isEndDate;

  @override
  Widget build(BuildContext context) {
    double fontSize;
    double wordSpacing;

    switch (maxLines) {
      case 3:
        fontSize = 25;
        wordSpacing = 2;
        break;
      case 10:
        fontSize = 22;
        wordSpacing = 2;
        break;
      default:
        fontSize = 19;
        wordSpacing = 1;
        break;
    }
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: maxLines,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: fontSize,
                wordSpacing: wordSpacing,
                letterSpacing: wordSpacing == 1 ? 1 : 1.1,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Align(
            alignment:
                maxLines == 3 ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
