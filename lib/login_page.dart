import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  String _errorMessage = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Form is valid. Email : $_email and Password: $_password. ");
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print("Signed in : $userId");
          setState(() {
            _errorMessage ="";
          });
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print("Registered user : $userId");
          setState(() {
            _errorMessage ="";
          });
        }
        widget.onSignedIn();
      } catch (error) {
        String errorText = error.toString();
        print("Error is $error");
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            print(_errorMessage);
            setState(() {
              _errorMessage = error.message ;
            });
            break;
          case "ERROR_WEAK_PASSWORD":
            print(_errorMessage);
            setState(() {
              _errorMessage = error.message;
            });
            break;
          case "ERROR_INVALID_EMAIL":
            print(_errorMessage);
            setState(() {
              _errorMessage = error.message;
            });
            break;
            break;
          default:
            print("Error of defoult : $errorText ");
        }
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Scout Manager"),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              children: [
                new Card(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.all(16.0),
                        child: new Form(
                          key: formKey,
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: showLogo() +
                                  showErrorMessage()+
                                  buildInputs() +
                                  buildSubmitButtons()

                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email is required' : null,
        onSaved: (value) => _email = value,
        ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password is required' : null,
        onSaved: (value) => _password = value,
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Create an account',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text("Create and Enter an account",
              style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Have an account ? Login',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        )
      ];
    }
  }

  List<Widget> showLogo() {
    return [
      new Hero(
          tag: 'hero',
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child: Image.asset('assets/appLogo.png'),
            ),
          )),
    ];
  }

  List<Widget> showErrorMessage(){
    return [
      new Text(
        _errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0,color: Colors.red ),
      )
    ];
  }
}
