import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/color_constants.dart';

class NotePage extends StatelessWidget {
  const NotePage(
      {super.key,
        required this.title,
        required this.description,
        required this.date,
        required this.category});

  final String title;
  final String description;
  final String date;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryCardColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryCardColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                      color: ColorConstants.primaryBackgroundColor,
                      fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              title,
              style: TextStyle(
                  color: ColorConstants.primaryBackgroundColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "* $category",
              style: TextStyle(
                  color: ColorConstants.secondaryColor1, fontSize: 15),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              description,
              style: TextStyle(color: ColorConstants.primaryBackgroundColor),
            )
          ],
        ),
      ),
    );
  }
}