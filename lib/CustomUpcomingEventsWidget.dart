import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomWidgets/CustomEventsWidgetCard.dart';
import 'Firestore/FirestoreOperations.dart';
import 'Models/Events.dart';
import 'Resources/FirestoreResources.dart';

class CustomUpcomingEventsWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomUpcomingEventsWidgetState();
  }

}
class CustomUpcomingEventsWidgetState extends State<CustomUpcomingEventsWidget>{

  List<Events> _eventsList = new List();

  double _height = 234;

  @override
  void initState() {
    getEventsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      height: _height,
      child: displayEventList(),
    );
  }

  /// Get event list
  Widget displayEventList(){

    Events event = new Events("", "1", "Daily quiz challenge", "Play and earn money",
        DateTime.now());
    _eventsList.clear();
    _eventsList.add(event);
    if(_eventsList.length == 0)
      return noEventDisplay();

    return eventDisplay();

  }

  /// Get event list
  void getEventsList(){
    FirestoreOperations().getMainCollectionSnapshot(FirestoreResources.collectionEvent).listen((querySnapshot){
       querySnapshot.documents.toList().forEach((documentSnapshot){
          setState(() {
            _height = 234;
            Events event = Events.fromMap(documentSnapshot.data);
             _eventsList.add(event);
          });
      });
    });
  }

  /// if there is no events
  Widget noEventDisplay(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.notifications_off, color:Colors.grey,size: 18),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text("No events"),
          ),
        ],
      );
  }

  Widget eventDisplay(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
        itemCount: _eventsList.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomEventWidgetCard(_eventsList[index].photoUrl,
              _eventsList[index].title, _eventsList[index].desc, _eventsList[index].time);
        });
  }
}