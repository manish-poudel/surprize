import 'package:Surprize/Resources/FirestoreResources.dart';

class Facts {
  String id;
  String imageUrl;
  String body;
  String state;

  Facts(this.id, this.imageUrl, this.body, this.state);


  /*
 Convert player to map
   */
  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();

    map[FirestoreResources.fieldDYKId] = id;
    map[FirestoreResources.fieldDRYKImageUrl] = imageUrl;
    map[FirestoreResources.fieldDYKBody] = body;
    map[FirestoreResources.fieldDYKState] = state;

    return map;
  }


  Facts.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldDYKId];
    imageUrl = map[FirestoreResources.fieldDRYKImageUrl];
    body = map[FirestoreResources.fieldDYKBody];
    state = map[FirestoreResources.fieldDYKState];
  }

}