import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditContactScreen.dart';

class ContactDetailsScreen extends StatefulWidget {
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
  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }
  void _loadFavoriteStatus() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('contacts')
        .doc(widget.contactId)
        .get();

    if (doc.exists && doc.data() != null) {
      setState(() {
        isFavorite = doc['isFavorite'] is bool ? doc['isFavorite'] : false;
      });
    }
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('contacts')
        .doc(widget.contactId)
        .update({'isFavorite': isFavorite});
  }

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
          .doc(widget.uid)
          .collection('contacts')
          .doc(widget.contactId)
          .delete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.profilePhoto.isNotEmpty
                  ? NetworkImage(widget.profilePhoto)
                  : null,
              child: widget.profilePhoto.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
              backgroundColor: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(widget.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Phone: ${widget.phone}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text("Email: ${widget.email}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text("Address: ${widget.address}", style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
                size: 40,
              ),
              onPressed: _toggleFavorite,
            ),
           // const SizedBox(height: 10),

                IconButton(

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContactScreen(
                          contactId: widget.contactId,
                          name: widget.name,
                          phone: widget.phone,
                          email: widget.email,
                          address: widget.address,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit,size: 30,),
                  tooltip: "Edit Contact",

                ),
                IconButton(
                  onPressed: () => deleteContact(context),
                  icon: const Icon(Icons.delete,size: 30,),
                  tooltip: "Delete Contact",
                ),
              ],
            ),
            const SizedBox(height: 20),],
        ),
            //

      ),
      );

  }


}
