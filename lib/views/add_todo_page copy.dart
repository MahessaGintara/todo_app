import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/adapters/todo.dart';

class AddTodoPage extends StatefulWidget {
  final Todo? todo;
  final Function(String title, String note, String category,
      TimeOfDay timeremember, bool rememberme) onClickDone;

  const AddTodoPage({
    Key? key,
    this.todo,
    required this.onClickDone,
  }) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  late final Box box;

  //?controller
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _timeRememberController = TimeOfDay.now();
  bool _rememberMeController = false;

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(27, 25, 27, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        const Text(
                          "New Todo",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        Transform.rotate(
                          angle: 45 * pi / 180,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 29),
                    const Text(
                      "What are you planning?",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 17.5),
                    TextFormField(
                      controller: _titleController,
                      validator: (title) =>
                          title != null && title.isEmpty ? 'Title' : null,
                      maxLength: 30,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 43),
                    TextButton.icon(
                      onPressed: () => {
                        showTimePicker(
                          context: context,
                          initialTime: _timeRememberController,
                          initialEntryMode: TimePickerEntryMode.dial,
                          confirmText: 'Confirm',
                          cancelText: 'Cancle',
                          helpText: 'Remember Time',
                        ),
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: const Text(
                        'Remember me',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => {
                            _showNoteInputDialog(context),
                          },
                          icon: const Icon(
                            Icons.insert_drive_file_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: const Text(
                            'Add note',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _noteController,
                      ),
                    ),
                    categoryButton(context),
                  ],
                ),
              ),
              createButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget createButton(BuildContext context) => ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();

          if (isValid) {
            final title = _titleController.text;
            final note = _noteController.text;
            final category = _categoryController.text;
            final timeRemember = _timeRememberController;
            final rememberme = _rememberMeController;

            widget.onClickDone(title, note, category, timeRemember, rememberme);

            Navigator.of(context).pop();
          }
        },
        child: const Text(
          'Create',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: const Color.fromRGBO(255, 46, 99, 1),
          minimumSize: const Size(double.infinity, 51),
        ),
      );

  Widget categoryButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.folder_outlined,
            color: Colors.white,
            size: 24,
          ),
          label: const Text(
            'Category',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _showNoteInputDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
        //Todo Add Todo
      },
      child: const Text('Ok'),
    );
    Widget cancleButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancle'),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Add note"),
      content: TextFormField(
        controller: _noteController,
        validator: (value) => value != null && value.isEmpty ? 'Note' : null,
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(hintText: "Note"),
      ),
      actions: [
        okButton,
        cancleButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
