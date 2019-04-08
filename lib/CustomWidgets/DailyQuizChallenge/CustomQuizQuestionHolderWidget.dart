import 'package:flutter/material.dart';

class CustomQuizQuestionHolderWidget extends StatefulWidget{

  final String _quizQuestion;
  CustomQuizQuestionHolderWidget(this._quizQuestion);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomQuizQuestionHolderWidgetState(_quizQuestion);
  }

}

class CustomQuizQuestionHolderWidgetState extends State<CustomQuizQuestionHolderWidget>{
  String _quizQuestion = "";

  CustomQuizQuestionHolderWidgetState(this._quizQuestion);
  

  @override
  Widget build(BuildContext context) {
 
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left:8, right:8,top:8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
          boxShadow: [
            BoxShadow(
                color:Colors.black12,
                offset: Offset(1.0, 5.0),
                blurRadius: 25.0
            ),
          ],
          border: new Border.all(color: Colors.white54, width: 0.5),
            borderRadius:  new BorderRadius.all(Radius.circular(32.0))
        ),
        child: Center(
          child: Padding(padding: EdgeInsets.all(16.0),
          child: Text(_quizQuestion, style: TextStyle(color: Colors.purple, fontSize: 21.0, fontWeight: FontWeight.w500,
                fontFamily: 'Roboto')) ,
          ),
        ),
      ),
    );
  }

}