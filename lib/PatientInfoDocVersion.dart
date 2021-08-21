import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
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
  int _defaultChoiceIndex = 0;
  bool isSelected = false;
  TextEditingController _medicine = new TextEditingController();
  TextEditingController _days = new TextEditingController();

  List<String> repeat = ["Before Meals", "After Meals"];
  List<String> time = ["Morning", "Afternoon", "Night"];

  List<String> selectedReportList = [];



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Patient Info"),
        automaticallyImplyLeading: false,
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