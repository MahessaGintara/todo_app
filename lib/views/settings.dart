import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final Box box;
  var name;
  final _nameController = TextEditingController();

  _editName(BuildContext context) async {
    var newname = _nameController.text;
    if (newname == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Nama Tidak boleh Kosong!')));
    } else {
      box.put('name', _nameController.text);
      Navigator.pop(context);
    }
  }

  _checkName() async {
    print('checkpoint settings');
    setState(() {
      name = box.get('name');
      _nameController.text = name;
    });
    print(name);
    if (name == null || name == '') {
      Future.delayed(Duration.zero, () {
        _showInputNameDialog(context);
      });
    }
  }

  _showInputNameDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        _editName(context);
        _checkName();
      },
      child: Text('Ok'),
    );
    Widget cancleButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Cancle'),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Masukan nama kamu !"),
      content: TextField(
        controller: _nameController,
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(hintText: "Name"),
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

  @override
  void initState() {
    super.initState();
    box = Hive.box('userBox');
    _checkName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(27, 25, 27, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text("Settings",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Colors.white)),
                      Transform.rotate(
                        angle: 45 * pi / 180,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        onPressed: () => {
                          _showInputNameDialog(context),
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
