import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/views/home_page.dart';
import 'package:todo_app/views/start/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Box box;

  _checkName() async {
    print('work');
    var name = box.get('name');
    print(name);
    if (name == null || name == '') {
      Future.delayed(
        Duration.zero,
        () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
              (route) => false);
        },
      );
    } else {
      Future.delayed(
        Duration.zero,
        () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false,
          );
        },
      );
    }
  }

  @override
  initState() {
    super.initState();
    box = Hive.box('userBox');
  }

  @override
  void didChangeDependencies() {
    _checkName();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  height: 200,
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                Text(
                  'Wait a second ...',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
