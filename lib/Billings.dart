import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Billings extends StatefulWidget {
  String phone;
  Billings(this.phone);

  @override
  _BillingsState createState() => _BillingsState(phone);
}

class _BillingsState extends State<Billings> {

  String phone;
  _BillingsState(this.phone);

  TextEditingController _item = TextEditingController();
  TextEditingController _amount = TextEditingController();
  int time = 0;

    Future<QuerySnapshot> _getDoc() async {
      var snapShot = await FirebaseFirestore.instance
          .collection('patients')
          .where("mobile", isEqualTo: phone)
          .get();
      return FirebaseFirestore.instance
          .collection('patients')
          .doc(snapShot.docs[0].id)
          .collection("billings")
          .get();
    }

  _addBillings() {
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
                            title: Text('Bills'),
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
                                    controller: _item,
                                    cursorColor: Colors.purple,
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      labelText: "Enter Item name",
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
                                    controller: _amount,
                                    cursorColor: Colors.purple,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      labelText: "Enter amount",
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
                              ElevatedButton(
                                  onPressed: () async {
                                    Map<String, dynamic> data = <String, dynamic>{
                                      "time": DateTime.now().millisecondsSinceEpoch,
                                      "amount": int.parse(_amount.text),
                                      "billing_item": _item.text
                                    };
                                    Navigator.of(context).pop();
                                    var snapShot = await FirebaseFirestore.instance
                                        .collection("patients")
                                        .where("mobile", isEqualTo: phone)
                                        .get();
                                    FirebaseFirestore.instance
                                        .collection("patients")
                                        .doc(snapShot.docs[0].id)
                                        .collection("billings")
                                        .doc()
                                        .set(data);
                                    var snapShot1 =await FirebaseFirestore.instance
                                        .collection("patients")
                                        .doc(snapShot.docs[0].id)
                                        .get();
                                    int amount = snapShot1.data()["total_amount_due"];
                                    if(_item.text == "Amount paid"){
                                      FirebaseFirestore.instance
                                          .collection("patients")
                                          .doc(snapShot.docs[0].id)
                                          .update({"total_amount_due": amount-int.parse(_amount.text)});
                                    }else {
                                      FirebaseFirestore.instance
                                          .collection("patients")
                                          .doc(snapShot.docs[0].id)
                                          .update({
                                        "total_amount_due": amount +
                                            int.parse(_amount.text)
                                      });
                                    }},
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
        backgroundColor: Colors.purple,
        title: Text("Billings"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        // <2> Pass `Future<QuerySnapshot>` to future
          future: _getDoc(),
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
                          title: Text(doc['billing_item']+" - "+doc['amount'].toString()),
                          subtitle: Text(DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(doc["time"])).toString()),
                        ),
                      ),
                    ),
                  ))
                      .toList());
            } else {
              return Text("It's Error!");
            }
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: _addBillings),
    );
  }
}
