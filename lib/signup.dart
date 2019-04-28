import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './home.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
class HomeSignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeSignUpx();
  }
}

class _HomeSignUpx extends State<HomeSignUp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                SystemChannels.textInput
                    .invokeMethod('TextInput.hide'); //to hide keyboard
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: SignUpInterface(),
                ),
              )),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).push(new SecondPageRoute2());

                // Navigator.push(context,MaterialPageRoute(builder: (context) => HomeSignIn()),);
              },
              backgroundColor: Colors.red,
              tooltip: 'Sign In',
              child: Text('SIGN\n  IN+')
              //Icon(Icons.navigate_next),
              ),
        ));
  }
}

class SignUpInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Text(
                'Sign Up ',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 50,
                    fontStyle: FontStyle.normal),
              ),
              Image.asset(
                'assets/chat2.png',
                width: 50,
                height: 50,
                //color: Colors.blueGrey,
              ),
            ],
          )),
      Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
          child: Text(
            'Welcome to Chat X , \nJoin us today ',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.red, fontSize: 14, fontStyle: FontStyle.italic),
          )),
      SignUpManager(),
    ]));
  }
}

class SignUpManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpManagerState();
  }
}

class _SignUpManagerState extends State<SignUpManager> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _username = new TextEditingController();
  int _state = 0;

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Sign Up',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 30.0,
        width: 30.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Future _createUser() async {

        await _auth.signOut();
       _googleSignIn.signOut(); 
      // Check is already sign up
     /*  final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('email', isEqualTo: _email)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) { */

             
          FirebaseUser user = await _auth
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)

          .then((user) {
      
        print("Email : ${user.email}");
         print("uid : ${user.uid}");

  UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = _username.text;

user.updateProfile(info);
    
//  _auth.updateProfile(info);

//user = await user.reload();
//user = _auth.getCurrentUser();
  


  Firestore.instance.collection('users').document(user.uid).setData({
          'nickname': _username.text.toString(),
          'photoUrl': "",
          'id': user.uid,
          'email': user.email
        });
      var userName =  _username.text.toString().split(" ");
    print("User is: ${userName[0]}");

        setState(() {
         _state = 3;
        });

     Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(title: 'Home',userName: userName[0],))); 
     
      }).catchError(( error) {

           setState(() {
         _state = 0;
        });

        final snackbar = new SnackBar(
            content: Text("This Email is already used..."),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red);
        Scaffold.of(context).showSnackBar(snackbar);
      });

       
  /*   } else{
           
           setState(() {
         _state = 0;
        });

        final snackbar = new SnackBar(
            content: Text("This Email is already used..."),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red);
        Scaffold.of(context).showSnackBar(snackbar);
    

      } */
    
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 60, 30, 0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: _username,
                cursorColor: Colors.red,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Enter your username here..',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    icon: Icon(Icons.person)),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: TextField(
                controller: _email,
                cursorColor: Colors.red,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Enter your email address here..',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    icon: Icon(Icons.email)),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: TextField(
                controller: _password,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                    hintText: 'The secret to your account..',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    icon: Icon(Icons.security)),
                obscureText: true, //to hide characters
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            String x = _email.text.toString();
                            if (_email.text.isNotEmpty &&
                                _password.text.isNotEmpty && _username.text.isNotEmpty && isEmail(x) && _password.text.length > 5) {
                              setState(() {
                                _state = 1;
                              });
                              final snackbar = new SnackBar(
                                  content: Text("Signing Up..."),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors
                                      .red); // Theme.of(context).backgroundColor);
                              Scaffold.of(context).showSnackBar(
                                  snackbar); ////lw el show grandchild lel scaffold  (Scaffold => child .. =>FAB)
                              _createUser();

                             //    _scaffoldKey.currentState.showSnackBar(  snackbar); //lw el show gowa el scaffold 3la tol (Scaffold =>FAB)
                         
                            } else {
                              setState(() {
                                _state = 0;
                              });
                              final snackbar = new SnackBar(
                                  content: Text("Please Enter Correct Data \nPassword must be more than 5 characters ..."),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors
                                      .red); // Theme.of(context).backgroundColor);
                              Scaffold.of(context).showSnackBar(
                                  snackbar); ////lw el show grandchild lel scaffold  (Scaffold => child .. =>FAB)

                            }
                          },
                          color: Colors.red,
                          child: buildButtonChild()),
                    )
                  ],
                ))
          ],
        ));
  }
}
