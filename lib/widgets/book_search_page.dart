import 'dart:convert';

import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/widgets/form_input_decoration.dart';
import 'package:book_tracker/widgets/searched_book_detail_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class BookSearchPage extends StatefulWidget {
  BookSearchPage({Key? key}) : super(key: key);

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  late List<Book> listOfBooks = [];
  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    listOfBooks = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Book Search'),
        backgroundColor: Colors.redAccent,
      ),
      body: Material(
          elevation: 0.0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(right: 20, left: 40),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      child: TextField(
                    onSubmitted: (value) {
                      _search();
                    },
                    controller: _searchTextController,
                    decoration:
                        formInputDecoration('Search', 'Flutter Development'),
                  )),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              (listOfBooks.isNotEmpty)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SizedBox(
                                width: 300,
                                height: 270,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children:
                                      createBookCards(listOfBooks, context),
                                ))),
                      ],
                    )
                  : Center(
                      child: Text(''),
                    )
            ]),
          )),
    );
  }

  void _search() async {
    await fetchBooks(_searchTextController.text).then((value) {
      setState(() {
        listOfBooks = value;
      });
    }, onError: (val) {
      throw Exception('failed to load books ${val.toString()} ');
    });
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];
    http.Response response = await http
        .get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      // parsing through the api
      // {items: [volumeInfo: {title:}]}
      final Iterable list = body['items'];
      for (var item in list) {
        String title = item['volumeInfo']['title'] ?? 'N/A';
        String author = item['volumeInfo']['authors'][0] ?? 'N/A';
        String publishedDate = item['volumeInfo']['publishedDate'] ?? 'N/A';
        int pageCount = item['volumeInfo']['pageCount'] ?? 0;
        String categories = item['volumeInfo']['categories'][0] ?? 'N/A';
        String thumbnail = item['volumeInfo']['imageLinks']['thumbnail'] ?? '';
        String description = item['volumeInfo']['description'] ?? 'N/A';
        Book searchedBook = Book(
            title: title,
            author: author,
            categories: categories,
            publishedDate: publishedDate,
            pageCount: pageCount,
            photoUrl: thumbnail,
            description: description);
        books.add(searchedBook);
      }

      return books;
    } else {
      throw ('error ${response.reasonPhrase}');
    }
  }

  List<Widget> createBookCards(List<Book> books, BuildContext context) {
    List<Widget> children = [];
    final _bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    for (var book in books) {
      children.add(Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Card(
          elevation: 5,
          color: HexColor('#f6f4ff'),
          child: Wrap(
            children: [
              Image.network(
                book.photoUrl.isEmpty
                    ? 'https://picsum.photos/200/300'
                    : book.photoUrl,
                width: 100,
                height: 160,
              ),
              ListTile(
                title: Text(
                  book.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: HexColor('#5d48b6')),
                ),
                subtitle: Text(book.author),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SearchBookDetailDialog(
                            book: book,
                            bookCollectionReference: _bookCollectionReference);
                      });
                },
              )
            ],
          ),
        ),
      ));
    }
    return children;
  }
}
