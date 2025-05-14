




import 'dart:ui'; // For ImageFilter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Client-Anonymous/authentication/sessioncontrol.dart';
import '../Client-Anonymous/authentication/toast.dart';
import '../Client-Anonymous/ui-helper/image_picker.dart';
import '../Client-Anonymous/ui-helper/loader.dart';
import '../utils/routes/routes_name.dart';
import 'home_screen.dart';

class Profile extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final Loader loader = Get.put(Loader());
  final Session session = Get.put(Session());
  final ImagePickerController imagepicker = Get.put(ImagePickerController());
  final User? user = FirebaseAuth.instance.currentUser;

  Profile({super.key});

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(0.3),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebasedata = FirebaseFirestore.instance.collection('User').doc(session.UID.value).snapshots();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2B5876), Color(0xFF4E4376)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2B5876), Color(0xFF4E4376)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Blur glass effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),

          StreamBuilder(
            stream: firebasedata,
            builder: (context, snapshot) {
              if (snapshot.hasError || snapshot.data == null || snapshot.data!.data()?.isEmpty == true) {
                return Center(
                  child: Text(
                    "Loading....",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                );
              }

              final userData = snapshot.data!.data()!;
              final profileImage = userData["Path"] ?? "";
              final userName = userData["Name"] ?? "Your Name";
              final userEmail = userData["Email"] ?? "Your Email";

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Info Card (Top Rounded Only Bottom)
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2B5876), Color(0xFF4E4376)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ), // Soft blue
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Card(
                              elevation: 10,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: 65, // Increased size
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(profileImage),
                                ),
                              )),
                          const SizedBox(height: 20),
                          Text(
                            userName,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Cards Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildActionCard(
                            title: "Update Profile Photo",
                            subtitle: "Upload a new profile picture",
                            icon: Icons.camera_alt,
                            onTap: () async {
                              var status = await Permission.photos.status;
                              if (!status.isGranted) {
                                status = await Permission.photos.request();
                              }

                              if (status.isGranted) {
                                await imagepicker.getImage();
                                await imagepicker.uploadImage();
                                if (imagepicker.downloadURL.value.isNotEmpty) {
                                  await FirebaseFirestore.instance.collection("User").doc(session.UID.value).update({"Path": imagepicker.downloadURL.value});
                                }
                              } else {
                                Toast().message("Gallery permission is required.");
                              }
                            },
                            gradientColors: [Color(0xFF16A085), Color(0xFF2980B9)],
                          ),
                          const SizedBox(height: 14),
                          _buildActionCard(
                            title: "Update Username",
                            subtitle: "Change your display name",
                            icon: Icons.edit,
                            onTap: () => _changeUsername(context),
                            gradientColors: [Color(0xFFee0979), Color(0xFFff6a00)],
                          ),
                          const SizedBox(height: 14),
                          _buildActionCard(
                            title: "Reset Password",
                            subtitle: "Update your account password",
                            icon: Icons.lock_reset,
                            onTap: () async => _resetPassword(),
                            gradientColors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
                          ),
                          const SizedBox(height: 14),
                          _buildActionCard(
                            title: "Create New Account",
                            subtitle: "Register a new account",
                            icon: Icons.person_add,
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushNamed(context, RoutesName.signup);
                            },
                            gradientColors: [Color(0xFF7b4397), Color(0xFFdc2430)],
                          ),
                          const SizedBox(height: 14),
                          _buildActionCard(
                            title: "Sign Out",
                            subtitle: "Log out from the app",
                            icon: Icons.logout,
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.offAllNamed(RoutesName.signup); // removes all previous screens
                            },
                            gradientColors: [Color(0xFF2980b9), Color(0xFF6dd5fa)],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _changeUsername(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Username',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFF2E2C54),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username cannot be empty';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Color(0xFF2E2C54),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
                    prefixIcon: const Icon(Icons.person_rounded, color: Color(0xFF2E2C54), size: 20),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2E2C54), width: 1.4),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF2E2C54),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus(); // Dismiss the keyboard

                          // Show loader or progress indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(child: CircularProgressIndicator());
                            },
                          );

                          try {
                            await FirebaseFirestore.instance
                                .collection("User")
                                .doc(session.UID.value) // Replace with actual session UID
                                .update({
                              "Name": _nameController.text.trim(),
                            });
                            Navigator.of(context).pop(); // Close the loader
                            Navigator.of(context).pop(); // Close the dialog
                            Toast().message("Username Updated Successfully ");
                          } catch (e) {
                            Navigator.of(context).pop();
                            Toast().message("Failed To Update Username "); // Close the loader
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E2C54), Color(0xFF5A55CA)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    var email = user?.email;
    if (email.toString() == "") {
      Toast().message("Enter Your Email Address");
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email!)) {
      Toast().message("Enter A Valid Email");
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.toString());
        Toast().message("Password Reset Email Sent Successfully");
      } catch (e) {
        Toast().message("Something Went Wrong");
      }
    }
    // Implement reset password logic
  }
}
