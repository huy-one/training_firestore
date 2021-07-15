import 'package:flutter/material.dart';
class UpdateAlert {
    static void showUpateAlert(BuildContext context,TextEditingController name,TextEditingController age,Future<void> press){
       showDialog(context: context, builder: (context)=> AlertDialog(
        title: Text("Update"),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    labelText: "Age ", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: age,
                decoration: InputDecoration(
                    labelText: "Age ", border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: () {
              press;
            },
            child: Text("UPDATE"),
            color: Colors.red,
          ),
          FlatButton(onPressed: (){
            Navigator.of(context).pop(context);
          }, child: Text('OK'))
        ],
      ));
    }
    }