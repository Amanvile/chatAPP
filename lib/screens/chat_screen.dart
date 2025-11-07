import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
User? loggedUser;
class ChatScreen extends StatefulWidget {
  static String id='/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  // Simplified the declaration, 'late final' is not needed here.
  final messageTextController = TextEditingController();

  late var messageText;


  @override
  void initState() {
    super.initState();
    // CRITICAL FIX #1: You must CALL the function with parentheses ().
    // 'getCurrentUser;' does nothing. 'getCurrentUser();' executes the function.
    getCurrentUser();
    // getMessages();
  }

  // This function can be synchronous. _auth.currentUser is not an async operation.
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        // This print statement is for debugging. Check your console to see if the user is found.
        print('User successfully initialized: ${loggedUser?.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  // This function is for getting messages, not sending them.
  // void getMessages() async {
  //   final cloudMessage = (await _fireStore.collection('Chat App').get());
  //   // print(cloudMessage.docs);
  //   print('getting data');
  //   for (var message in cloudMessage.docs) {
  //     print(message.data());
  //   }
  //   // print(cloudMessage);
  //   // cloudMessage.get().then(
  //   //       (DocumentSnapshot doc) {
  //   //       final data = doc.data() as Map<String, dynamic>;
  //   //       // print(data);
  //   //       // ...
  //   //     },
  //   //     onError: (e) => print("Error getting document: $e"),
  //   //
  //   //   );
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // getMessages();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // IMPORTANT: You will need a StreamBuilder here later to display messages.
            Expanded(flex: 1,child: MessageStream()),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(

                    onPressed: () {
                      // CRITICAL FIX #2: Check if the user is logged in before sending.
                      // If loggedUser is null, your security rule will correctly block the write.
                      if (loggedUser != null) {
                        _fireStore.collection('Chat App').add({
                          'text': messageText,
                          'sender': loggedUser?.email,
                        });
                        messageTextController.clear();
                      } else {
                        // This message will appear in your debug console if you try to send a message
                        // before the user information has been loaded.
                        print("SEND FAILED: User is not logged in. Message not sent.");
                      }
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

class MessageStream extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(stream:  _fireStore.collection('Chat App').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return CircularProgressIndicator(

          );
        }
          final messages = snapshot.data?.docs;
          List<MessageBubble> messageBubbles=[];
          for (var message in messages!){
            final messageData = message.data() as Map<String, dynamic>;
            final messageText = messageData['text'] ?? 'No text';
            final messageSender = messageData['sender'] ?? 'Unknown sender';
            final currentUser = loggedUser?.email;
            final messageBubble=MessageBubble(isMe:(currentUser==messageSender?true:false),text:messageText,sender:messageSender);

            messageBubbles.add(messageBubble);

          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          );


      },);
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text,required this.isMe, required this.sender});
  final String text;
  final String sender;
  final bool isMe;


  @override
  Widget build(BuildContext context) {
    return  Padding(

      padding: EdgeInsets.all(10.0),

      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,

        children: [
          Text(sender,
          style: TextStyle(fontSize: 12,color: Colors.black54),),
          Material(

            elevation: 5,
              borderRadius: isMe?
              BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0))
              :BorderRadius.only(topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0)),
              color: isMe? Colors.lightBlueAccent:Colors.white,
              child: Padding(

                  padding: EdgeInsetsGeometry.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(text, style: TextStyle(
                      color:isMe?Colors.yellowAccent:Colors.black54
                      ,fontSize: 15.0)))),
        ],
      ),
    );
  }
}

