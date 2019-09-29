import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/CustomWidgets/CalendarEventManagement.dart';
import 'package:Surprize/Helper/AppHelper.dart';

class CustomEventWidgetCard extends StatelessWidget {
  String _photoUrl;
  String _title;
  String _desc;
  DateTime _time;

  CustomEventWidgetCard(this._photoUrl, this._title, this._desc, this._time);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getCard(context);
  }

  Widget getCard(context) {
    return Container(
      child: Card(
        color: Colors.purple[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                     // color: Colors.purple[700],
                      child: FadeInImage.assetNetwork(placeholder: ImageResources.emptyImageLoadingUrlPlaceholder,
                          image: _photoUrl,  width: double.infinity, height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.cover,)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle
                    ),

                    child: IconButton(
                        icon: Icon(Icons.alarm_add, color: Colors.white),
                        onPressed: () {
                          CalendarEventManagement()
                              .addEventToCalendar(_title, _desc, _time, _time)
                              .then((value) {})
                              .catchError((error) {
                            print(error);
                          });
                        }),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            child: Text(_title,
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(AppHelper.dateToReadableString(_time),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0, top: 4.0),
                      child: Text(_desc,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white,
                              fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
