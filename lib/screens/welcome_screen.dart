import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/auth_provider/auth_provider.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/screens/login_screen.dart';
import 'package:todo_list/widgets/categories.dart';
import 'package:todo_list/widgets/task_list.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isDrawerOpen = false;

  void openDrawer() {
    setState(() {
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,

      // backgroundColor: ,
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            child: CustomDrawer(closeDrawer: closeDrawer),
          ),
          // AnimatedContainer(),
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            transform: Matrix4.identity()
              ..scale(isDrawerOpen ? 0.8 : 1.0)
              ..translate(
                isDrawerOpen ? MediaQuery.of(context).size.width : 0.0,
                isDrawerOpen ? MediaQuery.of(context).size.height * 0.15 : 0.0,
              ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 50 : 0),
              child: GestureDetector(
                  onTap: closeDrawer,
                  child: HomePage(changeDrawerState: openDrawer)),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback changeDrawerState;
  const HomePage({
    super.key,
    required this.changeDrawerState,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();
  List<TaskModel> myTasks = <TaskModel>[];
  void getTasks(String text) {
    TaskModel taskModel = TaskModel(data: text);
    taskModel.data = text;
    setState(() {
      myTasks.add(taskModel);
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // TaskModel taskModel;

    final ap = Provider.of<AuthProvider>(context);
    ap.getDataFromFireBase(context);

    String dropdownValue = 'Bussiness';
    List<String> options = ['Bussiness', 'Hobbies', 'Tech', 'Theme'];

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Builder(builder: (BuildContext context) {
                    return IconButton(
                      onPressed: () {
                        return widget.changeDrawerState();
                      },
                      icon: Icon(Icons.menu_rounded),
                    );
                  }),
                  const SizedBox(width: 15),
                  const Expanded(
                      child: Text(
                    "TODO APP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${ap.userModel.name}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  "Welcome Back!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16, color: Colors.white60),
                ),
                const SizedBox(height: 25),

                // ElevatedButton(onPressed: () {}, child: Text("BUTTONN"),style: ButtonStyle()),
                InkWell(
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Center(
                        child: Text(
                      "+ Create Project",
                      style: TextStyle(fontSize: 15),
                    )),
                  ),
                  onTap: () {
                    showBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        )),
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 30),
                                TextField(
                                  style: TextStyle(fontSize: 20),
                                  controller: textController,
                                  // focusNode: ,
                                  decoration: const InputDecoration(
                                      labelText: 'Create New Task',
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        // width: 2,
                                        color: Colors.white,
                                      )),
                                      // hintText: 'Create New Task',
                                      border: InputBorder.none),
                                  onSubmitted: (value) {
                                    getTasks(value);
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Select a Category",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 40),
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 223, 209, 248)),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurple,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      items: options
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 100),
                                SizedBox(
                                  height: 50,
                                  width: 100,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.deepPurple)),
                                      child: const Text(
                                        'Add Task',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        getTasks(textController.text);

                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 15),
                Categories(),
                const SizedBox(height: 40),
                TaskList(taskList: myTasks),
                // const SizedBox(height: 40),
                // BottomNavigationBar(items: BottomNavigationBarItem),
                // FloatingActionButton(
                //   backgroundColor: Colors.deepPurple,
                //   child: Icon(Icons.add, color: Colors.white),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final VoidCallback closeDrawer;
  const CustomDrawer({
    super.key,
    required this.closeDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    ap.getDataFromFireBase(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 100),
        Row(
          children: [
            Expanded(
              child: SizedBox(),
            ),
            IconButton(
              onPressed: () {
                return closeDrawer();
              },
              icon: Icon(Icons.arrow_back_ios_rounded),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 140,
            width: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://media.istockphoto.com/id/1210939712/vector/user-icon-people-icon-isolated-on-white-background-vector-illustration.jpg?s=612x612&w=0&k=20&c=vKDH9j7PPMN-AiUX8vsKlmOonwx7wjqdKiLge7PX1ZQ="),
                alignment: Alignment.center,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            ap.userModel.name,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            ListTile(
              title: Row(children: const [
                Icon(Icons.bookmark_outline_rounded),
                SizedBox(width: 30),
                Text(
                  'Templates',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              onTap: () {
                // Do something
              },
            ),
            ListTile(
              title: Row(children: const [
                Icon(Icons.category_outlined),
                SizedBox(width: 30),
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              onTap: () {
                // Do something
              },
            ),
            ListTile(
              title: Row(children: const [
                Icon(Icons.analytics_outlined),
                SizedBox(width: 30),
                Text(
                  'Analytics',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              onTap: () {
                // Do something
              },
            ),
            const SizedBox(height: 100),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() {
                  print("User Logged out");
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                });
              },
              child: Container(
                padding: EdgeInsets.all(20),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.logout,
                      size: 22,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "Log out",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
