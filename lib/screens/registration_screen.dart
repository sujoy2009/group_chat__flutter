import 'package:flash_chat/components/buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id='regisscreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool progessbar=false;
  String email;
  String passward;
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: progessbar,
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
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {

                  //Do something with the user input.
                  email=value;
                },
                decoration: kinputdecoration.copyWith(hintText: 'Enter email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  passward=value;
                },
                decoration:kinputdecoration.copyWith(hintText:'inter a passward' ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Buttonwidget(text: 'Register',colur: Colors.lightBlueAccent,
                function: ()async{
                setState(() {
                  progessbar=true;
                });
                  try{ final newuser= await _auth.createUserWithEmailAndPassword(email: email, password: passward);
                     progessbar=false;
                     if(newuser!=null){
                       Navigator.pushNamed(context, ChatScreen.id);

                     }




                  }
                  catch(e){
                    print(e);

                  }


                  //Navigator.pushNamed(context, LoginScreen.id);
                }
                ,),
            ],
          ),
        ),
      ),
    );
  }
}
