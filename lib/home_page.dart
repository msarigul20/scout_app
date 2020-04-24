import 'package:flutter/material.dart';
import 'package:scoutapp/auth.dart';
import 'auth.dart';

class HomePage extends StatelessWidget{
  HomePage({this.auth,this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut()async{
    try{
      await auth.signOut();
      onSignedOut();
    } catch(e){
      print(e);
    }
  }  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Scout App"),
        centerTitle: true,
        actions: <Widget>[
          new FlatButton(
              child: new Text("Logout",

                style: new TextStyle(
                    fontSize: 17.0 ,
                    color: Colors.white,

                )
              ),
            onPressed: _signOut,
          )
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Text("HELLO MANAGER", style: new TextStyle(fontSize: 32.0))
        ),
      )
    );
  }
}