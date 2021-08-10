import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientMedication extends StatefulWidget {

  String phone;
  PatientMedication(this.phone);

  @override
  _PatientMedicationState createState() => _PatientMedicationState(phone);
}

class _PatientMedicationState extends State<PatientMedication> {

  String phone;
  _PatientMedicationState(this.phone);

  Future<QuerySnapshot> _getMedications() async {
    var snapShot = await FirebaseFirestore.instance
        .collection("patients")
        .where("mobile", isEqualTo: phone)
        .get();
    var snapShot2 = await FirebaseFirestore.instance.collection("patients").doc(snapShot.docs[0].id).collection("medications").get();
    return snapShot2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        // <2> Pass `Future<QuerySnapshot>` to future
          future: _getMedications(),
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
                          subtitle: Text(doc['medication']),
                        ),
                      ),
                    ),
                  ))
                      .toList());
            } else {
              return Text("No medication records yet", style: TextStyle(color: Colors.black),);
            }
          }),
    );
  }
}