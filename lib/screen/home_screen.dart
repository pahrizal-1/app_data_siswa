// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../model/user.dart';
// import '../provider/auth_provider.dart';
// import '../uses_tile.dart';
// import 'add_new_user_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void didChangeDependencies() {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     if (mounted) authProvider.updateEmailVerificationState();
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(builder: (context, model, _) {
//       return Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               onPressed: () {
//                 model.logOut();
//               },
//               icon: const Icon(Icons.logout),
//             )
//           ],
//         ),
//         body: Center(
//           child: model.emailVerified ?? false
//               ? Scaffold(
//                   floatingActionButton: FloatingActionButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => const AddNewUserScreen(),
//                         ),
//                       );
//                     },
//                     child: const Icon(Icons.add),
//                   ),
//                   body: StreamBuilder(
//                       stream: FirebaseFirestore.instance
//                           .collection("siswa")
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ListView.builder(
//                               itemBuilder: (context, index) {
//                                 Siswa user = Siswa(
//                                   docId: snapshot.data!.docs[index].id,
//                                   userName: snapshot.data!.docs[index]["name"],
//                                   email: snapshot.data!.docs[index]["email"],
//                                   phoneNumber: snapshot.data!.docs[index]
//                                       ["phone_number"],
//                                 );
//                                 return UserTile(user: user);
//                               },
//                               itemCount: snapshot.data!.docs.length,
//                             ),
//                           );
//                         } else {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                       }),
//                 )
//               : const Text("Anda Belum Verifikasi Email Anda"),
//         ),
//       );
//     });
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../provider/auth_provider.dart';
import '../siswa_tile.dart';
import 'add_new_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Siswa> _list = [];
  fetchUser() async {
    _list = [];
    // final response = await http.get(Uri.parse(
    //     "https://coursenet-ff3f1-default-rtdb.asia-southeast1.firebasedatabase.app/users.json"));

    final response = await http.get(Uri.parse(
        "https://crud-firebase-4b524-default-rtdb.asia-southeast1.firebasedatabase.app/users.json"));
    final extracteddata = jsonDecode(response.body) as Map<String, dynamic>;
    extracteddata.forEach((key, value) {
      _list.add(Siswa(
          email: value["email"],
          phoneNumber: value["phone_number"],
          alamat: value['alamat'],
          name: value["name"],
          docId: key));
    });

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    fetchUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(
              'Home Page',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  model.logOut();
                },
                icon: const Icon(Icons.logout),
              )
            ],
          ),
          body: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddNewUserScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                fetchUser();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return UserTile(
                      user: _list[index],
                    );
                  },
                  itemCount: _list.length,
                ),
              ),
            ),
          ));
    });
  }
}
