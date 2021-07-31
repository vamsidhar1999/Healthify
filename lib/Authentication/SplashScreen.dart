import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthify/Authentication/EnterMobile.dart';
import 'package:healthify/StaffDashboard.dart';
import 'package:healthify/docHomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getstatus();
    Future.delayed(Duration(seconds: 3), () {
      getstatus();
    });
  }

  void getstatus() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapShot = await FirebaseFirestore.instance
          .collection("doctors")
          .where("mobile",
              isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber
                  .toString()
                  .substring(3))
          .get();
      var snapShot1 = await FirebaseFirestore.instance
          .collection("patients")
          .where("mobile",
          isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber
              .toString()
              .substring(3))
          .get();
      if (snapShot.docs.length == 1) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => (DocHomePage())));
      } else {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StaffDashboard()));
      }
    } else {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EnterMobile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.purple,
              Colors.purpleAccent,
            ])),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/images/streelogo.png",
                // ),
                Text('Healthify',
                    style: TextStyle(fontSize: 45, color: Colors.white)),
              ],
            ),
            Center(
              child: Container(
                  // child: Image.asset("assets/images/ruralwomen.png"),
                  ),
            )
          ],
        )),
      ),
    );
  }
}
