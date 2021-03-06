import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pumba_task/app/presentation/state/auth_service.dart';
import 'package:pumba_task/app/presentation/state/permission_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'app/presentation/screens/home_screen.dart';
import 'app/presentation/screens/register_screen.dart';
import 'app/presentation/state/sign_in_form.dart';
import 'core/utils/notification_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationUtils().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => PermissionsService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _authBuilder(context),
    );
  }

  FutureBuilder<auth.User> _authBuilder(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return FutureBuilder<auth.User>(
      future: authService.getUser(),
      builder: (context, AsyncSnapshot<auth.User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // log error to console
          if (snapshot.error != null) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                "${snapshot.error}",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          return snapshot.hasData
              ? HomeScreen()
              : ChangeNotifierProvider<SignInForm>(
                  create: (_) => SignInForm(),
                  child: RegisterScreen(),
                );
        }
        // show loading indicator
        else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
