import 'package:app_data_siswa/screen/home_screen.dart';

import 'package:app_data_siswa/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 31),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Sekolah Bisa',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Silakan Isi Email Dan Passowrd Sesuai Yang Anda InginKan Contoh Email Pahrizal@480@gmail.com Jika Belum ada Akun Silakan Register",
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            controller: model.emailController,
                            hintText: "Email",
                            iconData: Icons.email,
                          ),
                          if (model.authType == AuthType.signUp)
                            CustomTextField(
                              controller: model.userNameController,
                              hintText: "User name",
                              iconData: Icons.person,
                            ),
                          CustomTextField(
                            controller: model.passwordController,
                            hintText: "Password",
                            iconData: Icons.key,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              model.resetPassword(context);
                            },
                            child: const Center(
                              child: Text(
                                'Forgot Password',
                              ),
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          SizedBox(
                            height: 20,
                          ),

                          CostumeButtons(
                            onPressed: () {
                              model.authenticate();
                            },
                            title: model.authType == AuthType.signUp
                                ? 'Register'
                                : 'Login',
                            colorBg: model.authType == AuthType.signUp
                                ? Colors.grey
                                : Colors.deepPurple,
                          ),
                          Center(
                            child: TextButton(
                                onPressed: () {
                                  model.setAuthType();
                                },
                                child: model.authType == AuthType.signUp
                                    ? const Text(
                                        "Already have an account",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Text(
                                        "Create an account",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                        ),
                                      )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const HomeScreen();
            }
          });
    });
  }
}
