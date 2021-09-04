import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({Key key}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {

  String name="";
  String mobile="";
  String room="";
  String floor="";
  String age="";
  String gender="";
  String doctor="";
  int admit_time=0;
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
      admit_time = snapShot.docs[0].data()["admitted_time"];
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
      appBar: PreferredSize(
          child: ClipPath(
            clipper: CustomAppBar(),
            child: Container(
              color: Colors.purple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, image: DecorationImage(image: AssetImage('images/profile.jpg'))),
                          ),
                        ),
                        Text(name, style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight + 120)),
        // backgroundColor: backgroundColor,
      body: Column(
        children: <Widget>[
          // Row(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(15.0),
          //       child: Container(
          //         width: MediaQuery.of(context).size.width - 38,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.rectangle,
          //           //border: Border.all(width: 5.0, color: Colors.white),
          //           borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(8.0),
          //               topRight: Radius.circular(20.0),
          //               bottomLeft: Radius.circular(8.0),
          //               bottomRight: Radius.circular(20.0)),
          //           color: Colors.grey.shade300,
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(20.0),
          //           child: Text(name,
          //               style: TextStyle(
          //                   color: Colors.black,
          //                   fontStyle: FontStyle.italic,
          //                   fontSize: 20)),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //border: Border.all(width: 5.0, color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Mobile : "+mobile,
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //border: Border.all(width: 5.0, color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Age : "+age,
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //border: Border.all(width: 5.0, color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Gender : "+gender,
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //border: Border.all(width: 5.0, color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Consultant\nDoctor :         "+doctor,
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //border: Border.all(width: 5.0, color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("floor & room - "+floor+", "+room,
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height);

    path.quadraticBezierTo(
        size.width - (size.width / 3), size.height, size.width, size.height);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}