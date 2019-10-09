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

  Map<String, Events> _eventsList = new Map();


  @override
  void initState() {
    getEventsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return displayEventList();
  }

  /// Get event list
  Widget displayEventList(){
    if(_eventsList.length == 0)
      return noEventDisplay();

    return eventDisplay();

  }

  /// Get event list
  void getEventsList(){
    FirestoreOperations().getMainCollectionSnapshot(FirestoreResources.collectionEvent).listen((querySnapshot){
       querySnapshot.documentChanges.toList().forEach((documentSnapshot){
          setState(() {
            Events event = Events.fromMap(documentSnapshot.document.data);
            if(_eventsList.containsKey(event.id)){
              _eventsList[event.id] = event;
            }
             _eventsList.putIfAbsent(event.id, () => event);
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

  /// Event display widget
  Widget eventDisplay(){

    List<Events> eventList = _eventsList.values.toList();

    return Container(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: eventList.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomEventWidgetCard(eventList[index].photoUrl,
                eventList[index].title, eventList[index].desc, eventList[index].time);
          }),
    );
  }
}