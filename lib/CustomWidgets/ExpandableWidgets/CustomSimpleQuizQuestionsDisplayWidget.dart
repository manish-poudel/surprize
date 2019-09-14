import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:flutter/material.dart';

class CustomSimpleQuizQuestionDisplay extends StatefulWidget {

  DailyQuizChallengeQnA dailyQuizChallengeQnA;
  CustomSimpleQuizQuestionDisplay(this.dailyQuizChallengeQnA);

  @override
  _CustomSimpleQuizQuestionDisplayState createState() => _CustomSimpleQuizQuestionDisplayState();
}

class _CustomSimpleQuizQuestionDisplayState extends State<CustomSimpleQuizQuestionDisplay> {

  Color questionAnswerFirstColor;
  Color questionAnswerSecondColor;
  Color questionAnswerThirdColor;
  Color questionAnswerFourthColor;

  @override
  void initState() {
    super.initState();
    initButtonColor();
  }

  void initButtonColor(){
     questionAnswerFirstColor = Colors.white;
     questionAnswerSecondColor = Colors.white;
     questionAnswerThirdColor = Colors.white;
     questionAnswerFourthColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(widget.dailyQuizChallengeQnA.question, textAlign:TextAlign.center,style:TextStyle(fontSize: 18, fontFamily: 'Raleway', fontWeight: FontWeight.w500)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _quizAnswerBox(questionAnswerFirstColor,widget.dailyQuizChallengeQnA.answers[0], () => handleAnswerClick(1)),
                Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: _quizAnswerBox(questionAnswerSecondColor,widget.dailyQuizChallengeQnA.answers[1], ()=> handleAnswerClick(2)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: _quizAnswerBox(questionAnswerThirdColor,widget.dailyQuizChallengeQnA.answers[2], () =>handleAnswerClick(3)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: _quizAnswerBox(questionAnswerFourthColor,widget.dailyQuizChallengeQnA.answers[3], ()=> handleAnswerClick(4)),
                )
              ],
            ),
          )
        ]),
    );
  }

  Widget _quizAnswerBox(Color color, String answer, Function onTap){
    return GestureDetector(
      child: Container(
        decoration: new BoxDecoration(
            color: color,
            border: new Border.all(color: Colors.black, width: 1),
            borderRadius: new BorderRadius.all(Radius.circular(40.0))
        ),
        child: Padding(padding: EdgeInsets.all(4.0),
          child: Center(
            child: Text(answer, style: TextStyle(color: Colors.black, fontSize: 16.0,
                fontFamily: 'Raleway')),
          ),
        ),
      ),
      onTap: onTap
    );
  }

  /// Handle answer click listener
  handleAnswerClick(value){
    widget.dailyQuizChallengeQnA.rightAnswer == value?changeBoxColor(value, Colors.greenAccent):changeBoxColor(value, Colors.redAccent);
  }

  /// Change box color
  changeBoxColor(value, Color changeColor){
    initButtonColor();
    switch(value){
      case 1:
        setState(() {
          questionAnswerFirstColor = changeColor;
        });
        break;
      case 2:
        setState(() {
          questionAnswerSecondColor = changeColor;
        });
        break;
      case 3:
        setState(() {
          questionAnswerThirdColor = changeColor;
        });
        break;
      case 4:
        setState(() {
          questionAnswerFourthColor = changeColor;
        });
        break;
    }
  }
}
