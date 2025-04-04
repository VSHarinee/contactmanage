// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ContactDetailsScreen.dart';
// import 'add_contact_screen.dart';
// import 'EditContactScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String user;
//   const HomeScreen({super.key, required this.user});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String searchQuery = "";
//   final TextEditingController searchController = TextEditingController();
//
//
//   void logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   }
//
//   Future<String> fetchUserName(String uid) async {
//     try {
//       DocumentSnapshot userDoc =
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       return userDoc['name'] ?? "No name found";
//     } catch (e) {
//       return "Error loading name";
//     }
//   }
//
//   void toggleFavorite(String uid, String contactId, bool isFavorite) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('contacts')
//         .doc(contactId)
//         .update({'isFavorite': !isFavorite});
//   }
//
//   // void deleteContact(String uid, String contactId) async {
//   //   bool confirmDelete = await showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text("Confirm Delete"),
//   //       content: const Text("Are you sure you want to delete this contact?"),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context, false),
//   //           child: const Text("No"),
//   //         ),
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context, true),
//   //           child: const Text("Yes"),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   //
//   //   if (confirmDelete == true) {
//   //     await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(uid)
//   //         .collection('contacts')
//   //         .doc(contactId)
//   //         .delete();
//   //   }
//   // }
//
//   Widget _buildContactTile(QueryDocumentSnapshot contact, String uid) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: ListTile(
//           leading: contact['profilePhoto'] != ''
//               ? CircleAvatar(backgroundImage: NetworkImage(contact['profilePhoto']))
//               : const CircleAvatar(
//             child: Icon(Icons.person, color: Colors.white),
//             backgroundColor: Colors.blueAccent,
//           ),
//           title: Text(contact['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
//           subtitle: Text(contact['phone']),
//           trailing: IconButton(
//             icon: Icon(
//               contact['isFavorite'] == true ? Icons.star : Icons.star_border,
//               color: Colors.yellow,
//             ),
//             onPressed: () {
//               FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(uid)
//                   .collection('contacts')
//                   .doc(contact.id)
//                   .update({'isFavorite': !(contact['isFavorite'] ?? false)});
//             },
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ContactDetailsScreen(
//                   contactId: contact.id,
//                   name: contact['name'],
//                   phone: contact['phone'],
//                   email: contact['email'],
//                   address: contact['address'],
//                   profilePhoto: contact['profilePhoto'] ?? "",
//                   uid: uid,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       return Scaffold(
//         body: Center(child: Text("User not logged in")),
//       );
//     }
//     String uid = currentUser.uid;
//
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: FutureBuilder<String>(
//           future: fetchUserName(uid), // Fetch user's name
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Text("Welcome, ..."); // Show loading text
//             } else if (snapshot.hasError) {
//               return const Text("Welcome, User");
//             } else {
//               return Text("Welcome, ${snapshot.data}");
//             }
//           },
//         ),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: () => logout(context),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: TextField(
//                 controller: searchController,
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value.toLowerCase();
//                   });
//                 },
//                 decoration: InputDecoration(
//                   hintText: "Search Contacts...",
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(Icons.search, color: Colors.lightBlueAccent),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(uid)
//                     .collection('contacts')
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   var contacts = snapshot.data!.docs.where((contact) {
//                     String name = contact['name'].toLowerCase();
//                     String phone = contact['phone'].toLowerCase();
//                     return name.contains(searchQuery) || phone.contains(searchQuery);
//                   }).toList();
//
//                   return ListView.builder(
//                     itemCount: contacts.length,
//                     itemBuilder: (context, index) {
//                       var contact = contacts[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ListTile(
//                             leading: contact['profilePhoto'] != ''
//                                 ? CircleAvatar(
//                               backgroundImage: NetworkImage(contact['profilePhoto']),
//                             )
//                                 : const CircleAvatar(
//                               child: Icon(Icons.person, color: Colors.white),
//                               backgroundColor: Colors.blueAccent,
//                             ),
//                             title: Text(
//                               contact['name'],
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(contact['phone']),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ContactDetailsScreen(
//                                     contactId: contact.id,
//                                     name: contact['name'],
//                                     phone: contact['phone'],
//                                     email: contact['email'],
//                                     address: contact['address'],
//                                     profilePhoto: contact['profilePhoto'] ?? "",
//                                     uid: uid,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blueAccent,
//         child: const Icon(Icons.add, color: Colors.white),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddContactScreen()),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ContactDetailsScreen.dart';
import 'WelcomeScreen.dart';
import 'add_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  final String user;
  const HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  Future<String> fetchUserName(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc['name'] ?? "No name found";
    } catch (e) {
      return "Error loading name";
    }
  }

  void toggleFavorite(String uid, String contactId, bool isFavorite) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contactId)
        .update({'isFavorite': !isFavorite});
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }
    String uid = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: fetchUserName(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Welcome, ...",style: TextStyle(
                color: Colors.white, // Change text color
                fontSize: 20,       // Adjust font size (optional)
                fontWeight: FontWeight.bold, // Make text bold (optional)
              ),);
            } else if (snapshot.hasError) {
              return const Text("Welcome, User",style: TextStyle(
                color: Colors.white, // Change text color
                fontSize: 20,       // Adjust font size (optional)
                fontWeight: FontWeight.bold, // Make text bold (optional)
              ),);
            } else {
              return Text("Welcome, ${snapshot.data}",style: TextStyle(
                color: Colors.white, // Change text color
                fontSize: 20,       // Adjust font size (optional)
                fontWeight: FontWeight.bold, // Make text bold (optional)
              ),);
            }
          },
        ),
        backgroundColor: Color(0xFF4361ee),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa2d2ff), Color(0xFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Contacts...",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                  const Icon(Icons.search, color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('contacts')
                    .orderBy('name')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var contacts = snapshot.data!.docs.where((contact) {
                    Map<String, dynamic>? data =
                    contact.data() as Map<String, dynamic>?;
                    if (data == null || !data.containsKey('name')) return false;
                    String name = data['name'].toLowerCase();
                    return name.contains(searchQuery);
                  }).toList();

                  List<QueryDocumentSnapshot> favorites = [];
                  Map<String, List<QueryDocumentSnapshot>> groupedContacts = {};

                  for (var contact in contacts) {
                    Map<String, dynamic> data =
                    contact.data() as Map<String, dynamic>;
                    bool isFavorite = (data['isFavorite'] ?? false) as bool;

                    if (isFavorite) {
                      favorites.add(contact);
                    } else {
                      String firstLetter = data['name'][0].toUpperCase();
                      groupedContacts.putIfAbsent(firstLetter, () => []).add(contact);
                    }
                  }

                  return ListView(
                    children: [
                      if (favorites.isNotEmpty) ...[
                        const Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("Favorites",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...favorites.map((contact) =>
                            _buildContactTile(contact, uid)),
                      ],
                      for (var entry in groupedContacts.entries) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(entry.key,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...entry.value
                            .map((contact) => _buildContactTile(contact, uid)),
                      ]
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4361ee),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          );
        },
      ),
    );
  }

  Widget _buildContactTile(QueryDocumentSnapshot contact, String uid) {
    Map<String, dynamic> data = contact.data() as Map<String, dynamic>;
    bool isFavorite = (data['isFavorite'] ?? false) as bool;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: data['profilePhoto'] != null && data['profilePhoto'].isNotEmpty
            ? CircleAvatar(backgroundImage: NetworkImage(data['profilePhoto']))
            : const CircleAvatar(
          child: Icon(Icons.person, color: Colors.white),
          backgroundColor: Color(0xFF4361ee),
        ),
        title: Text(data['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(data['phone']),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () => toggleFavorite(uid, contact.id, isFavorite),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactDetailsScreen(
                contactId: contact.id,
                name: data['name'],
                phone: data['phone'],
                email: data['email'],
                address: data['address'],
                profilePhoto: data['profilePhoto'] ?? "",
                uid: uid,
              ),
            ),
          );
        },
      ),
    );
  }
}