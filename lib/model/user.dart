import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String uid;
  final String displayName;
  final String? quote;
  final String? profession;
  final String? avatarUrl;

  MUser(
      {this.id,
      required this.uid,
      required this.displayName,
      this.quote,
      this.profession,
      this.avatarUrl});

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    // to make data.data() into a Map object so we can use indexing

    return MUser(
      id: data.id,
      uid: data.get('uid') as String,
      displayName: data.get('display_name') as String,
      avatarUrl: data.get('avatar_url'),
      profession: data.get('profession'),
      quote: data.get('quote'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'quote': quote,
      'profession': profession,
      'avatar_url': avatarUrl,
    };
  }
}
