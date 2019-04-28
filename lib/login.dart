import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './resetpassword.dart';
import './signup.dart';
import './home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class SecondPageRoute extends CupertinoPageRoute {
  int _route = 0;
  SecondPageRoute(this._route)
      : super(builder: (BuildContext context) {
          if (_route == 0) {
            new HomeSignUp();
          } else {
            new ResetPassword();
          }
        });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    if (_route == 0) {
      return new FadeTransition(opacity: animation, child: new HomeSignUp());
    } else {
      return new FadeTransition(opacity: animation, child: new ResetPassword());
    }
  }
}

class HomeSignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeSignInx();
  }
}

class _HomeSignInx extends State<HomeSignIn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: LoginInterface(),
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                new SecondPageRoute(0)); //0 for sign up,else for reset password
          },
          backgroundColor: Colors.red,
          tooltip: 'Sign Up',
          child: Text('SIGN\n  UP+') //Icon(Icons.navigate_next),
          ),
    );
  }
}

class LoginInterface extends StatelessWidget {
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
                'Sign In ',
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
            'Welcome to Chat X ',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.red, fontSize: 14, fontStyle: FontStyle.italic),
          )),
      LoginManager(),
    ]));
  }
}

class LoginManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginManagerState();
  }
}

class _LoginManagerState extends State<LoginManager>
    with TickerProviderStateMixin {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  int _state = 0;
  int _state2 = 0;

  Widget buildButtonChild2() {
    if (_state2 == 0) {
      return Row(
        children: <Widget>[
          Image.asset(
            'assets/google.png',
            width: 30,
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          ),
          Text(
            '   Google SignIn',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
                fontStyle: FontStyle.normal),
          ),
        ],
      );
    } else if (_state2 == 1) {
      return SizedBox(
        height: 30.0,
        width: 30.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.red);
    }
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Sign In',
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

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  Future<FirebaseUser> _SignIn() async {

        await _auth.signOut();
       _googleSignIn.signOut(); 

FirebaseUser user = await _auth.signInWithEmailAndPassword(email: _email.text,password: _password.text);
if(user!=null){
  var userName =  user.displayName.split(" ");
    print("User is: ${userName[0]}");

       setState(() {
        _state = 3;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    title: "Home",
                    userName: userName[0],
                    currentUserId: user,
                  )));}

                  else{


                     final snackbar = new SnackBar(
                                    content:
                                        Text("Please Enter Credentials..."),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.red);

                                Scaffold.of(context).showSnackBar(snackbar);
                                setState(() {
                                  _state = 0;
                                });
                           setState(() {
        _state= 0;
      });

                  }
  

  }



  Future<FirebaseUser> _gSignIn() async {

      setState(() {
        _state2 = 1;
      });
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
  
        var userName =  user.displayName.split(" ");
    print("User is: ${userName[0]}");

    if (user != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(user.uid).setData({
          'nickname': user.displayName,
          'photoUrl': user.photoUrl,
          'id': user.uid,
          'email': user.email
        });
      }
      setState(() {
        _state2 = 3;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    title: "Home",
                    userName: userName[0],
                    currentUserId: user,
                  )));
    } else {
      setState(() {
        _state2 = 0;
      });
    }
setState(() {
        _state2 = 0;
      });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 60, 30, 0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: _email,
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
            InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 10, left: 40),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  )),
              onTap: () {
                Navigator.of(context).push(
                    new SecondPageRoute(1)); //0 for sign up,else for reset pass
                // Navigator.push(context,MaterialPageRoute(builder: (context) => ResetPassword()),);
              },
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            if (_email.text.isNotEmpty &&
                                _password.text.isNotEmpty) {
                              if (isEmail(_email.text.toString())) {
                                setState(() {
                                  _state = 1;
                                });
                              
                             _SignIn();
                              } else {
                                final snackbar = new SnackBar(
                                    content:
                                        Text("Please Enter Correct Email..."),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.red);

                                Scaffold.of(context).showSnackBar(snackbar);
                                setState(() {
                                  _state = 0;
                                });
                              }
                            } else {
                              final snackbar = new SnackBar(
                                  content: Text("Please Enter All Data..."),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.red);

                              Scaffold.of(context).showSnackBar(snackbar);
                            }
                          },
                          color: Colors.red,
                          child: buildButtonChild()),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        setState(() {
                          _state2 = 1;
                        });
                        _gSignIn();
                           
                      },
                      color: Colors.white,
                      child: buildButtonChild2(),
                    ),
                  ),
                ])),
          ],
        ));
  }
}
