import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectRoom extends StatefulWidget {
  const SelectRoom({Key key}) : super(key: key);

  @override
  _SelectRoomState createState() => _SelectRoomState();
}

class _SelectRoomState extends State<SelectRoom> {

  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Room"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
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
                items: ["Select", "shared", "private"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          FutureBuilder<QuerySnapshot>(
            // <2> Pass `Future<QuerySnapshot>` to future
              future: FirebaseFirestore.instance
        .collection('beds')
        .where("status", isEqualTo: "available")
        .where("type", isEqualTo: dropdownValue)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                  final List<DocumentSnapshot> documents = snapshot.data.docs;
                  return ListView(
                      shrinkWrap: true,
                      children: documents
                          .map((doc) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0.0, 3.0),
                                  blurRadius: 25.0)
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(doc['room']),
                              subtitle: Text("floor : "+doc['floor']),
                            ),
                          ),
                        ),
                      ))
                          .toList());
                } else {
                  return Text("It's Error!");
                }
              }),
        ],
      ),
    );
  }
}
