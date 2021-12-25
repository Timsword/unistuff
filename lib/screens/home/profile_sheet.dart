import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:unistuff_main/models/myuser.dart';

class profileSheet extends StatefulWidget {
  const profileSheet({Key? key}) : super(key: key);

  @override
  _profileSheetState createState() => _profileSheetState();
}

class _profileSheetState extends State<profileSheet> {
  final _formkey = GlobalKey<FormState>();

  //funcs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("asdas"),
    );
  }
}
