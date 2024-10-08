
import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/BLOC/QuizLetterBLOC.dart';

import 'package:Surprize/CustomWidgets/CustomAppBarWithAction.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';
import 'package:Surprize/GoogleAds/CurrentAdDisplayPage.dart';
import 'package:Surprize/GoogleAds/GoogleAdManager.dart';
import 'package:Surprize/GoogleAds/GoogleAdManager.dart' as prefix0;
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/QuizDataState.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/SqliteDb/SQLiteManager.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


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

  List<String> _popUpMenuChoice = ["Game mode", "List mode"];

  String _showQuizLetterType = "Game mode";


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
  setState(() {
    _showQuizLetterType = value;
  });
  }


  @override
  void initState() {
    super.initState();
    GoogleAdManager().showQuizLetterInterstitialAd(0.0, AnchorType.top);
    SQLiteManager().initAppDatabase();
    this._openedQuizId = (widget._openedQuizId != null?widget._openedQuizId:"0");
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
          try {
            QuizLetter quizLetter = QuizLetter.fromMap(
                docSnapshot.document.data);
            if (quizLetter.quizDataState == QuizDataState.DELETED) {
              setState(() {
                _quizLetterDisplayList.remove(
                    quizLetter.quizLettersId + UserMemory()
                        .getPlayer()
                        .membershipId);
                return;
              });
            }
            QuizLetterDisplay quizLetters = QuizLetterDisplay(
                quizLetter.quizLettersId + UserMemory()
                    .getPlayer()
                    .membershipId,
                false, quizLetter,
                quizLetter.quizLettersId == _openedQuizId, false);
            setState(() {
              _quizLetterDisplayList.putIfAbsent(
                  quizLetters.displayId, () => quizLetters);
            });
          }
          catch(error){

          }
        });
      }
    });
  }

  @override
  void dispose() {
    GoogleAdManager().disposeQuizLetterInterstitialAd();
    quizLetterBLOC.dispose();
    super.dispose();
  }

  /// If back button is pressed
  Future<bool> _willPopCallback() async {
       return true;
  }

  @override
  Widget build(BuildContext context) {
    quizLetterBLOC = QuizLetterBLOC();
    _quizLettersWidgetOptions = <Widget>[
      _quizLetterDisplay(noQuizMessage, _quizLetterDisplayList),
      _favouriteQuizLetter()
    ];


    return WillPopScope(
      onWillPop: _willPopCallback ,
        child: Scaffold(
            appBar: CustomAppBarWithAction("Quiz Letters", context, appBarActions()),
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
    return  _showQuizLetterType == "Game mode"?_quizLetterDisplayAtGameMode(noQuizLetterMsg, quizLetterDisplayList):
    _quizLetterDisplayAtListMode(noQuizLetterMsg, quizLetterDisplayList);

  }

  int currentQuizIndex = 0;
  Color navigate_before_color;
  Color navigate_after_color;
  Widget _quizLetterDisplayAtGameMode(noQuizLetterMsg, Map<String, QuizLetterDisplay> quizLetterDisplayList){
    if (quizLetterDisplayList.length == 0) {
      return Center(
          child:
          Text(noQuizLetterMsg, style: TextStyle(fontFamily: 'Raleway')));
    }

    QuizLetterDisplay quizLetterDisplay = quizLetterDisplayList.values.toList()[currentQuizIndex];
    quizLetterDisplay.initiallyExpanded = true;


    navigate_before_color = currentQuizIndex == 0?Colors.grey:Colors.black;
    navigate_after_color = currentQuizIndex == quizLetterDisplayList.length - 1?Colors.grey:Colors.black;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            QuizLettersExpandableWidget("Server",quizLetterDisplay,
                    (bool) => onFavButtonHandleClickForQuizLetter(quizLetterDisplay, bool),
                    () => onShareButtonHandle(quizLetterDisplay),showButton: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(icon:Icon(Icons.navigate_before,color: navigate_before_color,),onPressed: (){
                  if(currentQuizIndex != 0)
                    setState(() {
                      currentQuizIndex--;
                    });
                }),
                Text((currentQuizIndex + 1).toString()),
                IconButton(icon:Icon(Icons.navigate_next, color: navigate_after_color,) ,onPressed: (){
                  if(currentQuizIndex != quizLetterDisplayList.length-1)
                    setState(() {
                      currentQuizIndex++;
                    });
                }),
              ],
            ),
            Container(height: 100)
          ],
        ),
      ),
    );

  }

  Widget _quizLetterDisplayAtListMode(noQuizLetterMsg, Map<String, QuizLetterDisplay> quizLetterDisplayList){

    if (quizLetterDisplayList.length == 0) {
      return Center(
          child:
          Text(noQuizLetterMsg, style: TextStyle(fontFamily: 'Raleway')));
    }

    List<QuizLetterDisplay> quizLetterList = quizLetterDisplayList.values.toList();

    return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: quizLetterList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    int showAdAtIndex = quizLetterDisplayList.length > 1?1:0;
                    return (index == showAdAtIndex)?
                    Column(
                      children: <Widget>[
                        QuizLettersExpandableWidget("Server",quizLetterList[index],
                                (bool) => onFavButtonHandleClickForQuizLetter(quizLetterList[index], bool),
                                () => onShareButtonHandle(quizLetterList[index]),showButton: true),
                      ],
                    ):
                    QuizLettersExpandableWidget("Server",quizLetterList[index],
                            (bool) => onFavButtonHandleClickForQuizLetter(quizLetterList[index], bool),
                            () => onShareButtonHandle(quizLetterList[index]),showButton: true);
                  }),
            ),
          ),
        ]
    );
  }


  /// On fav button handle clicked event
  onFavButtonHandleClickForQuizLetter(QuizLetterDisplay quizLetterDisplay, bool){
    setState(() {
      _quizLetterDisplayList[
      quizLetterDisplay.displayId]
          .quizLetterLiked = !bool;

      quizLetterDisplay.initiallyExpanded = false;
      !quizLetterDisplay.quizLetterLiked
          ? quizLetterBLOC.deleteQuizLetter(
          quizLetterDisplay.displayId)
          : quizLetterBLOC.insertQuizLetter(quizLetterDisplay);
    });
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
            child: Text("Daily quiz letters are replaced with new ones. You can save by adding them to your favourite list!", textAlign: TextAlign.center, style: TextStyle(fontSize: 14,fontFamily: 'Raleway', color: Colors.grey)),
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
            return QuizLettersExpandableWidget("Sqlite",quizLetterList[index], (bool) =>onFavButtonHandleClickedForFavouriteQuizLetter(quizLetterList[index], bool), (){
              ShareApp().shareQuizLetter(quizLetterList[index].quizLetter.quizLettersBody);
            },showButton: true);
          }),
    );
  }

  /// on fav button handle clicked for favourite quiz letters
  onFavButtonHandleClickedForFavouriteQuizLetter(QuizLetterDisplay quizLetterDisplay, bool) {
    {
      try {
        setState(() {
          /// Change fav icon in quiz letter list from server
          if (_quizLetterDisplayList.containsKey(quizLetterDisplay.displayId))
            _quizLetterDisplayList[quizLetterDisplay.displayId]
                .quizLetterLiked = false;

          /// Delete quiz letter
          quizLetterBLOC.deleteQuizLetter(quizLetterDisplay.displayId);
        });

        /// Delete image
        DefaultCacheManager defaultCacheManager = DefaultCacheManager();
        defaultCacheManager.removeFile(quizLetterDisplay.quizLetter.quizLettersUrl);
      }
      catch (error) {}
    }
  }

  /// On share button handle
  onShareButtonHandle(QuizLetterDisplay quizLetterDisplay){
    ShareApp().shareQuizLetter(quizLetterDisplay.quizLetter.quizLettersBody);
  }
}
