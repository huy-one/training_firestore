import 'package:flutter/material.dart';
class CustomAlert{
  static void showCustomAlert(BuildContext context,String name,String age,String title){
    showDialog(context: context, builder: (context)=>new AlertDialog(
      title: Text(title),
      content: Row(
        children: [
          Text(name),
          Text(age),
        ],
      ),
      actions: [
        FlatButton(onPressed: (){
          Navigator.of(context).pop(context);
        }, child: Text('OK'))
      ],
    ));
  }

  }
