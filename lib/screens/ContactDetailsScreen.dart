import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditContactScreen.dart';

class ContactDetailsScreen extends StatelessWidget {
  final String contactId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String profilePhoto;
  final String uid;

  const ContactDetailsScreen({
    Key? key,
    required this.contactId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.profilePhoto,
    required this.uid,
  }) : super(key: key);

  void deleteContact(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this contact?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('contacts')
          .doc(contactId)
          .delete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePhoto.isNotEmpty
                  ? NetworkImage(profilePhoto)
                  : null,
              child: profilePhoto.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
              backgroundColor: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Phone: $phone", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text("Email: $email", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text("Address: $address", style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContactScreen(
                          contactId: contactId,
                          name: name,
                          phone: phone,
                          email: email,
                          address: address,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
                ElevatedButton.icon(
                  onPressed: () => deleteContact(context),
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
