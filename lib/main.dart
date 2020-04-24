import "package:flutter/material.dart";
import 'package:scoutapp/auth.dart';
import 'auth.dart';
import 'root_page.dart';
void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:  "Scout App",
      theme: new ThemeData(
          primarySwatch: Colors.green,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}