import 'package:classroom/app_navigation_controller.dart';
import 'package:classroom/blocs/auth_bloc.dart';
import 'package:classroom/blocs/navigation_bloc.dart';
import 'package:classroom/blocs/user_bloc.dart';
import 'package:classroom/firebase_options.dart';
import 'package:classroom/screens/onboarding/onboarding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Initialising firebase app
  ///so that all firebase services can be used
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  enableEdgeToEdge();

  runApp(
    ClassroomApp(),
  );
}

void enableEdgeToEdge({bool enable = true}) {
  ///Necessary for edge to edge
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class ClassroomApp extends StatelessWidget {
  ClassroomApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///Root Level Provider for Authentication logics
        ChangeNotifierProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),

        ///Root Level Provider for User management
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(navigatorKey),
        ),

        ///Root Level Provider for navigation
        ChangeNotifierProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Classroom',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const RedirectionPage(),
      ),
    );
  }
}

/// Redirection class based on login check
class RedirectionPage extends StatelessWidget {
  const RedirectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context);

    /// Checks login status and handles redirection accordingly
    return FutureBuilder(
      future: ab.checkSignIn(context),
      builder: (context, AsyncSnapshot<bool> snap) {
        return snap.data == null
            ? Container() //Replace with splash
            : snap.data!
                ? const AppNavigationController()
                : const OnboardingPage();
      },
    );
  }
}
