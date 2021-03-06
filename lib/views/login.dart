import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selfmemory_flutter/api/user.api.dart';
import 'package:selfmemory_flutter/models/login_model.dart';
import 'package:selfmemory_flutter/models/token_model.dart';
import 'package:selfmemory_flutter/models/user.dart';
import 'package:selfmemory_flutter/preferences/shared_preferences.dart';
import 'package:selfmemory_flutter/views/memory.dart';
import 'package:selfmemory_flutter/views/navigator.dart';
import 'package:selfmemory_flutter/views/signup.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page'; //for routes

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  var _showCircularProgressIndicator = false;

  @override
  initState() {}

  //add login method
  Future<User> loginasync(String email, String password) async {
    setState(() {
      _showCircularProgressIndicator = true;
    });
    LoginModel newuser = LoginModel(email: email, password: password);
    final String token = await loginApi(newuser);
    if (token != null) {
      print(await getToken());
      final user = await whoAmI();
      if (user != null) {
        setState(() {
          _showCircularProgressIndicator = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => NavigatorPage()));
      } else {
        return null;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Credenciales incorrectas",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 40.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: namecontroller,
      decoration: InputDecoration(
        hintText: 'Usuario',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordcontroller,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[700], // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {
          if (email.controller.text.length > 0 &&
              password.controller.text.length > 0) {
            this.loginasync(email.controller.text, password.controller.text);
          }
        },
        child: Text('Ingresar', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red[700], // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(SignupPage.tag);
        },
        child: Text('Registrar', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            Text("SELFMEMORY",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blueGrey)),
            SizedBox(height: 18.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            registerButton,
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _showCircularProgressIndicator
                    ? CircularProgressIndicator()
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
