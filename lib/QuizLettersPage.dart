import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/BLOC/QuizLetterBLOC.dart';
import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/SqliteDb/SQLiteManager.dart';
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
  int _selectedIndex = 0;

  List<Widget> _quizLettersWidgetOptions;

  Map<String, QuizLetterDisplay> _quizLetterDisplayList = Map();

  String noQuizMessage = "Retrieving quiz letters ...";

  QuizLetterBLOC quizLetterBLOC;

  @override
  void initState() {
    super.initState();
    SQLiteManager().initAppDatabase();
    this._openedQuizId = widget._openedQuizId;
    getQuizLetters();
  }

  /// Quiz letters
  void getQuizLetters() {
    Firestore.instance
        .collection(FirestoreResources.collectionQuizLetterName)
        .orderBy(FirestoreResources.fieldQuizLetterAddedDate, descending: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.documents.length == 0)
        setState(() {
          noQuizMessage = "No quiz letters";
        });
      else {
        snapshot.documentChanges.forEach((docSnapshot) {
          QuizLetter quizLetter = QuizLetter.fromMap(docSnapshot.document.data);
          QuizLetterDisplay quizLetters = QuizLetterDisplay(false, quizLetter,
              quizLetter.quizLettersId == _openedQuizId, false);
          setState(() {
            _quizLetterDisplayList.putIfAbsent(
                quizLetters.quizLetter.quizLettersId, () => quizLetters);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    quizLetterBLOC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    quizLetterBLOC = QuizLetterBLOC();
    _quizLettersWidgetOptions = <Widget>[
      _quizLetterDisplay(noQuizMessage, _quizLetterDisplayList),
      _favouriteQuizLetter()
    ];

    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: CustomAppBar("Quiz letters", context),
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.games),
                      title: Text("Quiz letters",
                          style: TextStyle(fontFamily: 'Raleway'))),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      title: Text("Favourites",
                          style: TextStyle(fontFamily: 'Raleway'))),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.purple,
                onTap: _onItemSelected),
            body: _quizLettersWidgetOptions.elementAt(_selectedIndex)));
  }

  /// On bottom navigation bar selected
  _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Event display widget
  Widget _quizLetterDisplay(
      noQuizLetterMsg, Map<String, QuizLetterDisplay> quizLetterDisplayList) {
    if (quizLetterDisplayList.length == 0)
      return Center(
          child:
          Text(noQuizLetterMsg, style: TextStyle(fontFamily: 'Raleway')));

    List<QuizLetterDisplay> quizLetterList =
    quizLetterDisplayList.values.toList();

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: quizLetterList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return QuizLettersExpandableWidget(quizLetterList[index],
                    (bool) => onFavButtonHandleClickForQuizLetter(quizLetterList[index], bool),
                () => onShareButtonHandle(quizLetterList[index]));
          }),
    );
  }


  /// On fav button handle clicked event
   onFavButtonHandleClickForQuizLetter(QuizLetterDisplay quizLetterDisplay, bool){
    setState(() {
      _quizLetterDisplayList[
      quizLetterDisplay.quizLetter.quizLettersId]
          .quizLetterLiked = !bool;
    });

    !quizLetterDisplay.quizLetterLiked
        ? quizLetterBLOC.deleteQuizLetter(
        quizLetterDisplay.quizLetter.quizLettersId)
        : quizLetterBLOC.insertQuizLetter(quizLetterDisplay);
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
      return Center(
          child:
              Text(noQuizLetterMsg, style: TextStyle(fontFamily: 'Raleway')));

    List<QuizLetterDisplay> quizLetterList =
        quizLetterDisplayList.values.toList();

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: quizLetterList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return QuizLettersExpandableWidget(quizLetterList[index], (bool) =>onFavButtonHandleClickedForFavouriteQuizLetter(quizLetterList[index], bool), null);
          }),
    );
  }

  /// on fav button handle clicked for favourite quiz letters
  onFavButtonHandleClickedForFavouriteQuizLetter(QuizLetterDisplay quizLetterDisplay, bool){
    setState(() {
      _quizLetterDisplayList[
      quizLetterDisplay.quizLetter.quizLettersId]
          .quizLetterLiked = false;
    });
    quizLetterBLOC.deleteQuizLetter(
        quizLetterDisplay.quizLetter.quizLettersId);
  }

  /// On share button handle
  onShareButtonHandle(QuizLetterDisplay quizLetterDisplay){
    print("Calling share app");
    ShareApp().shareQuizLetter(quizLetterDisplay.quizLetter.quizLettersUrl, quizLetterDisplay.quizLetter.quizLettersBody);
  }
}
