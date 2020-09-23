import 'package:flutter/material.dart';

// TODO: update UI

Future updateLocationPopup(BuildContext context) async {
    String inputCity;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter desired location'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (input) {
                    inputCity = input;
                  },
                  decoration: InputDecoration(
                    labelText: 'City Name',
                    hintText: 'New York',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () { 
                Navigator.pop(context, inputCity);
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]
        );
      },
    );
  }