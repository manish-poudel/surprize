import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/TableResources.dart';
import 'package:Surprize/SqliteDb/SQLiteManager.dart';
import 'package:flutter/material.dart';

class CustomQuizLettersWidget extends StatefulWidget with WidgetsBindingObserver {

  QuizLetterDisplay _quizLetterDisplay;
   _CustomQuizLettersWidgetState state;

  CustomQuizLettersWidget(this._quizLetterDisplay);

  @override
  _CustomQuizLettersWidgetState createState() {
    state =  _CustomQuizLettersWidgetState();
    return state;
  }
}

class _CustomQuizLettersWidgetState extends State<CustomQuizLettersWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child:Column(
        children: <Widget>[
          QuizLettersExpandableWidget("Server",widget._quizLetterDisplay, (bool) => onFavButtonHandleClicked(), (){
            ShareApp().shareQuizLetter(widget._quizLetterDisplay.quizLetter.quizLettersBody);
          },showButton: true,),
         // _playButton()
        ],
      )
    );
  }

  /// on fav button handle clicked for favourite quiz letters
  onFavButtonHandleClicked(){
    setState(() {
      widget._quizLetterDisplay.quizLetterLiked = !widget._quizLetterDisplay.quizLetterLiked;
    });
    !widget._quizLetterDisplay.quizLetterLiked
        ? SQLiteManager().deleteFavouriteQuote(
        widget._quizLetterDisplay.displayId)
        : SQLiteManager().insertFavouriteQuote(widget._quizLetterDisplay);
  }

  Future getLikedValue() async {
    List list = await SQLiteManager().getQuotes(widget._quizLetterDisplay.displayId);
    if(list.length == 0)
      return;
    setState(() {
      widget._quizLetterDisplay.quizLetterLiked =  (list[0][SQLiteDatabaseResources.fieldQuizLetterLiked] == "true");
    });
  }

  @override
  void initState() {
    super.initState();
    getLikedValue();
  }


  @override
  void dispose() {
    super.dispose();
  }

}
