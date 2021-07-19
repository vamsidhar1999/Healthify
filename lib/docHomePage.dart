import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocHomePage extends StatefulWidget {
  const DocHomePage({Key key}) : super(key: key);

  @override
  _DocHomePageState createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  _getDoc() async {
    var snapShot = await FirebaseFirestore.instance
        .collection('doctors')
        .where("mobile",
        isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get();
    String name = snapShot.docs[0].data()["name"];
    return FirebaseFirestore.instance
        .collection('user')
        .where("doctor",
        isEqualTo: name)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients"),
      ),
      body: FutureBuilder<QuerySnapshot>(
          // <2> Pass `Future<QuerySnapshot>` to future
          future: _getDoc(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // <3> Retrieve `List<DocumentSnapshot>` from snapshot
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              return ListView(
                  children: documents
                      .map((doc) => Card(
                            child: ListTile(
                              title: Text(doc['name']),
                              subtitle: Text(doc['diagnosis']),
                            ),
                          ))
                      .toList());
            } else {
              return Text("It's Error!");
            }
          }),
    );
  }
}
