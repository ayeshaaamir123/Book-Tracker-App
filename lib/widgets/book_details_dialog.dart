import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/screens/main_screen.dart';
import 'package:book_tracker/util/util.dart';
import 'package:book_tracker/widgets/form_input_decoration.dart';
import 'package:book_tracker/widgets/two_sided_rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetailsDialog extends StatefulWidget {
  const BookDetailsDialog({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  State<BookDetailsDialog> createState() => _BookDetailsDialogState();
}

class _BookDetailsDialogState extends State<BookDetailsDialog> {
  bool isReadingClicked = false;
  bool isFinishedReadingClicked = false;
  late TextEditingController _notesTextController;

  double? _rating;
  @override
  void initState() {
    _notesTextController = TextEditingController(text: widget.book.notes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _imageTextController =
        TextEditingController(text: widget.book.photoUrl);
    TextEditingController _titleTextController =
        TextEditingController(text: widget.book.title);
    TextEditingController _authorTextController =
        TextEditingController(text: widget.book.author);
    // TextEditingController _notesTextController =
    //     TextEditingController(text: widget.book.notes);
    return AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.book.photoUrl),
                radius: 50,
              ),
              const Spacer(),
              Container(
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("")),
              )
            ],
          ),
          Text(widget.book.author),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
      content: Form(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          TextFormField(
              controller: _titleTextController,
              decoration: formInputDecoration('Book title', '')),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              controller: _authorTextController,
              decoration: formInputDecoration('Author', '')),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              controller: _imageTextController,
              decoration: formInputDecoration('Book image link', '')),
          const SizedBox(
            height: 5,
          ),
          TextButton.icon(
              onPressed: widget.book.startedReading == null
                  ? () {
                      setState(() {
                        if (isReadingClicked == false) {
                          isReadingClicked = true;
                        } else {
                          isReadingClicked = false;
                        }
                      });
                    }
                  : null,
              icon: const Icon(Icons.book_sharp),
              label: (widget.book.startedReading == null)
                  ? !isReadingClicked
                      ? const Text('Start Reading')
                      : Text(
                          'Started Reading',
                          style: TextStyle(color: Colors.blueGrey[300]),
                        )
                  : Text(
                      'Started on : ${formatDate(widget.book.startedReading as Timestamp)}')),
          TextButton.icon(
              onPressed: widget.book.finishedReading == null
                  ? () {
                      setState(() {
                        if (isFinishedReadingClicked == false) {
                          isFinishedReadingClicked = true;
                        } else {
                          isFinishedReadingClicked = false;
                        }
                      });
                    }
                  : null,
              icon: const Icon(Icons.done),
              label: (widget.book.finishedReading == null)
                  ? (!isFinishedReadingClicked)
                      ? const Text('Mark as Read')
                      : const Text(
                          'Finished Reading!',
                          style: TextStyle(color: Colors.grey),
                        )
                  : Text(
                      'Finished on ${formatDate(widget.book.finishedReading as Timestamp)}')),
          const SizedBox(
            height: 5,
          ),
          RatingBar.builder(
              itemSize: 20,
              initialRating:
                  widget.book.rating != null ? widget.book.rating as double : 1,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return Container();
                }
              },
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              }),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              controller: _notesTextController,
              decoration: formInputDecoration('Your thoughts', '')),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // TwoSidedRoundedButton(
              //   text: 'Update',
              //   radius: 12,
              //   color: kIconColor,
              //   press: () {
              //     FirebaseFirestore.instance
              //         .collection('books')
              //         .doc(widget.book.id)
              //         .update(Book(
              //           userId: FirebaseAuth.instance.currentUser!.uid,
              //           title: _titleTextController.text,
              //           author: _authorTextController.text,
              //           notes: _notesTextController.text,
              //           photoUrl: _imageTextController.text,
              //           description: widget.book.description,
              //           pageCount: widget.book.pageCount,
              //           categories: widget.book.categories,
              //           publishedDate: widget.book.publishedDate,
              //           startedReading: isReadingClicked
              //               ? Timestamp.now()
              //               : widget.book.startedReading,
              //         ).toMap()
              //             // Book(
              //             //       userId: FirebaseAuth.instance.currentUser!.uid,
              //             //       title: _titleTextController.text,
              //             //       author: _authorTextController.text,
              //             //       photoUrl: _imageTextController.text,
              //             //       startedReading: isReadingClicked
              //             //           ? Timestamp.now()
              //             //           : widget.book.startedReading,
              //             //       //finishedReading: Timestamp.now(),
              //             //       notes: 'bleh',
              //             //       pageCount: widget.book.pageCount,
              //             //       categories: widget.book.categories,
              //             //       publishedDate: widget.book.publishedDate,
              //             //       description: widget.book.description)
              //             //   .toMap()
              //             );
              //   },
              // ),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('books')
                        .doc(widget.book.id)
                        .update(Book(
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          title: _titleTextController.text,
                          author: _authorTextController.text,
                          notes: _notesTextController.text,
                          photoUrl: _imageTextController.text,
                          description: widget.book.description,
                          pageCount: widget.book.pageCount,
                          categories: widget.book.categories,
                          publishedDate: widget.book.publishedDate,
                          rating: _rating ?? widget.book.rating,
                          finishedReading: isFinishedReadingClicked
                              ? Timestamp.now()
                              : widget.book.finishedReading,
                          startedReading: isReadingClicked
                              ? Timestamp.now()
                              : widget.book.startedReading,
                        ).toMap());

                    Navigator.of(context).pop();
                  },
                  child: const Text('Update')),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text(
                                'Once book is deleted you can\'t retrieve it back'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(widget.book.id)
                                        .delete();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MainScreenPage(),
                                        ));
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'))
                            ],
                          );
                        });
                  },
                  child: const Text('Delete'))
            ],
          ),
        ]),
      )),
    );
  }
}
