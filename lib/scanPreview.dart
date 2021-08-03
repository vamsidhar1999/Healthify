import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      };
      FirebaseFirestore.instance
          .collection("patients")
          .doc(user.uid)
          .update(data)
          .then((value) async {
        var snapShot = await FirebaseFirestore.instance.collection("beds").where("floor", isEqualTo: floor)
            .where("room", isEqualTo: room).get();
        FirebaseFirestore.instance.collection("beds").doc(snapShot.docs[0].id).update({"status":"filled"});
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
          ElevatedButton(onPressed: scanBarcodeNormal, child: Text("Scan"))
        ],
      ),
    );
  }
}