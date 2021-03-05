import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:micelio/utils/constants.dart';
import 'package:micelio/utils/showAlert.dart';
FirebaseAuth auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child:
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (input) {
                        if(input.isEmpty){
                          return 'Provide an email';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Email'
                      ),
                      onSaved: (input) => _email = input,
                    ),
                    TextFormField(
                      validator: (input) {
                        if(input.length < 6){
                          return 'Longer password please';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Password'
                      ),
                      onSaved: (input) => _password = input,
                      obscureText: true,
                    ),
                    RaisedButton(
                      onPressed: signIn,
                      child: Text('Sign in'),
                    ),
                  ],
                )
            ),
          ),
        ),
        Positioned(
            left: 0.0,
            top: 0.0,
            right: 0.0,
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            )
        ),
      ],
    ));
  }

  Future<void> signIn() async {
    await Firebase.initializeApp();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        final User user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)).user;
        print("Inside try ${user.email} ");
        if(user!=null){
          print("Line 88");
          Constants.prefs.setBool("loggedIn", true);
          Navigator.pushReplacementNamed(context, '/map');
        }else{}
      } catch (e) {
        print("Inside catch ${e.message}");
        ShowAlert().showAlertDialog(context, "Error!", "Invalid user credentials");
      }
    }
  }
}
