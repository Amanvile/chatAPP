import 'package:flutter/material.dart';
import '../components/button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class LoginScreen extends StatefulWidget {
  static String id='/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardAppearance:Brightness.dark,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email=value;
                  //Do something with the user input.
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Enter your email.'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,


                onChanged: (value) {
                  password=value;
                  //Do something with the user input.
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Enter your password.'
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              Button(label: 'Log In', color: Colors.lightBlueAccent, onPressed: () async {
                setState(() {
                  showSpinner=true;
                });
                try  {
                  UserCredential newUser = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser.user !=null){
                    Navigator.pushNamed(context, ChatScreen.id);
                    // print('user created'+newUser.user!.email!);
                    // print('user created'+newUser.user!.uid);
                    setState(() {
                      showSpinner=false;
                    });
                  }
                }
                catch(e){
                  print(e.toString());
                  print('error');
                }

                //Implement login functionality.
              },)

            ],
          ),
        ),
      ),
    );
  }
}
