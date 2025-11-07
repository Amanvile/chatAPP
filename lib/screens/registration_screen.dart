import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id='/registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                  setState(() {
                    email=value;
                  });
        
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
                  setState(() {
                    password=value;
                  });
                  //Do something with the user input.
                },
                decoration: KTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.'
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              Button(
                label: 'Register',
        
                color: Colors.blueAccent,
                onPressed: () async {
                  // print('email : '+email);
                  // print('password : '+password);
                  setState(() {
                    showSpinner=true;
                  });

                try  {

                    UserCredential newUser = await _auth
                        .createUserWithEmailAndPassword(
                        email: email, password: password);
                    if(newUser.user !=null){
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showSpinner=false;
                      });

                      print('user created'+newUser.user!.email!);
                      print('user created'+newUser.user!.uid);
                    }
                  }
                   catch(e){
                  print(e.toString());
                  print('error');
                   }
        
                  //Implement registration functionality.
                },
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
