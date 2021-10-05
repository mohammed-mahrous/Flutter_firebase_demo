import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/utilities/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MyDrawer(screen: screen),
    );
  }
}
