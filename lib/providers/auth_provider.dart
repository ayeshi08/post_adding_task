import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_task/appStyle/appColor.dart';

import '../screen/home_screen.dart';


class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Sign-in with Email and Password
  Future<User?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      //return userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewHome()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in as ${user.email}', style: TextStyle(color: Colors.red),)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to sign in')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Password is wrong',
            style: TextStyle(color: AppColors.appMainColor),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'email is incorrect',
            style: TextStyle(color: AppColors.appMainColor),
          ),
          backgroundColor: Colors.black,
        ));
      }
    }
  }

  // Register new user with Email and Password
  Future<User?> registerWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      // return userCredential.user;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registered as ${user.email}')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to register')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Password is weak',
            style: TextStyle(color: AppColors.appMainColor),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Account already exist',
            style: TextStyle(color: AppColors.appMainColor),
          ),
          backgroundColor: Colors.black,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Account already exist',
          style: TextStyle(color: AppColors.appMainColor),
        ),
        backgroundColor: Colors.black,
      ));
    }
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}
