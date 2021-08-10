import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/PatientCaseSheets.dart';
import 'package:healthify/PatientMedication.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({Key key}) : super(key: key);

  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {

  String phone = FirebaseAuth.instance.currentUser.phoneNumber.substring(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Info"),
      ),
      body: DefaultTabController(length: 2, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TabBar(
              tabs: [
                Tab(child: Text("Medications", style: TextStyle(color: Colors.black),),),
                Tab(child: Text("Case Sheets", style: TextStyle(color: Colors.black),),),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height/2,
            child: TabBarView(children: [
              PatientMedication(phone),
              PatientCaseSheets(phone)
            ]),
          )
        ],
      )),
    );
  }
}