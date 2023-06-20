import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/user_model.dart';
import 'package:todo_list/screens/welcome_screen.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  String? _uid;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  AuthProvider() {
    checkSignIn();
  }

  void saveDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    try {
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: userModel.email, password: userModel.password))
          .user;

      if (user != null) {
        _uid = user.uid;
      }

      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .whenComplete(() {
        print("New user Created");
        onSuccess();
        print("Homescreen khule jaoyar kotha");
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      notifyListeners();
    }
  }

  Future getDataFromFireBase(BuildContext context) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      try {
        await _firebaseFirestore
            .collection("users")
            .doc(_firebaseAuth.currentUser!.uid)
            .get()
            .then((DocumentSnapshot snapshot) {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            _userModel = UserModel(
              name: data['name'],
              email: data['email'],
              password: data['password'],
              createdAt: data['createdAt'],
              uid: data['uid'],
            );
            _uid = _userModel!.uid;
            notifyListeners();
          }
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }
  }

  void signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) {
        print("Signed in");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  Future saveDataToSP(UserModel userModel) async {
    print("Shared Preference shuru");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _userModel = userModel;
    await sharedPreferences.setString(
        "user_model", jsonEncode(userModel.toMap()));
    print("Shared Preference sesh");
  }

  Future setSignedIn() async {
    print("Before set signed in");
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("is_signed_in", true);
    _isSignedIn = true;
    print("After set signed in");
    notifyListeners();
  }

  Future<bool> checkSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool("is_signed_in") ?? false;
    return _isSignedIn;
  }
}
