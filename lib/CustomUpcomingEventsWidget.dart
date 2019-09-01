import 'package:flutter/cupertino.dart';
import 'package:surprize/CustomWidgets/CustomEventsWidget.dart';

import 'CustomWidgets/CustomEventsWidgetCard.dart';
import 'Firestore/FirestoreOperations.dart';
import 'Helper/AppHelper.dart';
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

  double _height = 20;

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

    _eventsList.add(_eventsList[0]);
    if(_eventsList.length == 0)
      return noEventDisplay();

    return eventDisplay();

  }

  /// Get event list
  void getEventsList(){
    FirestoreOperations().getMainCollectionSnapshot(FirestoreResources.collectionEvent).listen((querySnapshot){
       querySnapshot.documents.toList().forEach((documentSnapshot){
          setState(() {
            _height = 230;
            Events event = Events.fromMap(documentSnapshot.data);
            print("The event "+ event.title);
             _eventsList.add(event);
          });
      });
    });
  }

  /// if there is no events
  Widget noEventDisplay(){
      return Text("No events");
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