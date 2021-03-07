import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:micelio/screens/map.dart';
import 'package:micelio/utils/button.dart';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: screenSize.height * 0.65,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF81007F), Color(0xFF4A5BAD)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/car.png'),
                    Text(
                      "~LOGIN~",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(primaryColor: Colors.deepPurple),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide an email';
                            }
                          },
                          decoration: InputDecoration(labelText: 'Email'),
                          onSaved: (input) => _email = input,
                        ),
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
                    ],
                  )),
            ),
            SizedBox(height: screenSize.height * 0.02),
            RaisedGradientButton(
                color: Colors.white,
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF4A5BAD),
                    Color(0xFF81007F),
                    Color(0xFF4A5BAD)
                  ],
                ),
                onPressed: () => login()),
          ],
        ),
      ),
    );
  }

  Future<void> login() async{
  if (!mounted) return;
    await Firebase.initializeApp();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      ShowAlert()
          .showAlertDialog(context, "Loading...", "Please wait");
      try {
        final User user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        print("Inside try ${user.email} ");
        if (user != null) {
            Constants.prefs.setBool("loggedIn", true);
          Navigator.pushReplacementNamed(context, '/map');
        } else {}
      } catch (e) {
        print("Inside catch ${e.message}");
        ShowAlert()
            .showAlertDialog(context, "Error!", "Invalid user credentials");
      }
    }
  }
}
