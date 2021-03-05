import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:micelio/utils/showAlert.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.9,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide an email';
                            }
                          },
                          decoration: InputDecoration(labelText: 'Email'),
                          onSaved: (input) => _email = input,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Longer password please';
                            }
                          },
                          decoration: InputDecoration(labelText: 'Password'),
                          onSaved: (input) => _password = input,
                          obscureText: true,
                        ),
                        RaisedButton(
                          onPressed: signUp,
                          highlightColor: Colors.blue,

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.purpleAccent)
                          ),
                          child: Text("REGISTER", style: TextStyle(color: Colors.blue,),),
                        ),
                      ],
                    )),
              ),
            ),
            Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                child: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                )),
          ],
        ));
  }

  Future<void> signUp() async {
    await Firebase.initializeApp();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email, password: _password)).user;
        // user.sendEmailVerification();
        // print(" Inside try Register Page${user}");
        ShowAlert().showAlertDialog(context, "Success", "Registered successfully, You can login now...");
      } catch (e) {
        print(" Inside catch Register Page${e.message}");
      }
    }
  }
}
