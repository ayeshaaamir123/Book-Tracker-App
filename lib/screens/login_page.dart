import 'package:book_tracker/widgets/create_account_form.dart';
import 'package:book_tracker/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCreateAccountClicked = false;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.black54,
              )),
          Text(
            'Sign In',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              SizedBox(
                  height: 300,
                  width: 300,
                  child: isCreateAccountClicked != true
                      ? LoginForm(
                          formkey: _formkey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)
                      : CreateAccountForm(
                          formkey: _formkey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)),
              TextButton.icon(
                icon: Icon(Icons.portrait_rounded),
                label: Text(isCreateAccountClicked
                    ? 'Already Have An Account?'
                    : 'Create Account'),
                style: TextButton.styleFrom(primary: Colors.purple),
                onPressed: () {
                  setState(() {
                    if (!isCreateAccountClicked) {
                      isCreateAccountClicked = true;
                    } else {
                      isCreateAccountClicked = false;
                    }
                  });
                },
              )
            ],
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.black54,
              )),
        ],
      ),
    );
  }
}
