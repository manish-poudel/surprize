import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class Notice {
  String redirect;
  String urlRoute;
  String id;
  String title;
  String body;
  String photoUrl;
  String photoDesc;
  DateTime addedTime;

  Notice(this.id, this.title, this.body, this.photoUrl, this.photoDesc,
      this.addedTime, this.redirect, this.urlRoute);

  Notice.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldNoticeId];
    title = map[FirestoreResources.fieldNoticeTitle];
    body = map[FirestoreResources.fieldNoticeBody];
    photoUrl = map[FirestoreResources.fieldNoticeImageUrl];
    photoDesc = map[FirestoreResources.fieldNoticeImageDesc];
    redirect = map[FirestoreResources.fieldNoticeRedirect];
    urlRoute = map[FirestoreResources.fieldNoticeRouteUrl];
    addedTime = AppHelper.convertToDateTime(map[FirestoreResources.fieldNoticeAddedDate]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldNoticeId] = id;
    map[FirestoreResources.fieldNoticeTitle] = title;
    map[FirestoreResources.fieldNoticeBody] = body;
    map[FirestoreResources.fieldNoticeImageUrl] = photoUrl;
    map[FirestoreResources.fieldNoticeImageDesc] = photoDesc;
    map[FirestoreResources.fieldNoticeAddedDate] = addedTime;
    map[FirestoreResources.fieldNoticeRedirect] = redirect;
    map[FirestoreResources.fieldNoticeRouteUrl] = urlRoute;

    return map;
  }
}
