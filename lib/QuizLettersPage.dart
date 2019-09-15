import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Resources/FirestoreResources.dart';

class QuizLettersPage extends StatefulWidget {

  String _openedQuizId;
  QuizLettersPage(this._openedQuizId);
  @override
  _QuizLettersPageState createState() => _QuizLettersPageState();
}

class _QuizLettersPageState extends State<QuizLettersPage> {

  String _openedQuizId;
  int _selectedIndex  = 0;

  List<Widget> _quizLettersWidgetOptions;

  Map<String, QuizLetterDisplay> quizLetterDisplayList = Map();

  String noQuizMessage = "Retrieving quiz letters ...";

  @override
  void initState() {
    super.initState();
    this._openedQuizId = widget._openedQuizId;
   getQuizLetters();
  }

  @override
  Widget build(BuildContext context) {

    _quizLettersWidgetOptions = <Widget>[_quizLetterDisplay(), _favouriteQuizLetter()];

    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: CustomAppBar("Quiz letters",context),
            bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.games), title: Text("Quiz letters",style: TextStyle(fontFamily: 'Raleway'))),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text("Favourites",style: TextStyle(fontFamily: 'Raleway'))),
            ], currentIndex:_selectedIndex, selectedItemColor: Colors.purple, onTap: _onItemSelected),
            body: _quizLettersWidgetOptions.elementAt(_selectedIndex)));
  }

  /// On bottom navigation bar selected
  _onItemSelected(int index){
    setState(() {
      _selectedIndex = index;
    });
  }


  /// Favourites widget
  Widget _favouriteQuizLetter() {
    return Center(child: Text("No favourites",style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),));
  }
  /// Event display widget
  Widget _quizLetterDisplay(){

    if(quizLetterDisplayList.length == 0)
      return Center(child: Text(noQuizMessage, style: TextStyle(fontFamily: 'Raleway')));

    List<QuizLetterDisplay> quizLetterList = quizLetterDisplayList.values.toList();

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: quizLetterList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left:8.0, right: 8.0),
              child: QuizLettersExpandableWidget(quizLetterList[index]),
            );
          }),
    );
  }

  /// Quiz letters
  void getQuizLetters() {
    Firestore.instance.collection(FirestoreResources.collectionQuizLetterName).orderBy(FirestoreResources.fieldQuizLetterAddedDate, descending: true).snapshots().listen((snapshot){

      if(snapshot.documents.length == 0)
        setState(() {
          noQuizMessage = "No quiz letters";
        });

      else {
        snapshot.documentChanges.forEach((docSnapshot) {
          QuizLetter quizLetter = QuizLetter.fromMap(docSnapshot.document.data);
          QuizLetterDisplay quizLetters = QuizLetterDisplay(
              false, quizLetter, quizLetter.quizLettersId == _openedQuizId, false);
          setState(() {
            quizLetterDisplayList.putIfAbsent(
                quizLetters.quizLetter.quizLettersId, () => quizLetters);
          });
        });
      }
    });
  }
}
