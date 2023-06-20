import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/auth_provider/auth_provider.dart';
import 'package:todo_list/models/user_model.dart';
import 'package:todo_list/screens/welcome_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool selected = false;

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Screen'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      controller: _nameTextController,
                      decoration: const InputDecoration(
                        label: Text("Enter Name"),
                        icon: Icon(Icons.account_box_rounded),
                      )),
                  TextField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        label: Text("Enter Email"),
                        fillColor: Colors.blue,
                        icon: Icon(Icons.email_rounded)),
                  ),
                  TextField(
                    controller: _passwordTextController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                        label: Text("Enter Password"),
                        fillColor: Colors.blue,
                        icon: Icon(Icons.lock)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
            onPressed: () {
              signUp();
            },
            child: const Text(
              "SignUp",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void signUp() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    DateTime time = DateTime.now();
    UserModel userModel = UserModel(
      name: _nameTextController.text.trim(),
      email: _emailTextController.text.trim(),
      password: _passwordTextController.text.trim(),
      createdAt: "${time.hour}:${time.minute}:${time.second}",
      uid: "",
    );

    ap.saveDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () async {
        //1. Save the data to SharedPreferences,
        await ap.saveDataToSP(userModel).then((value) async => await ap
            .setSignedIn()
            .then((val) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()))));
        //2. Set the signedIn to Yes Signed in.
        //3. Move to the HomeScreen.
      },
    );
  }
}
