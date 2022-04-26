import 'package:book_tracker/model/user.dart';
import 'package:book_tracker/widgets/form_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key? key,
    required this.user,
  }) : super(key: key);
  final MUser user;

  @override
  Widget build(BuildContext context) {
    // TextEditingController _displayNameTextController = TextEditingController(text:user.displayName),
    // TextEditingController _professionTextController,
    // TextEditingController _quoteTextController,
    // TextEditingController _avatarTextController,
    TextEditingController _displayNameTextController =
        TextEditingController(text: this.user.displayName);
    TextEditingController _professionTextController =
        TextEditingController(text: this.user.profession);
    TextEditingController _quoteTextController =
        TextEditingController(text: this.user.quote);
    TextEditingController _avatarTextController =
        TextEditingController(text: this.user.avatarUrl);
    return AlertDialog(
      title: Center(child: Text('Edit ${user.displayName}')),
      content: Form(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(user.avatarUrl == null
                    ? 'https://picsum.photos/200/300'
                    : user.avatarUrl.toString()),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _displayNameTextController,
                decoration: formInputDecoration('Your Name', ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _professionTextController,
                decoration: formInputDecoration('Profession', ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _quoteTextController,
                decoration: formInputDecoration('Quote', ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _avatarTextController,
                decoration: formInputDecoration('Avatar Url', ''),
              ),
            ),
          ],
        ),
      )),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                final userChangedName =
                    user.displayName != _displayNameTextController.text;
                final userChangedAvatar =
                    user.avatarUrl != _avatarTextController.text;
                final userChangedQuote =
                    user.quote != _quoteTextController.text;
                final userChangedProfession =
                    user.profession != _professionTextController.text;
                final userNeedUpdate = userChangedName ||
                    userChangedProfession ||
                    userChangedQuote ||
                    userChangedAvatar;
                if (userNeedUpdate) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.id)
                      .update(MUser(
                        uid: user.uid,
                        displayName: _displayNameTextController.text,
                        avatarUrl: _avatarTextController.text,
                        profession: _professionTextController.text,
                        quote: _quoteTextController.text,
                      ).toMap());
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
        )
      ],
    );
  }
}
