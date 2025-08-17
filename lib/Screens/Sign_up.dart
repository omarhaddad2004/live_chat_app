import 'dart:ui';

import 'package:chat_app/Screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../wedgets/Textfield.dart';
import '../wedgets/mysnackbar.dart';
import '../wedgets/Custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  String? displayname;
  bool isloding=false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isloding ,
      child: Scaffold(
        
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1e1e2f), Color(0xFF8B8C8C)],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.01),


                      Image.asset(
                        'assets/logo/app_logo.png',
                        height: screenHeight * 0.12,
                      ),



                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(screenWidth * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Column(
                              children: [
                                Textfield(
                                  hint: 'Enter your display name ',
                                  ispassword: false,
                                  onchange: (data) => displayname = data,
                                ),
                                Textfield(
                                  hint: 'Enter your email',
                                  ispassword: false,
                                  onchange: (data) => email = data,
                                ),
                                Textfield(
                                  hint: 'Enter the password',
                                  ispassword: true,
                                  onchange: (data) => password = data,
                                ),
                                Textfield(
                                  hint: 'Confirm your password',
                                  ispassword: true,
                                  onchange: (data) => confirmPassword = data,
                                ),

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
                                SizedBox(height: screenHeight * 0.03),
                                Custombutton(() async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isloding = true;
                                    });
                                    if (password != confirmPassword) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        Mysnackbar("Passwords do not match."),
                                      );
                                      setState(() {
                                        isloding = false;
                                      });
                                      return;
                                    }
      
                                    try {
                                      UserCredential user = await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                        email: email!,
                                        password: password!,
                                      );
                                      await user.user!.updateDisplayName(displayname);
                                      await user.user!.reload();

                                      await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
                                        'uid': user.user!.uid,
                                        'email': email,
                                        'displayName': displayname,
                                        'createdAt': FieldValue.serverTimestamp(),
                                      });
      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        Mysnackbar("Account created successfully! Please log in now ..."),
                                      );



                                      await Future.delayed(Duration(milliseconds: 200));


                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignIn_screen()),
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      String errorMessage;
                                      switch (e.code) {
                                        case 'email-already-in-use':
                                          errorMessage = "This email is already registered.";
                                          break;
                                        case 'invalid-email':
                                          errorMessage = "Please enter a valid email address.";
                                          break;
                                        case 'weak-password':
                                          errorMessage = "The password is too weak.";
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
                                },'Sign Up',)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.002),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white70,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(context),
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
