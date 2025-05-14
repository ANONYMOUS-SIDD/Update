


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:google_sign_in/google_sign_in.dart";
import 'package:productivity_tool_flutter/Client-Anonymous/authentication/sessioncontrol.dart';
import 'package:productivity_tool_flutter/Client-Anonymous/authentication/showpassword.dart';
import 'package:productivity_tool_flutter/Client-Anonymous/authentication/toast.dart';

import '../../utils/routes/routes_name.dart';
import '../ui-helper/button.dart';
import '../ui-helper/loader.dart';

class Login extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  Session session = Get.put(Session());
  final formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final bool loading = false;
  Loader loader = Get.put(Loader());
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final Shows showPassword = Get.put(Shows());
    final scalefactor = MediaQuery.of(context).textScaleFactor;
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 1 * h,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xFF0CBBF0),
                  Color(0xFF870AFC),
                  Color(0xFFE4417A),
                  Color(0xFF07F49E),
                  Color(0xFF07F49E),
                ],
                begin: FractionalOffset(1, 0),
                end: FractionalOffset(0, 1),
              )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 300),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white), // or any other icon
                      onPressed: () {
                        Get.back(); // This pops the current route
                      },
                    ),
                  ),
                  Container(
                    height: 0.30 * h,
                    child: const Image(
                      image: AssetImage("assets/images/app-logo-removebg.png"),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 0.04 * h),
                      height: 0.56 * h,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(0.07 * w), topRight: Radius.circular(0.07 * w))),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0.05 * w, top: 0.04 * h, right: 0.05 * w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.04 * w),
                                    child: Text(
                                      "Email Address",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12 * scalefactor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.083 * h,
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: GoogleFonts.poppins(fontSize: 14 * scalefactor, fontWeight: FontWeight.w500),
                                      controller: email,
                                      decoration: InputDecoration(
                                          hintText: "Email Address",
                                          errorStyle: GoogleFonts.poppins(
                                            fontSize: 12 * scalefactor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 0.035 * w),
                                          filled: true,
                                          fillColor: const Color(0xFFe4e8eb),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.035 * w), borderSide: BorderSide.none)),
                                      validator: (value) {
                                        if (email.text.toString().isEmpty) {
                                          return "Enter Email Address";
                                        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!)) {
                                          return "Enter Valid Email Address";
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0.05 * w, top: 0.01 * h, right: 0.05 * w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.04 * w),
                                    child: Text(
                                      "Password",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12 * scalefactor,
                                      ),
                                    ),
                                  ),
                                  Obx(() => SizedBox(
                                        height: 0.083 * h,
                                        child: TextFormField(
                                          obscureText: showPassword.show.value,
                                          style: GoogleFonts.poppins(fontSize: 14 * scalefactor, fontWeight: FontWeight.w500),
                                          controller: password,
                                          decoration: InputDecoration(
                                              hintText: "Password",
                                              errorStyle: GoogleFonts.poppins(
                                                fontSize: 12 * scalefactor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              suffixIcon: InkWell(
                                                  onTap: () {
                                                    showPassword.showpassword();
                                                  },
                                                  child: showPassword.show.value == true
                                                      ? const Icon(
                                                          Icons.visibility_rounded,
                                                          color: Colors.black,
                                                        )
                                                      : const Icon(
                                                          Icons.visibility_off_rounded,
                                                          color: Colors.black,
                                                        )),
                                              contentPadding: EdgeInsets.only(left: 0.035 * w, top: 0.030 * h),
                                              filled: true,
                                              fillColor: const Color(0xFFe4e8eb),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.035 * w), borderSide: BorderSide.none)),
                                          validator: (value) {
                                            if (password.text.toString().isEmpty) {
                                              return "Enter Password";
                                            } else if (password.text.toString().length <= 8) {
                                              return "Atleast 8-Character Needed";
                                            }

                                            return null;
                                          },
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 0.05 * w),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (email.text.toString() == "") {
                                        Toast().message("Enter Your Email Address");
                                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email.text)) {
                                        Toast().message("Enter A Valid Email");
                                      } else {
                                        try {
                                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.toString());
                                          Toast().message("Password Reset Email Sent Successfully");
                                        } catch (e) {
                                          Toast().message("Something Went Wrong");
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(fontSize: 11 * scalefactor, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.03 * h,
                            ),
                            Button(
                              text: "Log In",
                              height: 0.055 * h,
                              width: 0.89 * w,
                              color: Colors.pinkAccent.shade400,
                              onTap: () {
                                if (formkey.currentState!.validate()) {
                                  loader.load(true);
                                  auth
                                      .signInWithEmailAndPassword(
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                  )
                                      .then((value) {
                                    session.userDetail();
                                    loader.load(false);
                                    Navigator.pushReplacementNamed(context, RoutesName.home);
                                    Toast().message("Login Successful");
                                  }).catchError((error, stackTrace) {
                                    loader.load(false);
                                    if (error is FirebaseAuthException) {
                                      if (error.code == "network-request-failed") {
                                        Toast().message("Connection Error");
                                      } else if (error.code == 'too-many-requests') {
                                        Toast().message("Too Many Failed Attempts");
                                      } else if (error.code == 'user-not-found' || error.code == 'wrong-password' || error.code == 'INVALID_LOGIN_CREDENTIALS') {
                                        Toast().message("Invalid Email or Password");
                                      } else {
                                        Toast().message("Authentication Failed");
                                      }
                                    } else {
                                      Toast().message("Something Went Wrong");
                                    }
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: 0.025 * h,
                            ),
                            Text(
                              "Or",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 17 * scalefactor),
                            ),
                            SizedBox(
                              height: 0.025 * h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.poppins(fontSize: 12 * scalefactor, fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushReplacementNamed(context, RoutesName.signup),
                                  child: Text(
                                    " Sign up",
                                    style: GoogleFonts.poppins(fontSize: 12 * scalefactor, fontWeight: FontWeight.w500, color: Colors.yellow.shade700),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
