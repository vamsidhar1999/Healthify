import 'package:flutter/material.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({Key key}) : super(key: key);

  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
