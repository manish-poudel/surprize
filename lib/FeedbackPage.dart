import 'package:Surprize/CustomWidgets/CustomAppBarWithAction.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Report.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/SendFeedbackPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  BuildContext _context;
  Map<String, Report> feedbackMap = new Map();
  List<String> _popUpMenuChoice = ["Send feedback"];

  List<String> deletedId = List();

  @override
  void initState() {
    super.initState();
    getFeedbacks();
  }

  /// App bar actions
  List<Widget> appBarActions() {
    return [
      PopupMenuButton<String>(
        onSelected: _onPopUpMenuItemSelected,
        itemBuilder: (BuildContext context) {
          return _popUpMenuChoice.map((String menu) {
            return PopupMenuItem<String>(
                value: menu,
                child: ListTile(
                    title:
                    Text(menu, style: TextStyle(fontFamily: 'Raleway'))));
          }).toList();
        },
      )
    ];
  }

  /// If pop up menu item is selected
  void _onPopUpMenuItemSelected(String value) {
    if (value == "Send feedback") {
      AppHelper.cupertinoRoute(_context, SendFeedbackPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar:
            CustomAppBarWithAction("Feedbacks", context, appBarActions()),
            body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    showFeedbacks(),
                    FlatButton(
                        child: Text("SEND FEEDBACK",
                            style: TextStyle(color: Colors.grey)),
                        onPressed: () =>
                            AppHelper.cupertinoRoute(context, SendFeedbackPage()))
                  ],
                ))));
  }

  getFeedbacks() {
    Firestore.instance
        .collection(FirestoreResources.collectionReport)
        .where(FirestoreResources.fieldReportedBy,
        isEqualTo: UserMemory().getPlayer().membershipId)
        .snapshots()
        .listen((snapshot) {
      snapshot.documents.forEach((documentSnapshot) {
        Report report = Report.fromMap(documentSnapshot.data);
        if (feedbackMap.containsKey(report.id)) {
          feedbackMap.remove(report.id);
        }
        setState(() {
          if(!deletedId.contains(report.id))
            feedbackMap.putIfAbsent(report.id, () => report);
        });
      });
    });
  }

  Widget showFeedbacks() {

    if (feedbackMap.length == 0) return Padding(
      padding: const EdgeInsets.only(top:32.0),
      child: Center(child:
      Text("No feedback",style: TextStyle(fontFamily: 'Raleway'))),
    );

    List<Report> reportList = feedbackMap.values.toList();

    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: reportList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  Card(child: feedbackCard(reportList[index]))
                ],
              ),
            );
          }),
    );
  }

  Widget feedbackCard(Report report) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(report.reportSubject,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500)),
                  Text(AppHelper.dateToReadableString(report.reportedOn),
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w300)),
                ],
              ),
              IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red, size: 16),onPressed: () => deleteFeedback(report.id))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(report.reportBody,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w300)),
          ),
          Visibility(visible:report.reply.isEmpty, child: Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: Text("Thanks for sending us feedback. We will look at it and reply soon!", textAlign: TextAlign.center,
                style:TextStyle(fontFamily: 'Raleway', color: Colors.grey,fontWeight: FontWeight.w600)
            ),
          )),
          Visibility(
            visible: report.reply.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Reply:",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w300)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Column(
                      children: <Widget>[
                        Visibility(
                            visible: report.reply.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: report.reply.isNotEmpty ||
                                  report.reply != null
                                  ? Text(report.reply,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Raleway',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300))
                                  : Container(),
                            )),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: report.repliedOn != null,
                      child: report.repliedOn != null
                          ? Text(
                          AppHelper.dateToReadableString(report.repliedOn),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w300))
                          : Container())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Delete feedback
  deleteFeedback(String id){
    deletedId.add(id);
    Firestore.instance
        .collection(FirestoreResources.collectionReport).document(id).delete().then((value){
      setState(() {
        feedbackMap.remove(id);
      });
    });
  }
}
