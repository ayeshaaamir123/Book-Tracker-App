import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/util/util.dart';
import 'package:book_tracker/widgets/form_input_decoration.dart';
import 'package:book_tracker/widgets/update_user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget createProfileDialog(BuildContext context, MUser curUser, int booksRead,
    List<dynamic> userBooksReadList) {
  final TextEditingController _displayNameTextController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController _professionTextController =
      TextEditingController(text: curUser.profession);
  final TextEditingController _quoteTextController =
      TextEditingController(text: curUser.quote);
  final TextEditingController _avatarTextController =
      TextEditingController(text: curUser.avatarUrl);
  return AlertDialog(
    content: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(curUser.avatarUrl == null
                    ? 'https://picsum.photos/200/300'
                    : curUser.avatarUrl.toString()),
                radius: 50,
              )
            ],
          ),
          Text('Books Read (${userBooksReadList.length})',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  curUser.displayName.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return UpdateUserProfile(
                            user: curUser,
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.mode_edit,
                    color: Colors.black,
                  ),
                  label: const Text('')),
            ],
          ),
          Text(
            curUser.profession.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(color: Colors.red),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.blueGrey),
                color: HexColor('#f1f3f6'),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                const Text(
                  'Favourite Quote:',
                  style: TextStyle(color: Colors.black),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "\"${curUser.quote}\"",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              ]),
            ),
          ),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: userBooksReadList.length,
                itemBuilder: ((context, index) {
                  Book book = userBooksReadList[index];
                  return Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            book.title,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(book.photoUrl),
                            radius: 35,
                          ),
                          subtitle: Text(book.author),
                        ),
                        Text(
                            'Finished on: ${formatDate(book.startedReading as Timestamp)}')
                      ],
                    ),
                  );
                })),
          ))
        ],
      ),
    ),
  );
}
