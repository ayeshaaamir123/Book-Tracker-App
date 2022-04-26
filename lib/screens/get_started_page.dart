import 'package:flutter/material.dart';

import 'login_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: Colors.purple[50],
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Spacer(),
            Text(
              'Book Tracker',
              style: Theme.of(context).textTheme.headline3,
            ),
            // ignore: prefer_const_constructors
            Text(
              'Read and Change Yourself',
              style: const TextStyle(color: Colors.black26, fontSize: 29),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton.icon(
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.deepPurple[600],
                    textStyle: const TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                },
                icon: const Icon(Icons.login_rounded),
                label: const Text('Sign in to get started')),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
