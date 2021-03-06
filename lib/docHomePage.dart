import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/PatientInfoDocVersion.dart';

class DocHomePage extends StatefulWidget {
  const DocHomePage({Key key}) : super(key: key);

  @override
  _DocHomePageState createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  Future<QuerySnapshot> _getDoc() async {
    var snapShot = await FirebaseFirestore.instance
        .collection('doctors')
        .where("mobile",
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber
                .toString()
                .substring(3))
        .get();
    String name = snapShot.docs[0].data()["name"];
    return FirebaseFirestore.instance
        .collection('patients')
        .where("doctor", isEqualTo: name)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Patients"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text('Menu', style: TextStyle(color: Colors.white),),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => EnterMobile()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<QuerySnapshot>(
              // <2> Pass `Future<QuerySnapshot>` to future
              future: _getDoc(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                  final List<DocumentSnapshot> documents = snapshot.data.docs;
                  return ListView(
                      shrinkWrap: true,
                      children: documents
                          .map((doc) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0.0, 3.0),
                                          blurRadius: 25.0)
                                    ],
                                  ),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(doc['name']),
                                      subtitle: Text(doc['diagnosis']),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (PatientInfoDocVersion(
                                                        Text(doc['mobile']).data))));
                                      },
                                    ),
                                  ),
                                ),
                              ))
                          .toList());
                } else {
                  return Text("It's Error!");
                }
              }),
        ],
      ),
    );
  }
}
