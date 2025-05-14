

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productivity_tool_flutter/Client-Anonymous/authentication/sessioncontrol.dart';
import 'package:productivity_tool_flutter/Client-Anonymous/authentication/showpassword.dart';
import 'package:productivity_tool_flutter/Client-Anonymous/authentication/toast.dart';

import '../../utils/routes/routes_name.dart';
import '../ui-helper/button.dart';
import '../ui-helper/loader.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  final TextEditingController signemail = TextEditingController();
  final TextEditingController signpassword = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController phoneno = TextEditingController();
  final firebase = FirebaseFirestore.instance.collection("User");
  Session session = Get.put(Session());
  final formkey = GlobalKey<FormState>();
  Loader loader = Get.put(Loader());

  FirebaseAuth auth = FirebaseAuth.instance;

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final Shows showPassword = Get.put(Shows());
    Session session = Get.put(Session());
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
                    height: 0.2 * h,
                    child: const Image(
                      image: AssetImage("assets/images/app-logo-removebg.png"),
                    ),
                  ),
                  Container(
                      height: 0.7 * h,
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
                                      "Full Name",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12 * scalefactor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.083 * h,
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      style: GoogleFonts.poppins(fontSize: 14 * scalefactor, fontWeight: FontWeight.w500),
                                      controller: fullname,
                                      decoration: InputDecoration(
                                          hintText: "Full Name",
                                          errorStyle: GoogleFonts.poppins(
                                            fontSize: 12 * scalefactor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 0.035 * w),
                                          filled: true,
                                          fillColor: const Color(0xFFe4e8eb),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.035 * w), borderSide: BorderSide.none)),
                                      validator: (value) {
                                        if (fullname.text.toString().isEmpty) {
                                          return "Enter Full Name";
                                        } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value!)) {
                                          return "Enter Valid Name";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.04 * w),
                                    child: Text(
                                      "Phone Number",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12 * scalefactor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.083 * h,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.poppins(fontSize: 14 * scalefactor, fontWeight: FontWeight.w500),
                                      controller: phoneno,
                                      decoration: InputDecoration(
                                          hintText: "Phone Number",
                                          errorStyle: GoogleFonts.poppins(
                                            fontSize: 12 * scalefactor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 0.035 * w),
                                          filled: true,
                                          fillColor: const Color(0xFFe4e8eb),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.035 * w), borderSide: BorderSide.none)),
                                      validator: (value) {
                                        String input = value?.trim() ?? '';

                                        if (input.isEmpty) {
                                          return "Enter Phone Number";
                                        }

                                        if (!RegExp(r'^\d+$').hasMatch(input)) {
                                          return "Enter Valid Number";
                                        }

                                        if (input.length < 9) {
                                          return "Enter Valid Number";
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
                                      controller: signemail,
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
                                        if (signemail.text.toString().isEmpty) {
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
                                          controller: signpassword,
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
                                            String password = signpassword.text.trim();

                                            if (password.isEmpty) {
                                              return "Enter Password";
                                            } else if (password.length < 8) {
                                              return "At least 8 characters needed";
                                            } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$').hasMatch(password)) {
                                              return "Use letters and numbers both";
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
                                      if (signemail.text.toString() == "") {
                                        Toast().message("Enter Your Email Address");
                                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(signemail.text)) {
                                        Toast().message("Enter A Valid Email");
                                      } else {
                                        try {
                                          await FirebaseAuth.instance.sendPasswordResetEmail(email: signemail.text.toString());
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
                              text: "Sign up",
                              height: 0.055 * h,
                              width: 0.89 * w,
                              color: Colors.pinkAccent.shade400,
                              onTap: () async {
                                if (formkey.currentState!.validate()) {
                                  loader.load(true);

                                  try {
                                    // Create user
                                    await auth.createUserWithEmailAndPassword(
                                      email: signemail.text.trim(),
                                      password: signpassword.text.trim(),
                                    );

                                    // Sign in user
                                    await auth.signInWithEmailAndPassword(
                                      email: signemail.text.trim(),
                                      password: signpassword.text.trim(),
                                    );

                                    // Load session details
                                    session.userDetail();

                                    // Prepare data to save in Firestore
                                    final firebase = FirebaseFirestore.instance.collection("User");
                                    String id = DateTime.now().microsecondsSinceEpoch.toString();

                                    await firebase.doc(session.UID.value).set({"id": id, "Name": fullname.text.trim(), "Phone": phoneno.text.trim(), "Email": signemail.text.trim(), "Password": signpassword.text.trim(), "SessionId": session.UID.value, "OrderStatus": "False", "Path": "https://firebasestorage.googleapis.com/v0/b/online-2cdb1.appspot.com/o/1707049056458970?alt=media&token=2bcfcd4d-c2e1-4795-a064-312d5265eb21"});

                                    loader.load(false);
                                    Toast().message("Successfully Signed Up");
                                    Get.to(Login());
                                  } on FirebaseAuthException catch (error) {
                                    loader.load(false);

                                    switch (error.code) {
                                      case "network-request-failed":
                                        Toast().message("Connection Error");
                                        break;
                                      case "too-many-requests":
                                        Toast().message("Too Many Failed Attempts");
                                        break;
                                      case "email-already-in-use":
                                        Toast().message("Email Already In Use");
                                        break;
                                      default:
                                        Toast().message("Auth Error: ${error.message}");
                                    }
                                  } catch (error) {
                                    loader.load(false);
                                    if (error.toString().contains("PERMISSION_DENIED")) {
                                      Toast().message("Permission denied to write data.");
                                    } else {
                                      Toast().message("An unexpected error occurred.");
                                    }
                                    print("Unhandled error: $error");
                                  }
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
                                  "Already have an account?",
                                  style: GoogleFonts.poppins(fontSize: 12 * scalefactor, fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushNamed(context, RoutesName.login),
                                  child: Text(
                                    " Log In",
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
