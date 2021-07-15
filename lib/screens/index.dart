import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:training_firestore/screens/UpdateAlert.dart';

import 'custom_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  final Stream<QuerySnapshot> student =
      FirebaseFirestore.instance.collection("students").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("STUDENTS MANAGER"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Name ", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _ageController,
                decoration: InputDecoration(
                    labelText: "Age ", border: OutlineInputBorder()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    onADDClick();
                  },
                  child: Text("ADD"),
                  color: Colors.red,
                ),
                FlatButton(
                  onPressed: () {
                    onFindClick();
                  },
                  child: Text("FIND"),
                  color: Colors.red,
                ),
                FlatButton(
                  onPressed: () {
                    onUpdateClick();
                  },
                  child: Text("UPDATE"),
                  color: Colors.red,
                ),
                FlatButton(
                  onPressed: () {
                    onDeleteClick();
                  },
                  child: Text("DELETE"),
                  color: Colors.red,
                ),
              ],
            ),

            //reading data from fire store
            Container(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                  stream: student,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("error ${snapshot.error}"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _nameController.text=data['name'];
                              _ageController.text=data['age'];
                            });
                          },
                          child: ListTile(
                            title: Text(data['name']),
                            subtitle: Text(data['age']),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  CollectionReference reference =
      FirebaseFirestore.instance.collection("students");

  void onADDClick() {
    var name = _nameController.text;
    var age = _ageController.text;
    reference.add({
      'name': name,
      'age': age,
    }).then((values) =>
        CustomAlert.showCustomAlert(context, name, age, "ADD done"));
  }

  Future<void> onFindClick() async {
    var name = _nameController.text;
    return reference
        .where('name', isEqualTo: name)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              CustomAlert.showCustomAlert(
                  context, element['name'], element['age'], "FIND done");
            }));
  }

  Future<void> onUpdateClick() async {
    TextEditingController _userController = new TextEditingController();
    TextEditingController _ageUpController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Update"),
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _userController,
                      decoration: InputDecoration(
                          labelText: "UserName", border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _ageUpController,
                      decoration: InputDecoration(
                          labelText: "Age ", border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    var name = _nameController.text;
                    var user = _userController.text;
                    var age = _ageUpController.text;
                    WriteBatch batch = FirebaseFirestore.instance.batch();
                     reference
                        .where('name', isEqualTo: name)
                        .get()
                        .then((querySnapshot) {
                      querySnapshot.docs.forEach((document) {
                        batch.update(
                            document.reference, {'age': age, 'name': user});
                      });
                      return batch.commit();
                    });
                  },
                  child: Text("UPDATE"),
                  color: Colors.red,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    child: Text('OK'))
              ],
            ));
  }

  Future<void> onDeleteClick() async {
    var name = _nameController.text;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return reference.where('name', isEqualTo: name).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
      return batch.commit();
    });
  }
}
