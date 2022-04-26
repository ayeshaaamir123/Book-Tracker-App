import 'package:book_tracker/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUser(String displayName, BuildContext context) async {
  final userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid;
  MUser user = MUser(displayName: displayName, uid: uid);
  // Map<String, dynamic> user = {
  //   'avatar_url': "https://picsum.photos/200/300",
  //   'profession': 'teacher',
  //   'quote': 'Life is greta',
  //   'display_name': displayName,
  //   'uid': uid
  // };
  userCollectionReference.add(user.toMap());
  return;
}
