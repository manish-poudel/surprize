
import 'package:Surprize/CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SurveyForm extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey;

  SurveyForm(this._scaffoldKey);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {

  final _formKey = GlobalKey<FormState>();


  String _ratioSelection;
  String _issueSelection;
  String _totalQuestionSelection;

  bool _enabledTextFieldForProblemWithApp = false;

  CustomMultiLineTextFieldWidget _customLabelTextFieldWidgetForIssue;
  CustomMultiLineTextFieldWidget _customMultiLineTextFieldWidgetForKeywords;

  int currentForm = 1;



  @override
  void initState() {
    super.initState();
    _customLabelTextFieldWidgetForIssue =
        CustomMultiLineTextFieldWidget(
            "Describe your issue", "", Colors.black, 200, enabled: true);
    _customMultiLineTextFieldWidgetForKeywords = CustomMultiLineTextFieldWidget("Any words from today's quiz", "", Colors.black, 200);
  }

  @override
  Widget build(BuildContext context) {
     return AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(icon: Icon(Icons.close),color: Colors.red, onPressed: (){
                        Navigator.pop(context,false);
                  })),
              showCurrentForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Visibility(
                    visible: currentForm > 1,
                    child: FlatButton(child: Text("Back"), onPressed: () {
                      setState(() {
                        currentForm--;
                      });
                    }),
                  ),
                  Visibility(
                    visible: currentForm < 4,
                    child: FlatButton(child: Text("Next"), onPressed: () {
                      setState(() {
                        currentForm++;
                      });
                    }),
                  ),

                  Visibility(
                    visible: currentForm == 4,
                    child: FlatButton(child: Text("Submit"), onPressed: () {
                      sendSurvey();
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }

  /// Show current form
  Widget showCurrentForm() {
    switch (currentForm) {
      case 1:
        return ratingSelection();
      case 2:
        return experienceProblemWithApp();
      case 3:
        return quizQuestionNumber();
      case 4:
        return keywords();
      default:
        return ratingSelection();
    }
  }

  // On rating button selection
  onRatingRadioSelection(String selection) {
    setState(() {
      _ratioSelection = selection;
    });
  }

  // On issue radio button selection
  onIssueRadioButtonSelection(String selection) {
    setState(() {
      _issueSelection = selection;
      _enabledTextFieldForProblemWithApp =
      _issueSelection == "Yes" ? true : false;
    });
  }

  // On total quiz button selection
  onTotalQuizQuestionSelection(String selection) {
    setState(() {
      _totalQuestionSelection = selection;
    });
  }

  // Rating selection
  Widget ratingSelection() {
    return Flexible(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Survey form",style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w700),),
            Text("Please fill the survey form to help us understand our app better and bring out some wonderful experience to you!",
                style: TextStyle(fontFamily: 'Raleway', fontSize: 16)),
            Padding(
              padding: const EdgeInsets.only(top:2.0),
              child: Text("We don't collect sender information", style: TextStyle(fontFamily: 'Ralway', fontStyle: FontStyle.italic)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
              child: Text("1. Rate today's Daily Quiz Challenge game play.",
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 18)),
            ),
            Flexible(child: radioSelects(
                "1", _ratioSelection, onRatingRadioSelection)),
            Flexible(child: radioSelects(
                "2", _ratioSelection, onRatingRadioSelection)),
            Flexible(child: radioSelects(
                "3", _ratioSelection, onRatingRadioSelection)),
            Flexible(child: radioSelects(
                "4", _ratioSelection, onRatingRadioSelection)),
            Flexible(child: radioSelects(
                "5", _ratioSelection, onRatingRadioSelection)),
          ],
        ),
      ),
    );
  }

  // Radio values.
  Widget radioSelects(String text, String selection, Function onChanged) {
    return ListTile(
      title: Text(text),
      leading: Radio(
          value: text,
          groupValue: selection,
          onChanged: onChanged
      ),
    );
  }

  // Experience problem widget
  Widget experienceProblemWithApp() {
    return Flexible(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                  "2. Did you face any issue while playing Daily Quiz Challenge?",
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 18)),
            ),
            Flexible(child: radioSelects(
                "Yes", _issueSelection, onIssueRadioButtonSelection)),
            Flexible(child: radioSelects(
                "No", _issueSelection, onIssueRadioButtonSelection)),
            Visibility(visible: _enabledTextFieldForProblemWithApp,
                child: Expanded(child: _customLabelTextFieldWidgetForIssue))
          ],
        ),
      ),
    );
  }


  // Total quiz number
  Widget quizQuestionNumber() {
    return Flexible(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                  "3. How many questions did you see during Game Play? ",
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 18)),
            ),
            Flexible(child: radioSelects("Less than 5", _totalQuestionSelection,
                onTotalQuizQuestionSelection)),
            Flexible(child: radioSelects("Exactly 5", _totalQuestionSelection,
                onTotalQuizQuestionSelection)),
            Flexible(child: radioSelects("More than 5", _totalQuestionSelection,
                onTotalQuizQuestionSelection)),
          ],
        ),
      ),
    );
  }

  // Keywords
  Widget keywords() {
    return Flexible(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                  "4. Any words you can remember from today's quiz question or answer?",
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 18)),
            ),
            Expanded(child: _customMultiLineTextFieldWidgetForKeywords)
          ],
        ),
      ),
    );
  }
  

  /// Sending survey
  sendSurvey(){

    String fieldSurveyIssueDesc = _issueSelection == "Yes"?_customLabelTextFieldWidgetForIssue.getValue():"";
    String id = Firestore.instance.collection(FirestoreResources.fieldSurveyCollection).document().documentID;
    Firestore.instance.collection(FirestoreResources.fieldSurveyCollection).document(id).setData({
    FirestoreResources.fieldSurveyId:id,
    FirestoreResources.fieldSurveyRatingField:_ratioSelection,
    FirestoreResources.fieldSurveyIssueYesNoField:_issueSelection,
    FirestoreResources.fieldSurveyIssueDesc: fieldSurveyIssueDesc,
    FirestoreResources.fieldSurveyNoOfQuizQuestion:_totalQuestionSelection,
    FirestoreResources.fieldSurveyQuizKeywords: _customMultiLineTextFieldWidgetForKeywords == null?"Unable to get value":_customMultiLineTextFieldWidgetForKeywords.getValue()
    }).then((_){
      if(widget._scaffoldKey != null) {
        print("Scaffold key" + widget._scaffoldKey.currentState.toString());
        AppHelper.showSnackBar("Thanks for your time!", widget._scaffoldKey);
        Navigator.of(context).pop();
      }
    }).catchError((error){
      Navigator.of(context).pop();
    });

  }

}
