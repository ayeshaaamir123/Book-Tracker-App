import 'package:book_tracker/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchBookDetailDialog extends StatelessWidget {
  const SearchBookDetailDialog({
    Key? key,
    required this.book,
    required CollectionReference<Map<String, dynamic>> bookCollectionReference,
  })  : _bookCollectionReference = bookCollectionReference,
        super(key: key);

  final Book book;
  final CollectionReference<Map<String, dynamic>> _bookCollectionReference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(book.photoUrl),
              radius: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Categories: ${book.categories}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Page Count: ${book.pageCount}',
            ),
          ),
          Text('Author: ${book.author}'),
          Text('Published Date: ${book.publishedDate}'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              width: 600,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    book.description,
                    style: TextStyle(wordSpacing: 0.9, letterSpacing: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
              onPressed: () {
                _bookCollectionReference.add(Book(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  title: book.title,
                  author: book.author,
                  photoUrl: book.photoUrl,
                  publishedDate: book.publishedDate,
                  pageCount: book.pageCount,
                  categories: book.categories,
                  description: book.description,
                ).toMap());
                Navigator.of(context).pop();
              },
              child: Text('Save')),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
        )
      ],
    );
  }
}
