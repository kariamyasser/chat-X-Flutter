import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordx();
  }
}

class _ResetPasswordx extends State<ResetPassword> {
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
                  child: ResetPasswordInterface(),
                ),
              )),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Navigator.push(context,MaterialPageRoute(builder: (context) => HomeSignIn()),);

                //Navigator.pushNamed(context, '/second');
                Navigator.pop(context);
                // Navigator.of(context).push(new SecondPageRoute());
              },
              backgroundColor: Colors.red,
              tooltip: 'Sign In',
              child: Text('SIGN\n  IN+') //Icon(Icons.navigate_next),
              ),
        ));
  }
}

class ResetPasswordInterface extends StatelessWidget {
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
                'Reset Password ',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 40,
                    fontStyle: FontStyle.normal),
              ),
            ],
          )),
      Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
          child: Text(
            'Welcome to Chatx , \nIf you lost your password,\nPlease enter your email address,\nso we can send a reset password email',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontStyle: FontStyle.italic),
          )),
      Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        height: 200,
        width: 200,
        child: Image.asset('assets/resetpassword.png'),
      ),
      ResetPasswordManager(),
    ]));
  }
}

class ResetPasswordManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordManagerState();
  }
}

class _ResetPasswordManagerState extends State<ResetPasswordManager> {
  final TextEditingController _email = new TextEditingController();

  void _erase() {
    setState(() {
      _email.clear();
    });
  }

  void _getData() {
    setState(() {
      String x;
      if (_email.text.isNotEmpty) {
        x = _email.text.toString();
        print('$x');
      }
    });
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
        margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          if (isEmail(_email.text.toString())) {
                            final snackbar = new SnackBar(
                                content: Text("Sending Email ..."),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors
                                    .red); // Theme.of(context).backgroundColor);
                            Scaffold.of(context).showSnackBar(
                                snackbar); ////lw el show grandchild lel scaffold  (Scaffold => child .. =>FAB)
                            _getData();
                            _erase();
                            //    _scaffoldKey.currentState.showSnackBar(  snackbar); //lw el show gowa el scaffold 3la tol (Scaffold =>FAB)

                          }
                        },
                        color: Colors.red,
                        child: Text(
                          'Send Email',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
