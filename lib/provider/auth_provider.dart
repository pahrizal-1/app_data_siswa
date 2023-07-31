import 'dart:async';
import 'package:app_data_siswa/key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custom_text_field.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  AuthType _authType = AuthType.signIn;
  AuthType get authType => _authType;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  setAuthType() {
    _authType =
        _authType == AuthType.signIn ? AuthType.signUp : AuthType.signIn;
    notifyListeners();
  }

  authenticate() async {
    UserCredential userCredential;
    try {
      if (_authType == AuthType.signUp) {
        userCredential = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        await userCredential.user!.sendEmailVerification();
        await firebaseFirestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "email": userCredential.user!.email,
          "uid": userCredential.user!.uid,
          "user_name": userNameController.text,
        });
      }
      if (_authType == AuthType.signIn) {
        userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        await firebaseFirestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .update({});
      }
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  bool? emailVerified;
  updateEmailVerificationState() async {
    emailVerified = firebaseAuth.currentUser!.emailVerified;

    if (!emailVerified!) {
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        await firebaseAuth.currentUser!.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          emailVerified = user.emailVerified;
          timer.cancel();
          notifyListeners();
        }
      });
    }
  }

  TextEditingController resetEmailController = TextEditingController();
  resetPassword(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Enter your email"),
            content: CustomTextField(
                iconData: Icons.email,
                hintText: "Enter email",
                controller: resetEmailController),
            actions: [
              TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context).pop();
                    try {
                      await firebaseAuth.sendPasswordResetEmail(
                          email: resetEmailController.text);
                      Keys.scaffoldMessengerKey.currentState!
                          .showSnackBar(const SnackBar(
                        content: Text("Email send successfully"),
                        backgroundColor: Colors.green,
                      ));
                      navigator;
                    } catch (e) {
                      Keys.scaffoldMessengerKey.currentState!
                          .showSnackBar(SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ));
                      navigator;
                    }
                  },
                  child: const Text("Submit"))
            ],
          );
        });
  }

  //logout starts here
  logOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(error.toString()), backgroundColor: Colors.red));
    }
  }
  //logout ends here
}

enum AuthType {
  signUp,
  signIn,
}
