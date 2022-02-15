import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/adapters/boxes.dart';
import 'package:todo_app/adapters/todo.dart';

class AddTodoPage extends StatefulWidget {
  final Todo? todo;
  final Function(String title, String note, String category) onClickDone;

  const AddTodoPage({
    Key? key,
    this.todo,
    required this.onClickDone,
  }) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  late String _category;
  String _categoryController = '';
  final _formkey = GlobalKey<FormState>();
  late final Box categoryBox;

  @override
  void initState() {
    _noteController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(27, 25, 27, 0),
                child: Column(
                  children: [
                    navigatorBar(context),
                    const SizedBox(
                      height: 24,
                    ),
                    todoInputWidget(context),
                  ],
                ),
              ),
              confirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final isValid = _formkey.currentState!.validate();
        if (isValid) {
          final title = _titleController.text;
          final note = _noteController.text;
          final category = _category;
          final newCategory = _categoryController;

          widget.onClickDone(
              title,
              note,
              newCategory == null || newCategory == ''
                  ? category
                  : newCategory);

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
  }

  Widget todoInputWidget(BuildContext context) {
    var listCategory = Boxes.getCategory();
    late List<String> category = [];
    for (var i = 0; i < listCategory.length; i++) {
      var item = listCategory.getAt(i)?.name;
      category.add(item.toString());
    }
    _category = category[0];
    print('new value' + category.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _titleController,
          validator: (title) =>
              title != null && title.isEmpty ? 'Title is Empty' : null,
          maxLength: 30,
          keyboardType: TextInputType.multiline,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            label: Text("What are you planning?"),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white,
            ),
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
        const SizedBox(
          height: 17.5,
        ),
        Row(
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
            Flexible(
              child: Text(
                _noteController.text == "" ? '' : "(${_noteController.text})",
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 17.5,
        ),
        Container(
          width: 200,
          child: DropdownButtonFormField(
            isExpanded: true,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            onChanged: (String? newValue) {
              print("on change" + _categoryController);
              setState(() {
                _categoryController = newValue!;
                print("set state" + _categoryController);
              });
            },
            items: category.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            dropdownColor: const Color.fromRGBO(255, 119, 119, 1),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.folder_outlined,
                color: Colors.white,
                size: 24,
              ),
              label: Text("Category"),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.white,
              ),
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
          ),
        ),
      ],
    );
  }

  Widget navigatorBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 30),
        const Text(
          "New Todo",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
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
    );
  }

  _showNoteInputDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          _noteController.text = _noteController.text;
        });
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
        maxLength: 30,
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
