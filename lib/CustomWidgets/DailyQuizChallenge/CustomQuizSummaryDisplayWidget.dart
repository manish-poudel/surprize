
import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:flutter/material.dart';

class CustomQuizSummaryDisplayWidget extends StatefulWidget {

  DailyQuizChallengeQnA dailyQuizChallengeQnA;
  int selectedAnswer;

  CustomQuizSummaryDisplayWidget(this.dailyQuizChallengeQnA, this.selectedAnswer);


  @override
  _CustomQuizSummaryDisplayWidgetState createState() => _CustomQuizSummaryDisplayWidgetState();
}

class _CustomQuizSummaryDisplayWidgetState extends State<CustomQuizSummaryDisplayWidget> {

  Color questionAnswerFirstColor = Colors.white;
  Color questionAnswerSecondColor = Colors.white;
  Color questionAnswerThirdColor = Colors.white;
  Color questionAnswerFourthColor = Colors.white;


  @override
  void initState() {
    super.initState();
    initRightAnswerColor();
    initSelectedAnswerColor();
  }


  void initRightAnswerColor(){
    switch(widget.dailyQuizChallengeQnA.rightAnswer){
      case 1:
         questionAnswerFirstColor = Colors.green;

        return;
      case 2:
         questionAnswerSecondColor = Colors.green;
        return;
      case 3:
         questionAnswerThirdColor = Colors.green;
        return;
      case 4:
         questionAnswerFourthColor = Colors.green;
        return;
    }
  }

  void initSelectedAnswerColor(){
    switch(widget.selectedAnswer){
      case 1:
        questionAnswerFirstColor = widget.dailyQuizChallengeQnA.rightAnswer == 1?Colors.green:Colors.redAccent;
        return;
      case 2:
        questionAnswerSecondColor = widget.dailyQuizChallengeQnA.rightAnswer == 2?Colors.green:Colors.redAccent;
        return;
      case 3:
        questionAnswerThirdColor = widget.dailyQuizChallengeQnA.rightAnswer == 3?Colors.green:Colors.redAccent;
        return;
      case 4:
        questionAnswerFourthColor = widget.dailyQuizChallengeQnA.rightAnswer == 4?Colors.green:Colors.redAccent;
        return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.dailyQuizChallengeQnA.question, textAlign:TextAlign.center,style:TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Colors.white, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  _quizAnswerBox(questionAnswerFirstColor,widget.dailyQuizChallengeQnA.answers[0]),
                  Padding(
                    padding: const EdgeInsets.only(top:2.0),
                    child: _quizAnswerBox(questionAnswerSecondColor,widget.dailyQuizChallengeQnA.answers[1]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:2.0),
                    child: _quizAnswerBox(questionAnswerThirdColor,widget.dailyQuizChallengeQnA.answers[2]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:2.0),
                    child: _quizAnswerBox(questionAnswerFourthColor,widget.dailyQuizChallengeQnA.answers[3]),
                  )
                ],
              ),
            )
          ]),
    );
  }


  Widget _quizAnswerBox(Color color, String answer){
    return Container(
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
    );
  }
}
