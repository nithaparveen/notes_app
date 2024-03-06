import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../model/notes_model.dart';
import '../view/home_screen/widgets/add_category_dialog.dart';
import '../view/home_screen/widgets/remove_category_dialog.dart';

class CategoryController {
  final CatBox = Hive.box('categories');
  final noteBox = Hive.box('noteBox');

  void initializeApp() async {
    // List of default categories
    List<String> defaultCategories = ['Work', 'Personal', 'Ideas'];
    // Check if categories already exist
    bool categoriesExist = CatBox.isNotEmpty;
    // If default categories don't exist, add them
    if (!categoriesExist) {
      for (String categoryName in defaultCategories) {
        CatBox.add(categoryName);
      }
    }
  }

// Function to add a user-defined category
  void addUserCategory(String categoryName) {
    CatBox.add(categoryName);
  }

  // Function to get all categories
  List getAllCategories() {
    return CatBox.values.toList();
  }

  addCategory({
    required BuildContext context,
    required TextEditingController categoryController,
    required CategoryController catController,
    required void Function() fetchdata,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
          categoryController: categoryController,
          catController: catController,
          fetchdata: fetchdata),
    );
  }

  removeUserCategory({required int catIndex, required Function() fetchData}) {
    print(catIndex);
    print(CatBox.get(catIndex));
    print(noteBox.get(catIndex));
    noteBox.delete(catIndex);
    CatBox.delete(catIndex);
    fetchData();
  }

  removeCategory(
      {required int catIndex,
        required String catName,
        required BuildContext context,
        required void Function() fetchData}) {
    return showDialog(
      context: context,
      builder: (context) => RemoveCategoryDialog(
          categoryName: catName, categoryIndex: catIndex, fetchData: fetchData),
    );
  }
}

class NotesController {
  final noteBox = Hive.box('noteBox');

  void addNotes(
      {required GlobalKey<FormState> formkey,
        required String title,
        required String description,
        required String date,
        required int category,
        required TextEditingController titleController,
        required TextEditingController desController,
        required BuildContext context}) {
    if (formkey.currentState!.validate()) {
      List<NotesModel> currentNotes = noteBox.containsKey(category)
          ? noteBox.get(category)!.cast<NotesModel>()
          : []; // Initialize as an empty list if category doesn't exist

      var note = NotesModel(
        title: title,
        description: description,
        date: date,
        category: category,
      );

      currentNotes.add(note);
      noteBox.put(category, currentNotes);
      titleController.clear();
      desController.clear();
      Navigator.pop(context);
    }
  }

  void deleteNote({
    required var key,
    required NotesModel note,
    required void Function() fetchData,
    required int index,
  }) {
    List<NotesModel> list = noteBox.get(key)!.cast<NotesModel>();
    print("before: $list");
    print("index: $index");
    print("lis length  : ${list.length}");

    if (index < 0 || index >= list.length) {
      print("Invalid index: $index. Index out of range.");
      return; // Exit the function if index is out of range
    }

    print("before2: $list");
    list.remove(note);
    print("after: $list");
    noteBox.put(key, list);
    print("updated: ${noteBox.get(key)}");

    if (list.length == 0) {
      noteBox.delete(key);
    }
  }

  void editNote({
    required String title,
    required String description,
    required String date,
    required int category,
    required GlobalKey<FormState> formkey,
    required int indexOfNote,
    required int oldCategory,
  }) {
    List<NotesModel> currentNotes =
        noteBox.get(oldCategory)?.cast<NotesModel>() ?? [];
    NotesModel note = NotesModel(
      title: title,
      description: description,
      date: date.toString(),
      category: category,
    );

    currentNotes.removeAt(indexOfNote);
    noteBox.put(oldCategory, currentNotes);

    if (currentNotes.isEmpty) {
      noteBox.delete(oldCategory);
    }

    List<NotesModel> updatedNotes =
        noteBox.get(category)?.cast<NotesModel>() ?? [];
    updatedNotes.add(note);
    noteBox.put(category, updatedNotes);
  }

  void shareNote({required String Note}) {
    Share.share(Note);
  }
}