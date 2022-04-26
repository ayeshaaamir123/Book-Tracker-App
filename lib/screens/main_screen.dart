//api key = AIzaSyD8LeGEm13IM67iyBWcse8chRFlyrQB_JI

import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/widgets/book_details_dialog.dart';
import 'package:book_tracker/widgets/book_search_page.dart';
import 'package:book_tracker/widgets/reading_list_card.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/create_profile.dart';

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authUser = Provider.of<User>(context);

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    List<dynamic> userBooksReadList = [];
    int booksRead = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Row(children: [
          Image.asset(
            'assets/icons/Icon-76.png',
            scale: 2,
          ),
          Text(
            'A.Reader',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ]),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: usersCollection.snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final userListStream = snapshot.data!.docs.map((user) {
                return MUser.fromDocument(user);
              }).where((user) {
                return (user.uid == authUser.uid);
              }); //[user]

              MUser curUser = userListStream.elementAt(0);

              // to get snapshot of a single field
              // Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

              return Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: InkWell(
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage('https://picsum.photos/200/300'),
                          backgroundColor: Colors.white,
                          child: Text(""),
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return createProfileDialog(context, curUser,
                                    booksRead, userBooksReadList);
                              });
                        },
                      ),
                    ),
                    Text(
                      curUser.displayName.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black),
                    )
                  ]);
            },
          ),
          TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text(""))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSearchPage(),
              ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, top: 5),
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 20),
                        children: const [
                      TextSpan(text: 'Your reading\n activity'),
                      TextSpan(
                          text: ' right now...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ))
                    ])),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: bookCollectionReference.snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  var userBookFilteredReadListStream =
                      snapshot.data!.docs.map((book) {
                    return Book.fromDocument(book);
                  }).where((book) {
                    return (book.userId == authUser.uid) &&
                        (book.finishedReading == null) &&
                        (book.startedReading != null);
                  }).toList();

                  userBooksReadList = snapshot.data.docs.map((book) {
                    return Book.fromDocument(book);
                  }).where((book) {
                    return (book.userId == authUser.uid) &&
                        (book.finishedReading != null) &&
                        (book.startedReading != null);
                  }).toList();
                  booksRead = userBooksReadList.length;
                  return Flexible(
                    flex: 1,
                    child: (userBookFilteredReadListStream.length > 0)
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: userBookFilteredReadListStream.length,
                            itemBuilder: (context, index) {
                              Book book = userBookFilteredReadListStream[index];
                              return InkWell(
                                child: ReadingListCard(
                                    rating: book.rating ?? 4.0,
                                    buttonText: 'Reading',
                                    title: book.title,
                                    author: book.author,
                                    image: book.photoUrl),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BookDetailsDialog(
                                          book: book,
                                        );
                                      });
                                },
                              );
                              // return Container(
                              //   height: 200,
                              //   width: 159,
                              //   child: Card(
                              //     child: ListTile(
                              //       title: Text('hello'),
                              //     ),
                              //   ),
                              // );
                            },
                          )
                        : const Center(
                            child: Text('You haven\'t started reading',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                  );
                },
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: 'Reading List',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.redAccent))
                      ])),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: bookCollectionReference.snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    var readingListBook = snapshot.data!.docs.map(
                      (book) {
                        return Book.fromDocument(book);
                      },
                    ).where((book) {
                      return (book.userId == authUser.uid) &&
                          (book.finishedReading == null) &&
                          (book.startedReading == null);
                    }).toList();
                    return Flexible(
                        flex: 1,
                        child: (readingListBook.length > 0
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: readingListBook.length,
                                itemBuilder: (context, index) {
                                  Book book = readingListBook[index];
                                  return InkWell(
                                    onTap: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            BookDetailsDialog(book: book)),
                                    child: ReadingListCard(
                                      buttonText: 'Not Started',
                                      rating: book.rating ?? 4.0,
                                      author: book.author,
                                      image: book.photoUrl,
                                      title: book.title,
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                'No book found.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ))));
                  })
            ],
          ),
        )
      ]),
    );
  }
}
