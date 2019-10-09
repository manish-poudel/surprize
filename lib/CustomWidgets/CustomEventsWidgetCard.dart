import 'package:Surprize/CountDownTimerTypeEnum.dart';
import 'package:Surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';
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
              alignment: Alignment.topLeft,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                     // color: Colors.purple[700],
                      child: FadeInImage.assetNetwork(placeholder: ImageResources.emptyImageLoadingUrlPlaceholder,
                          image: _photoUrl,  width: double.infinity, height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.cover,)),
                ),
                GestureDetector(
                  onTap: (){
                    CalendarEventManagement()
                        .addEventToCalendar(_title, _desc, _time, _time)
                        .then((value) {})
                        .catchError((error) {
                      print(error);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 170,
                      padding: EdgeInsets.only(top:2, bottom: 2, left: 1),
                      decoration: new BoxDecoration(
                          color: Colors.black54,
                          border: new Border.all(color: Colors.black26, width: 0),
                          borderRadius: new BorderRadius.all(Radius.circular(8.0))
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle
                            ),

                            child: IconButton(
                                icon: Icon(Icons.add_alarm, size: 16, color: Colors.white),
                                onPressed: () {
                                  CalendarEventManagement()
                                      .addEventToCalendar(_title, _desc, _time, _time)
                                      .then((value) {})
                                      .catchError((error) {
                                    print(error);
                                  });
                                }),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:2.0),
                            child: CustomCountDownTimerWidget(false,18,true, _time.difference(DateTime.now()),
                                StringResources.countDownTimeString,
                                64,
                                250,
                                Colors.white,
                                Colors.redAccent,
                                CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_NOT_AVAILABLE),
                          ),
                        ],
                      ),
                    ),
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
