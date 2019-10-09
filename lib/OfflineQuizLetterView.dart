
import 'package:Surprize/BLOC/QuizLetterBLOC.dart';
import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';

import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:flutter/material.dart';

class OfflineQuizLetterView extends StatefulWidget {
  @override
  _OfflineQuizLetterViewState createState() => _OfflineQuizLetterViewState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _OfflineQuizLetterViewState extends State<OfflineQuizLetterView> {

  QuizLetterBLOC quizLetterBLOC;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quizLetterBLOC = QuizLetterBLOC();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Quiz letters", context),
        key: _scaffoldKey,
        body: _favouriteQuizLetter(),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    quizLetterBLOC.dispose();
  }

  /// Favourites widget
  Widget _favouriteQuizLetter() {
    return StreamBuilder<Map<String, QuizLetterDisplay>>(
        stream: quizLetterBLOC.quizLetters,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, QuizLetterDisplay>> quizLetterData) {
          Map<String, QuizLetterDisplay> _favQuizLetters = quizLetterData.data;
          if (_favQuizLetters == null)
            return Center(child: Text("Retrieving..."));
          return _quizLetterDisplayForFav( _favQuizLetters);
        });
  }

  /// Event display widget
  Widget _quizLetterDisplayForFav(quizLetterDisplayList) {
    if (quizLetterDisplayList.length == 0)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text("No favourites", style: TextStyle(fontSize: 18,fontFamily: 'Raleway'))),
          Padding(
            padding: const EdgeInsets.only(left:16.0, right: 16.0),
            child: Text("Save your favourite quiz letters to view offline!", textAlign: TextAlign.center, style: TextStyle(fontSize: 14,fontFamily: 'Raleway', color: Colors.grey)),
          ),
        ],
      );

    List<QuizLetterDisplay> quizLetterList = quizLetterDisplayList.values.toList();

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: quizLetterList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return QuizLettersExpandableWidget("Sqlite",quizLetterList[index],null,null,showButton: false);
          }),
    );
  }

}
