import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class Report{
  String id;
  String reportSubject;
  String reportBody;
  String reportedBy;
  DateTime reportedOn;
  String reply;
  DateTime repliedOn;

  Report(this.id, this.reportSubject, this.reportBody, this.reportedBy, this.reportedOn, this.reply, this.repliedOn);


  Report.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldReportId];
    reportSubject = map[FirestoreResources.fieldReportSubject];
    reportBody = map[FirestoreResources.fieldReportBody];
    reportedBy = map[FirestoreResources.fieldReportedBy];
    reportedOn = AppHelper.convertToDateTime(map[FirestoreResources.fieldReportedOn]);
    reply = map[FirestoreResources.fieldReportReply];
    repliedOn = AppHelper.convertToDateTime(map[FirestoreResources.fieldRepliedOn]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldReportId] = id;
    map[FirestoreResources.fieldReportSubject] = reportSubject;
    map[FirestoreResources.fieldReportBody] = reportBody;
    map[FirestoreResources.fieldReportedBy] = reportedBy;
    map[FirestoreResources.fieldReportedOn] = reportedOn;
    map[FirestoreResources.fieldReportReply] = reply;
    map[FirestoreResources.fieldRepliedOn] = repliedOn;

    return map;
  }
}