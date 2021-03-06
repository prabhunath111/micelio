import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:micelio/utils/button.dart';
import 'package:micelio/utils/showAlert.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

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
                      "~REGISTER~",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                            primaryColor: Colors.deepPurple
                          ),
                          child: TextFormField(
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
                        ),
                        Theme(
                          data: ThemeData(
                            primaryColor: Colors.deepPurple
                          ),
                          child: TextFormField(
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
                        ),
                      ],
                    )
                ),
              ),
            ),
            SizedBox(height: screenSize.height*0.02),
            RaisedGradientButton(
                color: Colors.white,
                child: Text(
                  'REGISTER',
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
                onPressed: () => signUp()
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    await Firebase.initializeApp();
    if (!mounted) return;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email, password: _password)).user;
        // user.sendEmailVerification();
        // print(" Inside try Register Page${user}");
        ShowAlert().showAlertDialog(context, "Loading...", "Please wait...");
        ShowAlert().showAlertDialog(context, "Success", "Registered successfully, You can login now...");
      } catch (e) {
        print(" Inside catch Register Page ${e.message}");
        Fluttertoast.showToast(
            msg: "Email already exist",
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }
    }
  }
}
