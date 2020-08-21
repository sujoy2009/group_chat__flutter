import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
final _firestore=Firestore.instance;
FirebaseUser logineduser;

class ChatScreen extends StatefulWidget {
  static const String id='chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth=FirebaseAuth.instance;
  final msgcontroller=TextEditingController();

  String massege;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser()async{
    final user =await _auth.currentUser();
    try{
      if(user!=null){
       logineduser=user;

      }
      print(logineduser.email);


    }
    catch(e){
      print(e);
    }




  }
  /*
  void getmsg()async{
    final  msg=await _firestore.collection('masseges').getDocuments();
    for(var massege in msg.documents){
      print(massege.data);
    }
  }



   void getmsgstream()async{
    print('dhukce');
  await for   (var snapshot in _firestore.collection('masseges').snapshots()){
    for (var massge in snapshot.documents){
      print(massge.data);
      print('ses');

    }
  }
   
     
   }

   */
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
         FlatButton(
           child: Text('Log out'),
           onPressed: (){
             _auth.signOut();
             Navigator.pop(context);
           },

         )
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            msgstreambuilder(),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgcontroller,
                      onChanged: (value) {
                        //Do something with the user input.
                        massege=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgcontroller.clear();
                      //Implement send functionality.
                      _firestore.collection('masseges').add({
                        'text':massege,
                        'sender':logineduser.email,
                      });

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class msgstreambuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('masseges').snapshots(),
        // ignore: missing_return
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),


            );


          }
          final masseges=snapshot.data.documents.reversed;
          List<msgbubble> massehewidget=[];
          for(var msg in masseges){
            final msgtext=msg.data['text'];
            final msgtsender=msg.data['sender'];

            final msgwidget=msgbubble(msggtext: msgtext,msgsenderr: msgtsender,isme: msgtsender==logineduser.email,);
            massehewidget.add(msgwidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal:10,vertical: 20 ),
              children: massehewidget,
            ),
          );


        }

    );
  }
}

class msgbubble extends StatelessWidget {
  msgbubble({this.msggtext,this.msgsenderr,this.isme});
  final String msggtext;
  final String msgsenderr;
  bool isme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(10) ,
      child: Column(
        crossAxisAlignment:isme? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(msgsenderr,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,

          ),),
          Material(
            elevation: 5.0,
            borderRadius: isme? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft:Radius.circular(30.0),
              bottomRight: Radius.circular(30.0))
            :
                BorderRadius.only(
                topRight : Radius.circular(30.0),
            bottomLeft:Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)
              ,
            ),

            color: isme?Colors.blueAccent:Colors.white,
            child: Padding(
              padding:EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),

              child: Text(
                msggtext,
                style:TextStyle(
                  color:isme? Colors.white:Colors.black,
                  fontSize: 15.0,
                ) ,
              ),
            ),
          ),

        ],
      ),


      );


  }
}
