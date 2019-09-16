import 'package:Surprize/BLOC/QuizLetterBLOC.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/CustomExpandableWidget.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/CustomSimpleQuizQuestionsDisplayWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/TableResources.dart';
import 'package:Surprize/SqliteDb/SQLiteManager.dart';
import 'package:flutter/material.dart';

class QuizLettersExpandableWidget extends StatefulWidget {
  QuizLetterDisplay _quizLetterDisplay;
  Function onPressedFavWidget;
  Function onPressedShareButton;
  QuizLettersExpandableWidget(this._quizLetterDisplay, this.onPressedFavWidget, this.onPressedShareButton);

  @override
  _QuizLettersExpandableWidgetState createState() =>
      _QuizLettersExpandableWidgetState();
}

class _QuizLettersExpandableWidgetState
    extends State<QuizLettersExpandableWidget> {

  @override
  void initState() {
    super.initState();
    getLikedValue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          child: CustomExpandableWidget(
            initiallyExpanded: widget. _quizLetterDisplay.initiallyExpanded,
            onExpansionChanged: (value) => _onExpansionChanged(value),
            title: _title(),
            leading: ClipRRect(

                child: _leading(),
                borderRadius:BorderRadius.all(Radius.circular(10.0))),
            childrenWidgets: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSimpleQuizQuestionDisplay(
                    widget._quizLetterDisplay.quizLetter.dailyQuizChallengeQnA),
              ),
              Container(height: 0.5, color: Colors.grey[200]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget._quizLetterDisplay.revealBody == true
                    ? Text(widget._quizLetterDisplay.quizLetter.quizLettersBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontFamily: 'Raleway'))
                    : GestureDetector(
                        child: Text(
                          "Reveal",
                          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          setState(() {
                            widget._quizLetterDisplay.revealBody = true;
                          });
                        }),
              ),
            ],
          ),
        )
      ],
    );
  }

  /// On expansion changed
  _onExpansionChanged(value) {}

  /// Leading for expandable widget
  Widget _leading() {
    return widget._quizLetterDisplay.quizLetter.quizLettersUrl.isEmpty
        ? Image.asset(ImageResources.emptyUserProfilePlaceholderImage,
            height: 100, width: 80, fit: BoxFit.fill,)
        : FadeInImage.assetNetwork(
            image: widget._quizLetterDisplay.quizLetter.quizLettersUrl,
            placeholder: ImageResources.emptyImageLoadingUrlPlaceholder, height: 100, width:80,fit: BoxFit.fill);
  }

  /// Title for expandable widget
  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(widget._quizLetterDisplay.quizLetter.quizLettersSubject,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  fontSize: 18)),
          _iconButtons()
        ],
      ),
    );
  }

  Widget _iconButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
          icon: widget._quizLetterDisplay.quizLetterLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          color: Colors.redAccent,
          onPressed: () => widget.onPressedFavWidget(widget._quizLetterDisplay.quizLetterLiked)),
      IconButton(icon: Icon(Icons.share), onPressed: () => widget.onPressedShareButton())
    ]);
  }

  Future getLikedValue() async {
    List list = await SQLiteManager().getQuotes(widget._quizLetterDisplay.quizLetter.quizLettersId);
    if(list == null)
      return;
    if(list.length == 0)
      return;
    setState(() {
      widget._quizLetterDisplay.quizLetterLiked =  (list[0][SQLiteDatabaseResources.fieldQuizLetterLiked] == "true");
    });

  }
}
