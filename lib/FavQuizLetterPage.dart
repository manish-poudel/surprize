import 'package:Surprize/BLOC/QuizLetterBLOC.dart';
import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/TableResources.dart';
import 'package:flutter/material.dart';

import 'SqliteDb/SQLiteManager.dart';

class FavQuizLetterPage extends StatefulWidget {
  @override
  _FavQuizLetterPageState createState() => _FavQuizLetterPageState();
}

class _FavQuizLetterPageState extends State<FavQuizLetterPage> {

  QuizLetterBLOC quizLetterBLOC;
  Map<String, QuizLetterDisplay> _quizLettersMap = new Map();

  @override
  void initState() {
    super.initState();
    quizLetterBLOC = new QuizLetterBLOC();
    getQuizLetter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Favourites", context),
        body: _favouriteQuizLetter(),
      ),
    );
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
          return _quizLetterDisplayForFav("No favourites", _favQuizLetters);
        });
  }

  /// Event display widget
  Widget _quizLetterDisplayForFav(noQuizLetterMsg, quizLetterDisplayList) {
    if (quizLetterDisplayList.length == 0)
      return Center(child: Text(
          noQuizLetterMsg, style: TextStyle(fontFamily: 'Raleway')));

    List<QuizLetterDisplay> quizLetterList = quizLetterDisplayList.values
        .toList();

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: quizLetterList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(children: <Widget>[
                Text(quizLetterList[index].quizLetter.quizLettersSubject),
                IconButton(icon: Icon(Icons.remove), onPressed: () => quizLetterBLOC.deleteQuizLetter(quizLetterList[index].quizLetter.quizLettersId))
              ],),
            );
          }),
    );
  }

  Future getQuizLetter() async {
    List list = await SQLiteManager().getAllQuotes();
    if(list.length != 0)
      list.forEach((map){
        QuizLetterDisplay quizLetterDisplay =  createQuizLetter(map);
        setState(() {
          _quizLettersMap.putIfAbsent(quizLetterDisplay.quizLetter.quizLettersId, () => quizLetterDisplay);
        });
      });
  }

  /// Create quiz letter from map
  QuizLetterDisplay createQuizLetter(Map map) {
    DailyQuizChallengeQnA dailyQuizChallengeQnA = DailyQuizChallengeQnA
        .fromSQLiteMap(map);
    QuizLetter quizLetter = QuizLetter.fromSQLiteMap(
        map, dailyQuizChallengeQnA);
    return QuizLetterDisplay(
        map[SQLiteDatabaseResources.fieldQuizLetterDisplayId],
        map[SQLiteDatabaseResources.fieldQuizLetterLiked] == "true",
        quizLetter,
        map[SQLiteDatabaseResources.fieldQuizLetterExpanded] == "true",
        map[SQLiteDatabaseResources.fieldQuizLetterBodyReveal] == "true");
  }
}
