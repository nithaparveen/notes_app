import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../controller/home_screen_controller.dart';
import '../../model/notes_model.dart';
import '../../utils/color_constants.dart';
import 'widgets/note_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var noteBox = Hive.box('noteBox');

//category controller object
  CategoryController catController = CategoryController();

  //notes controller object
  NotesController notesController = NotesController();

// category list from hive category box
  List categories = [];

  // Index of selected category
  int categoryIndex = 0;

//category controller
  TextEditingController categoryController = TextEditingController();

  // adding/editing form controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // adding/editing form key
  final _formKey = GlobalKey<FormState>();

  //keys list
  List myKeysList = [];

  bool isEditing = false;

  @override
  void initState() {
    catController.initializeApp();
    categories = catController.getAllCategories();
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  void fetchData() {
    myKeysList = noteBox.keys.toList();
    categories = catController.getAllCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryBackgroundColor,
      floatingActionButton: FloatingActionButton(
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(15)),
          borderSide: BorderSide(width: 2,
              color: Colors.white),
        ),
        elevation: 0,
        onPressed: () => bottomSheet(context),
        backgroundColor: ColorConstants.secondaryColor2,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: ListView.separated(
              itemBuilder: (context, index) {
                List<NotesModel> notesInCategory =
                noteBox.get(myKeysList[index])!.cast<NotesModel>();
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categories[myKeysList[index]],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.primaryColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            notesInCategory.length,
                                (inIndex) {
                              return NoteWidgets(
                                title: notesInCategory[
                                notesInCategory.length - inIndex - 1]
                                    .title,
                                description: notesInCategory[
                                notesInCategory.length - inIndex - 1]
                                    .description,
                                date: notesInCategory[
                                notesInCategory.length - inIndex - 1]
                                    .date,
                                category: categories[myKeysList[index]],
                                onDelete: () {
                                  print(
                                      "index1: ${notesInCategory.length - inIndex - 1}");
                                  notesController.deleteNote(
                                    key: myKeysList[index],
                                    note: notesInCategory[
                                    notesInCategory.length - inIndex - 1],
                                    fetchData: fetchData,
                                    index: notesInCategory.length - inIndex - 1,
                                  );
                                  fetchData();
                                  setState(() {});
                                },
                                onUpdate: () {
                                  titleController.text = notesInCategory[
                                  notesInCategory.length - inIndex - 1]
                                      .title;
                                  descriptionController.text = notesInCategory[
                                  notesInCategory.length - inIndex - 1]
                                      .description;
                                  categoryIndex = notesInCategory[
                                  notesInCategory.length - inIndex - 1]
                                      .category;
                                  isEditing = true;
                                  bottomSheet(context,
                                      key: myKeysList[index],
                                      indexOfEditing:
                                      notesInCategory.length - inIndex - 1,
                                      currentCategory: notesInCategory[
                                      notesInCategory.length -
                                          inIndex -
                                          1]
                                          .category);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 20,
              ),
              itemCount: myKeysList.length),
        ),
      ),
    );
  }

// Bottom sheet extracted
  Future<dynamic> bottomSheet(BuildContext context,
      {var key, int? indexOfEditing, int? currentCategory}) {
    return showModalBottomSheet(
      backgroundColor: ColorConstants.primaryBackgroundColor,
      shape: const OutlineInputBorder(
        borderSide: BorderSide(width: 0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, InsetState) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(
                            color: ColorConstants.primaryColor,
                            fontWeight: FontWeight.w500),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorConstants.primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: ColorConstants.primaryColor,
                            )),
                        isDense: false,
                        // Added this
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 150,
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorConstants.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "Description",
                          hintStyle:
                          TextStyle(color: ColorConstants.primaryColor),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: ColorConstants.primaryColor,
                              )),
                          isDense: false,
                          // Added this
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Category",
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            categories.length + 1,
                                (index) => index == categories.length
                                ? InkWell(
                              onTap: () => catController.addCategory(
                                  context: context,
                                  categoryController: categoryController,
                                  catController: catController,
                                  fetchdata: fetchData),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                child: const Text(
                                  " + Add Category",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            )
                                : Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: InkWell(
                                onTap: () {
                                  categoryIndex = index;
                                  InsetState(() {});
                                },
                                onLongPress: () {
                                  print(index);
                                  print(categories[index].toString());
                                  catController.removeCategory(
                                      catIndex: index,
                                      catName:
                                      categories[index].toString(),
                                      context: context,
                                      fetchData: fetchData);
                                  fetchData();

                                  setState(() {});
                                  InsetState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: categoryIndex == index
                                          ? Colors.black
                                          : ColorConstants
                                          .primaryCardColor,
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  child: Text(
                                    categories[index].toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      ColorConstants.primaryColor)),
                              onPressed: () {
                                titleController.clear();
                                descriptionController.clear();
                                Navigator.pop(context);
                                isEditing = false;
                                setState(() {});
                              },
                              child: const Text("Cancel")),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      ColorConstants.primaryColor)),
                              onPressed: () {
                                if (isEditing) {
                                  notesController.editNote(
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      date: DateFormat('dd:MM:yyyy')
                                          .format(DateTime.now())
                                          .toString(),
                                      category: categoryIndex,
                                      oldCategory: currentCategory!,
                                      formkey: _formKey,
                                      indexOfNote: indexOfEditing!);
                                  isEditing = false;
                                  titleController.clear();
                                  descriptionController.clear();
                                  fetchData();
                                  categoryIndex = 0;
                                  Navigator.pop(context);
                                } else {
                                  notesController.addNotes(
                                      formkey: _formKey,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      date: DateFormat('dd:MM:yyyy')
                                          .format(DateTime.now())
                                          .toString(),
                                      category: categoryIndex,
                                      context: context,
                                      desController: descriptionController,
                                      titleController: titleController);

                                  fetchData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Note added ")));
                                  setState(() {});
                                }
                              },
                              child: isEditing
                                  ? const Text("Edit")
                                  : const Text("Add")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}