import 'package:Surprize/CustomWidgets/ExpandableWidgets/CustomExpandableWidget.dart';
import 'package:Surprize/CustomWidgets/ExpandableWidgets/CustomSimpleQuizQuestionsDisplayWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';

class QuizLettersExpandableWidget extends StatefulWidget {
  QuizLetterDisplay _quizLetterDisplay;
  QuizLettersExpandableWidget(this._quizLetterDisplay);

  @override
  _QuizLettersExpandableWidgetState createState() =>
      _QuizLettersExpandableWidgetState();
}

class _QuizLettersExpandableWidgetState
    extends State<QuizLettersExpandableWidget> {
  QuizLetterDisplay _quizLetterDisplay;

  @override
  void initState() {
    super.initState();
    _quizLetterDisplay = widget._quizLetterDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          child: CustomExpandableWidget(
            initiallyExpanded: _quizLetterDisplay.initiallyExpanded,
            onExpansionChanged: (value) => _onExpansionChanged(value),
            title: _title(),
            leading: ClipRRect(

                child: _leading(),
                borderRadius:BorderRadius.all(Radius.circular(10.0))),
            childrenWidgets: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSimpleQuizQuestionDisplay(
                    _quizLetterDisplay.quizLetter.dailyQuizChallengeQnA),
              ),
              Container(height: 0.5, color: Colors.grey[200]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _quizLetterDisplay.revealBody == true
                    ? Text(_quizLetterDisplay.quizLetter.quizLettersBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontFamily: 'Raleway'))
                    : GestureDetector(
                        child: Text(
                          "Reveal",
                          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          setState(() {
                            _quizLetterDisplay.revealBody = true;
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
    return _quizLetterDisplay.quizLetter.quizLettersUrl.isEmpty
        ? Image.asset(ImageResources.emptyUserProfilePlaceholderImage,
            height: 100, width: 80, fit: BoxFit.fill,)
        : FadeInImage.assetNetwork(
            image: _quizLetterDisplay.quizLetter.quizLettersUrl,
            placeholder: ImageResources.emptyImageLoadingUrlPlaceholder, height: 100, width:80,fit: BoxFit.fill);
  }

  /// Title for expandable widget
  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(_quizLetterDisplay.quizLetter.quizLettersSubject,
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
          icon: _quizLetterDisplay.quizLetterLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          color: Colors.redAccent,
          onPressed: () {
            setState(() {
              _quizLetterDisplay.quizLetterLiked =
                  !_quizLetterDisplay.quizLetterLiked;
            });
          }),
      IconButton(icon: Icon(Icons.share))
    ]);
  }
}
