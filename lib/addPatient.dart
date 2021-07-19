import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Dashboard.dart';
import 'package:healthify/styles.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key key}) : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {

  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _diagnosis = TextEditingController();
  int gender_value = 0;

  String dropdownValue = 'Select';
  List<String> doctors = ['Select'];
  List<int> docId = [];

  final _formKey = GlobalKey<FormState>();

  textField(String text, var controller) {
    return Padding(
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
          controller: controller,
          cursorColor: Colors.purple,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            labelText: text,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
      _getDoctors();
    super.initState();
  }

  _getDoctors() async {
    var snapShot = await FirebaseFirestore.instance.collection("doctors").get();
    snapShot.docs.forEach((element) {
      doctors.add(element.data()["name"]);
      docId.add(element.data()["id"]);
    });
    setState(() {});
  }

  _admit() async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = <String, dynamic>{
      "name": _name.text,
      "age": _age.text,
      "gender": gender_value == 0 ? "Male": "Female",
      "mobile": user.phoneNumber,
      "doctor": dropdownValue
    };
    FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .set(data)
        .then((value) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admit Patient"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              textField("Patient Name", _name),
              textField("Age", _age),
              textField("Mobile", _mobile),
              textField("Address", _address),
              textField("Diagnosis", _diagnosis),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Gender'),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => gender_value = 0),
                      child: Container(
                          height: 50,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: gender_value == 0
                                ? const Color(0xffeda5f0)
                                : Colors.grey,
                          ),
                          child: Center(
                            child: Text("M"),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => gender_value = 1),
                      child: Center(
                        child: Container(
                            height: 50,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: gender_value == 1
                                  ? const Color(0xffeda5f0)
                                  : Colors.grey,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    "F",
                                    ),
                                ))),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: DropdownButtonFormField<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  validator: (value) {
                    if (value == "Select" || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: doctors
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        if (_formKey.currentState.validate()) {
                          _admit();
                        }
                      },
                      child: Text(
                        "Submit", style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}