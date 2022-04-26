import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/screens/main_screen.dart';
import 'package:book_tracker/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:book_tracker/screens/get_started_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          initialData: null,
          create: (context) => FirebaseAuth.instance.authStateChanges(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
        title: 'Book Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const GetStartedPage(),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => const GetStartedPage(),
        //   'main': (context) => const MainScreenPage(),
        //   'login': (context) => const LoginPage()
        // },
        initialRoute: '/',
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return const PageNotFound();
          });
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingName: settings.name);
            },
          );
        },
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  const RouteController({Key? key, this.settingName}) : super(key: key);
  final String? settingName;
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    final notSignedIngotoMain = !userSignedIn &&
        settingName ==
            '/main'; //not signed in user trying to go to the main page
    final signedInGotoMain = userSignedIn && settingName == '/main';

    if (settingName == '/') {
      return const GetStartedPage();
    } else if (settingName == '/login' || notSignedIngotoMain) {
      return const LoginPage();
    } else if (signedInGotoMain) {
      return const MainScreenPage();
    } else {
      return const PageNotFound();
    }
  }
}
