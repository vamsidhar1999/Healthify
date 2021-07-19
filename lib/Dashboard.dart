import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/addPatient.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
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
              context, MaterialPageRoute(builder: (context) => AddPatient()));
        },
      ),
    );
  }
}
