import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientCaseSheets extends StatefulWidget {

  String phone;
  PatientCaseSheets(this.phone);

  @override
  _PatientCaseSheetsState createState() => _PatientCaseSheetsState(phone);
}

class _PatientCaseSheetsState extends State<PatientCaseSheets> {

  _PatientCaseSheetsState(this.phone);
  String phone;

  Future<QuerySnapshot> _getCaseSheets() async {
    var snapShot = await FirebaseFirestore.instance
        .collection("patients")
        .where("mobile", isEqualTo: phone)
        .get();
    var snapShot2 = await FirebaseFirestore.instance.collection("patients").doc(snapShot.docs[0].id).collection("CaseSheets").get();
    return snapShot2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        // <2> Pass `Future<QuerySnapshot>` to future
          future: _getCaseSheets(),
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
                          title: Text(doc['time']),
                          subtitle: Text(doc['record']),
                        ),
                      ),
                    ),
                  ))
                      .toList());
            } else {
              return Text("No Case Sheet records yet", style: TextStyle(color: Colors.black),);
            }
          }),
    );
  }
}
