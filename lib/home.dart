import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './login.dart';
import './Chat.dart';
import './settings.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class HomePage extends StatelessWidget {
  final String title;
  final String userName;
  final FirebaseUser currentUserId;

  HomePage({Key key, this.title, this.currentUserId, this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red),
        ),
        body: HomeChats( currentUser: currentUserId,),
        drawer: HomeDrawer(
          userName: userName,
        ));
  }
}

class HomeChats extends StatefulWidget {
  final FirebaseUser currentUser;

  HomeChats({Key key, this.currentUser}): super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _HomeChatsState(currentUser);
  }
}

class _HomeChatsState extends State<HomeChats> {
  FirebaseUser currentUser;

   _HomeChatsState(FirebaseUser user){this.currentUser=user;}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index],currentUser),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }
}

Widget buildItem(BuildContext context, DocumentSnapshot document, FirebaseUser currentUser) {

//currentUser.uid

  if (document['id'] == currentUser.uid) {
    
    return Container();
  } else {
     
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: document['photoUrl'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Nickname: ${document['nickname']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        'About me: ${document['aboutMe'] ?? 'Not available'}',
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
           Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat( peerId: document.documentID,
                          peerAvatar: document['photoUrl'],peerName: document['nickname']))); 
        },
        color: Colors.blueGrey,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}

class HomeDrawer extends StatelessWidget {


  final String userName;

  HomeDrawer({Key key, this.userName}) : super(key: key);


Future _logout()  async {
    await _auth.signOut();
    _googleSignIn.signOut();
}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                  ),
                  Image.asset(
                    'assets/chat2.png',
                    alignment: Alignment.centerLeft,
                    width: 50,
                    height: 50,

                    //  color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    ' Hi, ' + userName,
                    style: TextStyle(
                        fontSize: 25,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  'Welcome to Chatx',
                  style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ],
            ),
            decoration: BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage("assets/drawerheader.jpg"),
              fit: BoxFit.cover,
            )),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(
              Icons.home,
              color: Colors.red,
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('About'),
            leading: Icon(
              Icons.book,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Settings()) );
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            leading: Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              _logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeSignIn()));
            },
          ),
        ],
      ),
    );
  }
}
