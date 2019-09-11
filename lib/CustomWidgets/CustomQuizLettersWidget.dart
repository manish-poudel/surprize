import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';

class CustomQuizLettersWidget extends StatefulWidget {
  @override
  _CustomQuizLettersWidgetState createState() =>
      _CustomQuizLettersWidgetState();
}

class _CustomQuizLettersWidgetState extends State<CustomQuizLettersWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.30,
                child: _quizLetterImage()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0,top: 16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.52,
              child: _quizLetterText(),
            ),
          ),
        ]),
      ),
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

  Widget _quizLetterText() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
                textAlign: TextAlign.left,
                softWrap: true,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Did you know about the football?",
                      style: TextStyle(
                          color: Colors.black, fontFamily:'Raleway', fontWeight: FontWeight.w500)),
                ])),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Football was initially played with heads of a soldier.Football was initially played with heads of a soldier.Football was initially played with heads of a soldier. ",
                        style: TextStyle(
                            color: Colors.grey, fontFamily:'Raleway', fontWeight: FontWeight.w400)),
                  ])),
            ),
          ),
        ]);
  }
}
