
import 'package:Surprize/CustomWidgets/ExpandableWidgets/QuizLetterExpandableWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';

class CustomQuizLettersWidget extends StatefulWidget {

  QuizLetterDisplay _quizLetterDisplay;
  CustomQuizLettersWidget(this._quizLetterDisplay);
  @override
  _CustomQuizLettersWidgetState createState() =>
      _CustomQuizLettersWidgetState();
}

class _CustomQuizLettersWidgetState extends State<CustomQuizLettersWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child:Column(
        children: <Widget>[
          QuizLettersExpandableWidget(widget._quizLetterDisplay),
          _playButton()
        ],
      )
    );
  }

  /// Widget image
  Widget _quizLetterImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(1.0),
        child: FadeInImage.assetNetwork(
            image: 'http://lorempixel.com/400/200/', height: 100,
            placeholder: ImageResources.emptyImageLoadingUrlPlaceholder));
  }

  Widget _playButton(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RichText(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            softWrap: true,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Click for More",
                  style: TextStyle(
                      color: Colors.grey, fontSize: 12, fontFamily:'Raleway',fontWeight: FontWeight.w300)),
            ])),
      ),
    );
  }

}
