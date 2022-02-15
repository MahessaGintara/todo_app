import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/adapters/boxes.dart';
import 'package:todo_app/adapters/todo.dart';
import 'package:todo_app/views/add_category_page.dart';
import 'package:todo_app/views/settings.dart';
import 'package:todo_app/views/add_todo_page.dart';
import 'package:todo_app/views/start/splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final Box userBox;
  var name;

  _checkName() async {
    setState(() {
      name = userBox.get('name');
    });

    if (name == null || name == '') {
      Future.delayed(Duration.zero, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      });
    }
  }

  @override
  void initState() {
    userBox = Hive.box('userBox');
    _checkName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(27, 25, 27, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  homeNavbar(context),
                  const SizedBox(
                    height: 23,
                  ),
                  Text(
                    "What`s up, $name!",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CATEGORIES",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCategory(
                                onClickDone: addCategory,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: ValueListenableBuilder<Box<Category>>(
                valueListenable: Boxes.getCategory().listenable(),
                builder: (context, box, _) {
                  final categories = box.values.toList().cast<Category>();
                  return categoryBuilder(categories);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(27, 41, 17, 16),
              child: Text(
                "TODAY`S TODO",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
            _category(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Todo',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodoPage(
                onClickDone: addTodo,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: Colors.pink,
        splashColor: Colors.pinkAccent,
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Widget homeNavbar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              ).then((val) => val ? _checkName() : null);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24.0,
            ),
            tooltip: 'Settings',
          ),
          SizedBox(
            width: 24,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //       onPressed: () => {},
          //       icon: const Icon(
          //         Icons.search,
          //         color: Colors.white,
          //         size: 24.0,
          //       ),
          //       tooltip: 'Search',
          //     ),
          //     const SizedBox(
          //       width: 23,
          //     ),
          //     IconButton(
          //       onPressed: () => {},
          //       icon: const Icon(
          //         Icons.notifications_none,
          //         color: Colors.white,
          //         size: 24.0,
          //       ),
          //       tooltip: 'Notification',
          //     ),
          //   ],
          // ),
        ],
      );

  Widget _category(BuildContext context) {
    return ValueListenableBuilder<Box<Todo>>(
      valueListenable: Boxes.getTodos().listenable(),
      builder: (context, box, _) {
        final todos = box.values.toList().cast<Todo>();
        return todoBuilder(todos);
      },
    );
  }

  Widget categoryBuilder(List<Category> categories) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'No Category Here',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          final todoBox = Boxes.getTodos();
          final all = todoBox.values
              .where((element) => element.category == category.name);

          var checked = todoBox.values.where(
            (element) =>
                element.category == category.name && element.isComplete == true,
          );

          double complete = 0;
          if (all.length >= 1 && checked.length >= 1) {
            complete = checked.length / all.length;
          }
          return categoryList(context, category, complete, all.length, index);
        },
      );
    }
  }

  Widget categoryList(BuildContext context, Category category, double complete,
      int all, int index) {
    List color = category.colors;
    return Padding(
      padding: const EdgeInsets.only(left: 27),
      child: Container(
        width: 217,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 157, 157, 1),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${all.toString()} tasks",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  constraints: BoxConstraints(),
                  onPressed: () {
                    _deleteCategory(context, index);
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            Text(
              category.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            LinearProgressIndicator(
              value: complete,
              backgroundColor:
                  Color.fromRGBO(color[0], color[1], color[2], 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                (Color.fromRGBO(color[0], color[1], color[2], 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget todoBuilder(List<Todo> todos) {
    if (todos.isEmpty) {
      return const Center(
        child: Text(
          'No Todo here lets create one!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todos[index];
            final getCategory = Boxes.getCategory();
            final category = getCategory.values
                .where((element) => element.name == todo.category)
                .first;

            return todoList(context, todo, category, index);
          },
        ),
      );
    }
  }

  Widget todoList(
      BuildContext context, Todo todo, Category category, int index) {
    List color = category.colors;
    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 27, right: 27, bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 17),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color.fromRGBO(255, 119, 119, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                todo.isComplete
                    ? IconButton(
                        onPressed: () => {
                          updateCheck(todo, false, index),
                        },
                        icon: Icon(
                          Icons.check_circle_outline_rounded,
                          color:
                              Color.fromRGBO(color[0], color[1], color[2], 1),
                          size: 24,
                        ),
                      )
                    : IconButton(
                        onPressed: () => {updateCheck(todo, true, index)},
                        icon: Icon(
                          Icons.brightness_1_outlined,
                          color:
                              Color.fromRGBO(color[0], color[1], color[2], 1),
                          size: 24,
                        ),
                      ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        todo.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        todo.note,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => {
              deleteTodo(todo.key),
            },
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }

  updateCheck(Todo todo, bool isComplete, int index) {
    final box = Boxes.getTodos();
    Todo newTodo = Todo(todo.title, todo.note, todo.category, isComplete);
    box.putAt(index, newTodo);
    setState(() {});
  }

  Future addTodo(String title, String note, String category) async {
    final todo = Todo(title, note, category, false);

    final todoBox = Boxes.getTodos();
    todoBox.add(todo);
  }

  deleteTodo(int todoKey) {
    final box = Boxes.getTodos();
    box.delete(todoKey);
    setState(() {});
  }

  Future addCategory(String name, List colors) async {
    Category category = Category()
      ..name = name
      ..colors = colors;

    final categoryBox = Boxes.getCategory();
    categoryBox.add(category);
  }

  _deleteCategory(BuildContext context, int categoryIndex) {
    final categoryBox = Boxes.getCategory();
    var todoBox = Boxes.getTodos();
    var category = categoryBox.getAt(categoryIndex);
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        var deletedTodo = todoBox.values
            .where((element) => element.category == category?.name)
            .toList();
        for (var item in deletedTodo) {
          item.delete();
        }
        categoryBox.deleteAt(categoryIndex);
        setState(() {});
        Navigator.pop(context);
      },
      child: const Text('Delete'),
    );
    Widget cancleButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancle'),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete ${category?.name} category?"),
      content: Text(
          "This action also removes all data in it. This action cannot be canceled."),
      actions: [
        cancleButton,
        okButton,
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
