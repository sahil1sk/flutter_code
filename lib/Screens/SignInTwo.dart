import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignInTwo extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  final customStyle = TextStyle(
    fontSize: 15,
    fontFamily: 'SFUIDisplay',
    fontWeight: FontWeight.bold,
    color: Colors.white
  );

  snackbar(scaffoldKey, String message) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      backgroundColor: Colors.red,
    ));
  }

  Future<bool> _handleSignIn() async {
    try {
      final data = await _googleSignIn.signIn();
      print(data);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> _fbLogin() async {
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logInWithReadPermissions(['email']);
      final token = result.accessToken.token;
      print("here is the token used to get data $token");
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> simpleLogin() async {
    try{
      final body = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      print(body);
      // ------- your post request
      await Future.delayed(Duration(milliseconds: 10));
      return true;
    } catch(error) {
      print(error);
      return false;
    }
  }

  Future<void> loginHandler({bool isGoogle = false, bool isFb = false}) async {
     bool success = false;

     if(isGoogle) {
       success = await _handleSignIn();
     } else if(isFb) {
       success = await _fbLogin();
     } else {
       success = await simpleLogin();
     }

      if(success) {
        Fluttertoast.showToast(
          msg: "Login Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else {
        snackbar(_scaffoldKey, "Something Went Wrong!!");
      }
  }

  Widget socialButtons(String msg, IconData icon, function) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: MaterialButton(
        onPressed: function,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(icon),
            Text(msg,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'SFUIDisplay'
            ),)
          ],
        ),
        color: Colors.transparent,
        elevation: 0,
        minWidth: 350,
        height: 60,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Colors.white)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Assets/image2.png'),
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20,),
                Center(child: Text("AYUVANI", style: customStyle.copyWith(fontSize: 44))),
                Center(child: Text("GET HEALTHCARE ANYWHERE", style: customStyle.copyWith(fontSize: 12.5))),
                SizedBox(height: 100,),
                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              )
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 15,
                            color: Colors.white)
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              )
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 15,
                            color: Colors.white)
                          ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Checkbox(value: true, onChanged: (val){}, focusColor: Colors.white, hoverColor: Colors.white,),
                        Text("Remember me", style: customStyle,),
                      ]),
                      Text("Forget?", style: customStyle,),
                    ],
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Login in-with OTP", style: customStyle,),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          onPressed: loginHandler,
                          child: Text('SIGN IN',
                          style: customStyle,
                          ),
                          color: Color(0xffff2d55),
                          elevation: 0,
                          minWidth: 150,
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                  ],
                ),
                socialButtons("Sign in with Facebook", FontAwesomeIcons.facebookSquare, () => loginHandler(isFb: true)),
                socialButtons("Sign in with Google", FontAwesomeIcons.googlePlusSquare, () => loginHandler(isGoogle: true)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}