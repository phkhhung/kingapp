import 'package:flutter/material.dart';
import 'package:kingapp/services/auth_service.dart';
import 'package:kingapp/screens/home_screen.dart';
import 'package:kingapp/screens/login_screen.dart';
import 'db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await AuthService.isLoggedIn();
  await MongoDatabase.connect(); //Kết nối MongoDB
  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KingApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
