import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRoundedEdgeButton extends StatelessWidget{

   Function onClicked;
   Color color;
   String text;

  CustomRoundedEdgeButton({this.onClicked, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  FlatButton(
        onPressed: onClicked,
        child: Container(
            decoration: BoxDecoration(
                color: color,
                border: new Border.all(color: color, width: 0.5),
                borderRadius:
                new BorderRadius.all(Radius.circular(21.0))),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 18,  fontWeight:FontWeight.w400, color: Colors.white,
                  ),
                ))));
  }

}