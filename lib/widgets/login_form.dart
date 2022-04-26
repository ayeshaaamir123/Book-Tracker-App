import 'package:book_tracker/screens/main_screen.dart';
import 'package:book_tracker/widgets/form_input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required GlobalKey<FormState> formkey,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
  })  : _formkey = formkey,
        _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        super(key: key);

  final GlobalKey<FormState> _formkey;
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (String? value) {
                return value!.isEmpty ? 'Please Enter an Email' : null;
              },
              controller: _emailTextController,
              decoration: formInputDecoration('Enter Email', 'john@email.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (String? value) {
                return value!.isEmpty ? 'Please enter a password' : null;
              },
              obscureText: true,
              controller: _passwordTextController,
              decoration: formInputDecoration('Enter Password', 'password123'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  backgroundColor: Colors.amber,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreenPage(),
                        ));
                  }).catchError((onError) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Oops!'),
                            content: Text('${onError.message}'),
                          );
                        });
                  });
                }
              },
              child: const Text('Sign In'))
        ],
      ),
    );
  }
}
