import 'package:flutter/material.dart';
import '../../../controller/home_screen_controller.dart';
import '../../../utils/color_constants.dart';

class RemoveCategoryDialog extends StatelessWidget {
  RemoveCategoryDialog(
      {super.key,
        required this.categoryName,
        required this.categoryIndex,
        required this.fetchData});
  String categoryName;
  int categoryIndex;
  final void Function() fetchData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete $categoryName ?"),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStatePropertyAll(ColorConstants.primaryColor)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll(ColorConstants.primaryColor)),
            onPressed: () {
              print(categoryIndex);
              print(categoryName);
              CategoryController().removeUserCategory(
                  catIndex: categoryIndex, fetchData: fetchData);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$categoryName deleted successfull")));
              fetchData();
            },
            child: Text("Delete"))
      ],
    );
  }
}