import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_app/adapters/todo.dart';

class AddCategory extends StatefulWidget {
  final Category? category;
  final Function(String name, List colors) onClickDone;
  const AddCategory({Key? key, this.category, required this.onClickDone})
      : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final _caNameController = TextEditingController();
  final colors = <int>[255, 255, 255];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 27),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    navigationBar(context),
                    const SizedBox(
                      height: 24,
                    ),
                    caNameInput(context),
                    const SizedBox(
                      height: 24,
                    ),
                    colorPicker(context),
                  ],
                ),
              ),
              confirmButon(context),
            ],
          ),
        ),
      ),
    );
  }

  navigationBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 30),
          const Text(
            "New Category",
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
  Widget caNameInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category Name",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        TextFormField(
          controller: _caNameController,
          validator: (title) => title != null && title.isEmpty ? 'Title' : null,
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
      ],
    );
  }

  Widget colorPicker(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Accent Colors',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          color: const Color.fromRGBO(255, 157, 157, 1),
          child: Text(
            'Category Name',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(colors[0], colors[1], colors[2], 1),
            ),
          ),
        ),
        Slider(
          value: colors[0].toDouble(),
          max: 255,
          // divisions: 5,
          thumbColor: Colors.red,
          activeColor: Colors.red[400],
          inactiveColor: Colors.red[50],
          label: colors[0].toDouble().round().toString(),
          onChanged: (double value) {
            setState(() {
              colors[0] = value.toInt();
            });
          },
        ),
        Slider(
          value: colors[1].toDouble(),
          max: 255,
          // divisions: 5,
          thumbColor: Colors.green,
          activeColor: Colors.green[400],
          inactiveColor: Colors.green[50],
          label: colors[1].toDouble().round().toString(),
          onChanged: (double value) {
            setState(() {
              colors[1] = value.toInt();
            });
          },
        ),
        Slider(
          value: colors[2].toDouble(),
          max: 255,
          // divisions: 5,
          thumbColor: Colors.blue,
          activeColor: Colors.blue[400],
          inactiveColor: Colors.blue[50],
          label: colors[2].toDouble().round().toString(),
          onChanged: (double value) {
            setState(() {
              colors[2] = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget confirmButon(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final isValid = _formKey.currentState!.validate();

        if (isValid) {
          final caName = _caNameController.text;

          widget.onClickDone(caName, colors);

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
}
