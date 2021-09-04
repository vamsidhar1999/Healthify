import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:healthify/PatientInfo.dart';

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
  String _scanBarcode = 'Unknown';

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

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _scanBarcode = barcodeScanRes;

    if(_scanBarcode.characters.characterAt(0).toString()==floor && _scanBarcode.substring(2)==room){
      final user = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> data = <String, dynamic>{
        "admitted": "YES",
        "admitted_time": DateTime.now().millisecondsSinceEpoch,
      };
      var snapShot1 = await FirebaseFirestore.instance.collection("patients").where("mobile", isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.substring(3)).get();
      FirebaseFirestore.instance
          .collection("patients")
          .doc(snapShot1.docs[0].id)
          .update(data)
          .then((value) async {
        var snapShot = await FirebaseFirestore.instance.collection("beds").where("floor", isEqualTo: floor)
            .where("room", isEqualTo: room).get();
        FirebaseFirestore.instance.collection("beds").doc(snapShot.docs[0].id).update({"status":"filled","uid":user.uid});
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PatientInfo()));
      });
    }else{
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Incorrect Room code scanned"),
            // content: SingleChildScrollView(
            //   child: ListBody(
            //     children: const <Widget>[
            //       Text('This is a demo alert dialog.'),
            //       Text('Would you like to approve of this message?'),
            //     ],
            //   ),
            // ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
        backgroundColor: Colors.purple,
        title: Text("Scan Code to Admission"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text("Patient Name : ", style: TextStyle(fontSize: 20),),
                  Text(name, style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text("Mobile : ", style: TextStyle(fontSize: 20),),
                  Text(mobile, style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text("Age : ", style: TextStyle(fontSize: 20),),
                  Text(age, style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text("Gender : ", style: TextStyle(fontSize: 20),),
                  Text(gender, style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text("Doctor Name : ", style: TextStyle(fontSize: 20),),
                  Text(doctor, style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text("floor - $floor, ", style: TextStyle(fontSize: 20),),
                  Text(room, style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue
            ),
            child: MaterialButton(
                onPressed: scanBarcodeNormal, child: Text("Scan", style: TextStyle(fontSize: 20, color: Colors.white),)
            ),
          ),
        ],
      ),
    );
  }
}