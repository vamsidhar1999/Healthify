import 'package:flutter/material.dart';
import 'package:healthify/PatientCaseSheets.dart';
import 'package:healthify/PatientMedication.dart';

class PatientInfoStaffVersion extends StatefulWidget {

  String phone;
  PatientInfoStaffVersion(this.phone);

  @override
  _PatientInfoStaffVersionState createState() => _PatientInfoStaffVersionState(phone);
}

class _PatientInfoStaffVersionState extends State<PatientInfoStaffVersion> {

  String phone;
  _PatientInfoStaffVersionState(this.phone);

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
          return AlertDialog(
            title: const Text('Case Sheets'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('This is a demo alert dialog.'),
                  
                  Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}