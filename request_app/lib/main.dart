import 'package:flutter/material.dart';
import 'package:it_del/Auth/login_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(), // Your root widget
    );
  }
}
