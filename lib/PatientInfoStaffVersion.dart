import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:healthify/PatientCaseSheets.dart';
import 'package:healthify/PatientMedication.dart';

class PatientInfoStaffVersion extends StatefulWidget {
  String phone;
  PatientInfoStaffVersion(this.phone);

  @override
  _PatientInfoStaffVersionState createState() =>
      _PatientInfoStaffVersionState(phone);
}

class _PatientInfoStaffVersionState extends State<PatientInfoStaffVersion> {
  String phone;
  _PatientInfoStaffVersionState(this.phone);

  String time="Select Time";
  TextEditingController _timeController = TextEditingController();
  TextEditingController _record = TextEditingController();

  _addCaseSheets() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      // height: 500,
                      child: Column(
                        children: [
                          SimpleDialog(
                            title: Text('Case Sheets'),
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _selectTime(context).then((value) {
                                    setState(() {
                                      time = value.toString();
                                    });
                                  });
                                },
                                child: Text(time)
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                    controller: _record,
                                    cursorColor: Colors.purple,
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      labelText: "Enter Case Sheets",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.purple),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.purple),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    Map<String, String> data = <String, String>{
                                      "time": time,
                                      "record": _record.text
                                    };
                                    Navigator.of(context).pop();
                                    var snapShot = await FirebaseFirestore.instance
                                        .collection("patients")
                                        .where("mobile", isEqualTo: phone)
                                        .get();
                                    print(phone);
                                    FirebaseFirestore.instance
                                        .collection("patients")
                                        .doc(snapShot.docs[0].id)
                                        .collection("CaseSheets")
                                        .doc()
                                        .set(data);
                                  },
                                  child: Text("Submit")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<dynamic> _selectTime(BuildContext context) async {
    // String temp = '';
    TimeOfDay time = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) {
      setState(() {
        //temp = picked.format(context);
        //time1 = picked.hour.toString() + ':' + picked.minute.toString();
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Info"),
      ),
      body: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Medications",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Case Sheets",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: TabBarView(children: [
                  PatientMedication(phone),
                  PatientCaseSheets(phone)
                ]),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: _addCaseSheets),
    );
  }
}
