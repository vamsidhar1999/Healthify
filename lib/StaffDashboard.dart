import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/addPatient.dart';
import 'package:healthify/selectRoom.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({Key key}) : super(key: key);

  @override
  _StaffDashboardState createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text("Logout"),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (EnterMobile())));
            },
          ),
        ),
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
