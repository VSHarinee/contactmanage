import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); // New field
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController(); // New field
  bool isFavorite = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addContact() async {
    String uid = _auth.currentUser!.uid;

    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      await _firestore.collection('users').doc(uid).collection('contacts').add({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(), // Store address in Firebase
        'profilePhoto': '', // Placeholder for profile photo
        'isFavorite': isFavorite,// Favorite field added
      });

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Contact",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xFF4361ee),iconTheme: IconThemeData(color: Colors.white),),
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa2d2ff), Color(0xFFFFFFF)], // Light blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView( // Makes the content scrollable when the keyboard opens
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20.0, 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Text(
                    //   "New Contact",
                    //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4361ee)),
                    // ),
                    // const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: const Icon(Icons.home),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: addContact,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Color(0xFF4361ee),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Save Contact",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
