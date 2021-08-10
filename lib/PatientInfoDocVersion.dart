import 'package:flutter/material.dart';
import 'package:healthify/PatientCaseSheets.dart';
import 'package:healthify/PatientMedication.dart';

class PatientInfoDocVersion extends StatefulWidget {

  String phone;
  PatientInfoDocVersion(this.phone);

  @override
  _PatientInfoDocVersionState createState() => _PatientInfoDocVersionState(phone);
}

class _PatientInfoDocVersionState extends State<PatientInfoDocVersion> {

  String phone;
  _PatientInfoDocVersionState(this.phone);

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){

        },
      ),
    );
  }
}