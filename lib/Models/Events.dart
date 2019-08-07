import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Resources/FirestoreResources.dart';

class Events{
  String photoUrl;
  String id;
  String title;
  String desc;
  DateTime time;

  Events(this.photoUrl, this.id, this.title, this.desc, this.time);


  Events.fromMap(Map<String, dynamic> map){
    photoUrl = map[FirestoreResources.fieldEventPhoto];
    id = map[FirestoreResources.fieldEventId];
    title = map[FirestoreResources.fieldEventTitle];
    desc = map[FirestoreResources.fieldEventDesc];
    time = AppHelper.convertToDateTime(map[FirestoreResources.fieldEventTime]);
  }
}