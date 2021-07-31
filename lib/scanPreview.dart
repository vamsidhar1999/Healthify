import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/BarCodeScanner.dart';

class ScanPreview extends StatefulWidget {
  const ScanPreview({Key key}) : super(key: key);

  @override
  _ScanPreviewState createState() => _ScanPreviewState();
}

class _ScanPreviewState extends State<ScanPreview> {

  String name="";
  String mobile="";
  String room="";
  String floor="";
  String age="";
  String gender="";
  String doctor="";


  _get () async {
    var snapShot = await FirebaseFirestore.instance.collection("patients")
        .where("mobile", isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.toString().substring(3))
        .get();
    setState(() {
      name = snapShot.docs[0].data()["name"];
      floor = snapShot.docs[0].data()["floor"];
      mobile = snapShot.docs[0].data()["mobile"];
      gender = snapShot.docs[0].data()["gender"];
      age = snapShot.docs[0].data()["age"];
      doctor = snapShot.docs[0].data()["doctor"];
      room = snapShot.docs[0].data()["room"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("Patient Name"),
              Text(name),
            ],
          ),
          Row(
            children: [
              Text("Mobile"),
              Text(mobile),
            ],
          ),
          Row(
            children: [
              Text("Age"),
              Text(age),
            ],
          ),
          Row(
            children: [
              Text("Gender"),
              Text(gender),
            ],
          ),
          Row(
            children: [
              Text("Doctor Name"),
              Text(doctor),
            ],
          ),
          Row(
            children: [
              Text("floor - $floor, "),
              Text(room),
            ],
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (BarCodeScanner())));
          }, child: Text("Scan"))
        ],
      ),
    );
  }
}
