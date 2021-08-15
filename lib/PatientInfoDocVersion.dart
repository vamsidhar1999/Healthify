import 'package:cloud_firestore/cloud_firestore.dart';
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
  int _defaultChoiceIndex = 0;
  bool isSelected = false;
  TextEditingController _medicine = new TextEditingController();

  List<String> repeat = ["Before Meals", "After Meals"];
  List<String> time = ["Morning", "Afternoon", "Night"];



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
                              Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: List<Widget>.generate(
                                  2,
                                      (int index) {
                                    return ChoiceChip(
                                      label: Text(repeat[index]),
                                      selected: isSelected,
                                      selectedColor: Colors.blue,
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
                              MultiSelectChip(time),
                              ElevatedButton(
                                  onPressed: () async {
                                    Map<String, String> data = <String, String>{
                                      "time": repeat[_defaultChoiceIndex],
                                      "record": _medicine.text
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
                                        .collection("Medications")
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
        onPressed: _addMedication
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  MultiSelectChip(this.reportList);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
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