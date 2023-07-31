import 'package:app_data_siswa/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../model/user.dart';
import 'package:http/http.dart' as http;

class AddNewUserScreen extends StatefulWidget {
  final Siswa? user;
  const AddNewUserScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;
  sendUserOnFirebase() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          "https://crud-firebase-4b524-default-rtdb.asia-southeast1.firebasedatabase.app/users.json"),
      body: jsonEncode({
        "name": nameController.text,
        "email": emailController.text,
        'alamat': alamatController.text,
        "phone_number": phoneNumberController.text,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      nameController = TextEditingController();
      emailController = TextEditingController();
      alamatController = TextEditingController();
      phoneNumberController = TextEditingController();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Data added",
        ),
        backgroundColor: Colors.green,
      ));
      print(jsonDecode(response.body));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }
    //send user

    setState(() {
      isLoading = false;
    });
    // print(response.id);
  }

  updateUser() async {
    final response = await http.patch(
        Uri.parse(
            'https://crud-firebase-4b524-default-rtdb.asia-southeast1.firebasedatabase.app/users/${widget.user!.docId}.json'),
        body: jsonEncode({
          "name": nameController.text,
          "email": emailController.text,
          "alamat": alamatController.text,
          "phone_number": phoneNumberController.text,
        }));
    if (response.statusCode == 200) {
      nameController = TextEditingController();
      emailController = TextEditingController();
      alamatController = TextEditingController();
      phoneNumberController = TextEditingController();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Data udah update",
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }
    print(response.body);
  }

  @override
  void initState() {
    if (widget.user != null) {
      nameController = TextEditingController(text: widget.user!.name);
      emailController = TextEditingController(text: widget.user!.email);
      alamatController = TextEditingController(text: widget.user!.alamat);
      phoneNumberController =
          TextEditingController(text: widget.user!.phoneNumber);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Tambah Siswa"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Tidak Boleh Kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Masukan Nama Lengkap",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                    fillColor: Colors.grey.shade200,
                    focusColor: Colors.deepPurple,
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Masukan Email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.deepPurple,
                    ),
                    fillColor: Colors.grey.shade200,
                    focusColor: Colors.deepPurple,
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: alamatController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Alamat';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Alamat",
                    hintText: "Alamat",
                    prefixIcon: const Icon(
                      Icons.home,
                      color: Colors.deepPurple,
                    ),
                    fillColor: Colors.grey.shade200,
                    focusColor: Colors.deepPurple,
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    } else if (value.length < 10) {
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Masukan Nomer",
                    hintText: "Masukan Nomer",
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.deepPurple,
                    ),
                    fillColor: Colors.grey.shade200,
                    focusColor: Colors.deepPurple,
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.user != null) {
                              print("edit user");

                              updateUser();
                            } else {
                              sendUserOnFirebase();
                            }
                          } else {}
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          widget.user != null ? "Edit user" : "Add user",
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
