import 'package:flutter/material.dart';
import 'package:surprize/Resources/ImageResources.dart';

class CustomEventWidgetCard extends StatelessWidget {

  String _photoUrl;
  String _title;
  String _desc;
  String _time;

  CustomEventWidgetCard(this._photoUrl, this._title, this._desc, this._time);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Image.asset(ImageResources.appMainIcon,
                height: 152, width: 158),
            Container(
              color:Colors.grey[200],
              height: 1,
              width: 120,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(_title,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.purple[900],
                        fontWeight: FontWeight.w500,
                        fontSize: 20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_desc,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.grey,
                      fontSize: 18)),
            ),
            Text(_time,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                    fontSize: 16)),

            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Container(
                decoration: new BoxDecoration(
                    color:Colors.purple,
                    border:
                    new Border.all(color: Colors.purple, width: 1),
                    borderRadius:
                    new BorderRadius.all(Radius.circular(40.0))),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.alarm, color:Colors.white),
                      Padding(
                        padding: const EdgeInsets.only(left:4.0),
                        child: Text("Set Reminder",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}