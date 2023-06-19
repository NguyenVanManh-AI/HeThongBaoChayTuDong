import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screen/home_screen1.dart';
import 'package:my_app/screen/profile_screen.dart';
import 'package:my_app/screen/reset_password.dart';
import 'package:my_app/utils/color_utils.dart';
import 'package:my_app/reusable_widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("FF0000"),
        hexStringToColor("FF4500"),
        hexStringToColor("EEAD0E")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: Column(
          children: <Widget>[
            logoWidget("assets/images/images.png"),
            const SizedBox(height: 20),
            reusableTextField("Enter Email", Icons.person_outline, false,
                _emailTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Password", Icons.lock_outline, true,
                _passwordTextController),
            const SizedBox(
              height: 5,
            ),
            forgetPassword(context),
            firebaseButton(context, "Log In", () async {
              if (_emailTextController.text == '' ||
                  _passwordTextController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all information'),
                  ),
                );
              } else {
                SharedPreferences prefs =await SharedPreferences.getInstance();
                prefs.setString('email2', _emailTextController.text);
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen1()));
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login Fail'),
                    ),
                  );
                  // ScaffoldMessenger.of(context).showBottomSheet(
                  //   (context) => Container(
                  //     height: 200,
                  //     child: Center(
                  //       child: Text('This is a temporary bottom sheet'),
                  //     ),
                  //   ),
                  // );
                });
              }
            }),
            signUpOption()
          ],
        ),
      )),
    ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
