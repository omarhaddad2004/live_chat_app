import 'dart:ui';

import 'package:chat_app/Screens/Sign_up.dart';
import 'package:chat_app/Screens/users_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../wedgets/Textfield.dart';
import '../wedgets/Custombutton.dart';
import '../wedgets/mysnackbar.dart';

class SignIn_screen extends StatefulWidget {
  @override
  State<SignIn_screen> createState() => _SignIn_screenState();
}

class _SignIn_screenState extends State<SignIn_screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloding=false;
  String? email;

  String? Pasword;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isloding ,
      child: Scaffold(
        body: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1e1e2f),
                Color(0xFF8B8C8C),
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  constraints:  BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,

                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.03),


                        Image.asset(
                          'assets/logo/app_logo.png',
                          height: screenHeight * 0.12,
                        ),

                        SizedBox(height: screenHeight * 0.015),


                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: screenWidth * 0.13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Glass Container
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Column(
                                children: [
                                  Textfield(hint: 'Enter your email', ispassword: false,
                                  onchange: (data){
                                    email=data.trim();

                                  },),
                                  SizedBox(height: screenHeight * 0.010),
                                  Textfield(
                                      hint: 'Enter the password..',
                                      ispassword: true,
                                    onchange: (data){
                                        Pasword=data.trim();

                                    },

                                  ),
                                  SizedBox(height: screenHeight * 0.019),
                                  Text(
                                    'or',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.055,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      socialIcon(
                                        svgUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b9/2023_Facebook_icon.svg',
                                        size: 50,
                                        radius: 25,
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                      socialIcon(
                                        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png',
                                        size: 50,
                                        radius: 25,
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                      socialIcon(
                                        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/X_icon.svg/768px-X_icon.svg.png',
                                        size: 50,
                                        radius: 25,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  Custombutton(()async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isloding = true;
                                      });


                                      try {
                                        UserCredential user = await FirebaseAuth.instance
                                           .signInWithEmailAndPassword(
                                          email: email!.trim(),
                                          password: Pasword!.trim(),
                                        );

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          Mysnackbar("Thanks for join us <3"),
                                        );


                                        await Future.delayed(Duration(milliseconds: 200));


                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => UsersPage()),
                                        );

                                      } on FirebaseAuthException catch (e) {
                                        String errorMessage;
                                        switch (e.code) {
                                          case 'user-not-found':
                                            errorMessage = "No user found for this email.";
                                            break;
                                          case 'wrong-password':
                                            errorMessage = "Incorrect password. Please try again.";
                                            break;
                                          case 'invalid-email':
                                            errorMessage = "Please enter a valid email address.";
                                            break;
                                          case 'user-disabled':
                                            errorMessage = "This user has been disabled.";
                                            break;
                                          case 'too-many-requests':
                                            errorMessage = "Too many login attempts. Try again later.";
                                            break;
                                          case 'operation-not-allowed':
                                            errorMessage = "Email/password sign-in not enabled.";
                                            break;
                                          default:
                                            errorMessage = "Firebase error: ${e.message}";
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          Mysnackbar(errorMessage),
                                        );
                                      } catch (_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          Mysnackbar("Something went wrong. Please try again."),
                                        );
                                      }
                                      setState(() {
                                        isloding =false;
                                      });
                                    }
                                  },'Sign In')
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        RichText(
                          text: TextSpan(
                            text: 'You don’t have acc? ',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white70,
                            ),
                            children: [
                              TextSpan(
                                text: ' Register',
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: true,
                                        transitionDuration: Duration(milliseconds: 400),
                                        pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ,
      ),
    );
  }

  Widget socialIcon({String? svgUrl, String? imageUrl, required double size, required double radius}) {
    return CircleAvatar(
      backgroundColor: Colors.white24,
      radius: radius,
      child: svgUrl != null
          ? SvgPicture.network(svgUrl, height: size, width: size)
          : Image.network(imageUrl!, height: size, width: size),
    );
  }
}
