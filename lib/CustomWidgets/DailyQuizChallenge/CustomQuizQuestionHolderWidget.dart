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
            color: Colors.indigo,
          boxShadow: [
            BoxShadow(
                color:Colors.black,
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0
            ),
          ],
          border: new Border.all(color: Colors.green, width: 2),
            borderRadius:  new BorderRadius.all(Radius.circular(18.0))
        ),
        child: Center(
          child: Padding(padding: EdgeInsets.all(16.0),
          child: Text(_quizQuestion, style: TextStyle(color: Colors.white, fontSize: 18.0,
                fontFamily: 'Roboto')) ,
          ),
        ),
      ),
    );
  }

}