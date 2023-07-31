import 'dart:convert';

import 'package:app_data_siswa/screen/add_new_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class UserTile extends StatefulWidget {
  final Siswa user;
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.user.name,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          "${widget.user.email},\n${widget.user.phoneNumber}\n${widget.user.alamat}",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddNewUserScreen(
                        user: widget.user,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.deepPurple,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final response = await http.delete(Uri.parse(
                      'https://crud-firebase-4b524-default-rtdb.asia-southeast1.firebasedatabase.app/users/${widget.user.docId}.json'));
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Data Sudah Di Hapus'),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(jsonDecode(response.body)["error"]),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
