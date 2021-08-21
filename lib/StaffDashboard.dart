import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/PatientInfoStaffVersion.dart';
import 'package:healthify/selectRoom.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({Key key}) : super(key: key);

  @override
  _StaffDashboardState createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {

  Future<QuerySnapshot> _getDoc() async {
    return FirebaseFirestore.instance
        .collection('patients')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Dashboard"),
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
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        (PatientInfoStaffVersion(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SelectRoom()));
        },
      ),
    );
  }
}