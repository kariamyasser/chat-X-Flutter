import 'package:flutter/material.dart';
import './login.dart';





void main() => runApp(MyApp());

//or void main(){runApp();} lw 3ndy one line func. inline
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.blueGrey,
          backgroundColor: Colors.white,
        ),
        home: HomeSignIn());
  }
}
