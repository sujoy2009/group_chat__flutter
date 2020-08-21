import 'package:flash_chat/components/buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static const String id='loginscreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final _auth=FirebaseAuth.instance;
 bool progessbarr=false;
  String passwardd;
  String emaill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: progessbarr,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag:'logo',
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
                  emaill=value;
                  //Do something with the user input.
                },
                decoration: kinputdecoration.copyWith(hintText: 'Enter Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  passwardd=value;
                  //Do something with the user input.
                },
                decoration: kinputdecoration.copyWith(hintText: 'Enter passward'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Buttonwidget(text: 'LOG IN',colur: Colors.lightBlueAccent,
                function: ()async{
                setState(() {
                  progessbarr=true;

                });


                  try{ final newuserr= await _auth.signInWithEmailAndPassword(email: emaill, password: passwardd);
                  setState(() {
                    progessbarr=false;

                  });

                     if(newuserr!=null){
                       Navigator.pushNamed(context, ChatScreen.id);

                     }


                  }
                  catch(e){
                    print(e);

                  }

                }
                ,),
            ],
          ),
        ),
      ),
    );
  }
}
