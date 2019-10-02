import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/CustomDropDownWidget.dart';
import 'package:Surprize/CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';

import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Report.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendFeedbackPage extends StatefulWidget {
  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {

  CustomDropDownWidget customDropDownWidget;
  CustomMultiLineTextFieldWidget customMultiLineTextFieldWidget;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    customDropDownWidget = CustomDropDownWidget(["Report issue", "Improvement tips", "Ask", "Other"],
        "Report issue", "Select subject for your report", Colors.black, Colors.white);
    customMultiLineTextFieldWidget = CustomMultiLineTextFieldWidget("Write message", "", Colors.black,140);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar("Send feedback",context),
        body: SingleChildScrollView(child:
        Padding(
          padding: const EdgeInsets.only(left:16.0, right: 16.0, top: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Subject:", style: TextStyle(fontFamily: 'Raleway')),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left:16.0),
                    child: customDropDownWidget,
                  )),
                ],
              ),
              customMultiLineTextFieldWidget,
              FlatButton(child: Text("Send", style: TextStyle(fontFamily:'Raleway',color:Colors.white)),color: Colors.green, onPressed: () => sendReport(context))
            ],
          ),
        )),
      ),
    );
  }

  sendReport(context) async {

    if(customMultiLineTextFieldWidget.getValue().isEmpty){
      AppHelper.showSnackBar("Empty message", _scaffoldKey);
      return;
    }

    CustomProgressbarWidget _customRegistrationProgressBar = new CustomProgressbarWidget();
    _customRegistrationProgressBar.startProgressBar(context, "Sending report...", Colors.white, Colors.black);
    if(await exceedFeedbackQuotaLimit()) {
      _customRegistrationProgressBar.stopAndEndProgressBar(context);
      AppHelper.showSnackBar(
          "Quota limit exceeded. Delete any of your previously sent feedback to continue.", _scaffoldKey);
      return;
    }

    String userId = UserMemory().getPlayer().membershipId;
    String reportId = Firestore.instance.collection(FirestoreResources.collectionReport).document().documentID;

    Report report = Report(reportId, customDropDownWidget.selectedItem(),
        customMultiLineTextFieldWidget.getValue(), userId, DateTime.now(), "", null);

    Firestore.instance.collection(FirestoreResources.collectionReport).document(reportId).
    setData(report.toMap()).then((value){
      _customRegistrationProgressBar.stopAndEndProgressBar(context);
     Navigator.of(context).pop();
    });

  }

  // check for feedback quota
  exceedFeedbackQuotaLimit()  async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(FirestoreResources.collectionReport)
        .where(FirestoreResources.fieldReportedBy,
        isEqualTo: UserMemory()
            .getPlayer()
            .membershipId).getDocuments();

    return querySnapshot.documents.length > 2;
  }

}
