import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/PatientCaseSheets.dart';
import 'package:healthify/PatientMedication.dart';
import 'package:intl/intl.dart';

class PatientInfoDocVersion extends StatefulWidget {

  String phone;
  PatientInfoDocVersion(this.phone);

  @override
  _PatientInfoDocVersionState createState() => _PatientInfoDocVersionState(phone);
}

class _PatientInfoDocVersionState extends State<PatientInfoDocVersion> {

  String phone;
  _PatientInfoDocVersionState(this.phone);
  int _defaultChoiceIndex = 0;
  bool isSelected = false;
  TextEditingController _medicine = new TextEditingController();
  TextEditingController _days = new TextEditingController();

  List<String> repeat = ["Before Meals", "After Meals"];
  List<String> time = ["Morning", "Afternoon", "Night"];

  List<String> selectedReportList = [];

  String temperature = "0.0";
  String pulse = "0";

  String name="";
  String mobile="";
  String room="";
  String floor="";
  String age="";
  String gender="";
  String doctor="";
  int admit_time=0;

  _get () async {
    var snapShot = await FirebaseFirestore.instance.collection("patients")
        .where("mobile", isEqualTo: phone)
        .get();
    setState(() {
      name = snapShot.docs[0].data()["name"];
      floor = snapShot.docs[0].data()["floor"];
      mobile = snapShot.docs[0].data()["mobile"];
      gender = snapShot.docs[0].data()["gender"];
      age = snapShot.docs[0].data()["age"];
      doctor = snapShot.docs[0].data()["doctor"];
      room = snapShot.docs[0].data()["room"];
      admit_time = snapShot.docs[0].data()["admitted_time"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _get();
    super.initState();
  }

  _addMedication() {
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
                            title: Text('Medication'),
                            children: <Widget>[
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
                                    controller: _medicine,
                                    cursorColor: Colors.purple,
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      labelText: "Medicine Name",
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
                                    controller: _days,
                                    cursorColor: Colors.purple,
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      labelText: "No of Days",
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: List<Widget>.generate(
                                    2,
                                        (int index) {
                                      return ChoiceChip(
                                        label: Text(repeat[index]),
                                        selected: index == _defaultChoiceIndex,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _defaultChoiceIndex = selected ? index : index;
                                          });
                                        },
                                        // backgroundColor: primaryColor,
                                        labelStyle: TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MultiSelectChip(time, onSelectionChanged: (selectedList) {
                                  print(selectedList);
                                  setState(() {
                                    selectedReportList = selectedList;
                                  });
                                },),
                              ),
                              Center(
                                child: MaterialButton(
                                  color: Colors.purple,
                                    onPressed: () async {
                                      Map<String, dynamic> data = <String, dynamic>{
                                        "time": selectedReportList,
                                        "meals": repeat[_defaultChoiceIndex],
                                        "medicine": _medicine.text,
                                        "days": _days.text
                                      };
                                      Navigator.of(context).pop();
                                      var snapShot = await FirebaseFirestore.instance
                                          .collection("patients")
                                          .where("mobile", isEqualTo: phone)
                                          .get();
                                      print(selectedReportList);
                                      FirebaseFirestore.instance
                                          .collection("patients")
                                          .doc(snapShot.docs[0].id)
                                          .collection("Medications")
                                          .doc()
                                          .set(data);
                                    },
                                    child: Text("Submit", style: TextStyle(color: Colors.white),)),
                              ),
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

  void handleClick(String value) async {
    switch (value) {
      case 'Discharge':
          var snapShot = await FirebaseFirestore.instance
              .collection("patients")
              .where("mobile", isEqualTo: phone)
              .get();
          FirebaseFirestore.instance
              .collection("patients")
              .doc(snapShot.docs[0].id)
              .update({
            "admitted": "NO",
            "discharge_permission": true
          });
          break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Patient Info"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Discharge'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: DefaultTabController(length: 2, child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name :    "+name),
                    Text("Mobile :  "+mobile),
                    Text("Age :       "+age),
                    Text("Gender :  "+gender),
                    Text("Doctor :  "+doctor),
                    Text("floor & room - "+floor+", "+room),
                    Text("Admitted Date & Time - "+DateFormat('dd-MM-yyyy ??? kk:mm').format(DateTime.fromMillisecondsSinceEpoch(admit_time)).toString()),
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream:  FirebaseFirestore.instance.collection("patients").where("mobile", isEqualTo: phone).snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    // return Loader();
                  }
                  temperature = snapshot.data.docs[0]["temperature"].toString();
                  pulse = snapshot.data.docs[0]["pulse"].toString();
                  if (snapshot.connectionState == ConnectionState.done) {

                  }
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        //  color: snapshot.data,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("Temperature", style: TextStyle(color: Colors.white),),
                                    SizedBox(height: 10,),
                                    Text(temperature, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Pulse", style: TextStyle(color: Colors.white),),
                                    SizedBox(height: 10,),
                                    Text(pulse, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                    ),
                  );
                }),
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
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addMedication
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged; // +added
  MultiSelectChip(
      this.reportList,
      {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";
  // this function will build and return the choice list
  List<String> selectedChoices = [];
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}