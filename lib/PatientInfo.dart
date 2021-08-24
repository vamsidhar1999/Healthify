import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/PatientCaseSheets.dart';
import 'package:healthify/PatientMedication.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({Key key}) : super(key: key);

  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {

  String phone = FirebaseAuth.instance.currentUser.phoneNumber.substring(3);
  String temperature = "0.0";
  String pulse = "0";

  _get() async{
    var snapShot = await FirebaseFirestore.instance.collection("patients").doc(FirebaseAuth.instance.currentUser.uid).get();
    return snapShot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Patient Info"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => EnterMobile()));
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(length: 2, child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("patients").doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    // return Loader();
                  }
                  temperature = snapshot.data["temperature"].toString();
                  pulse = snapshot.data["pulse"].toString();
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
    );
  }
}