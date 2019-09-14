import 'package:flutter/material.dart';

class CustomQuizAnswerButtonWidget extends StatefulWidget{

   int _buttonId;
   String _quizAnswer;
   EdgeInsets _edgeInsets;
  Function _onPressed;
   CustomQuizAnswerButtonWidgetState _state;

   void setQuizAnswer(String answer){
     if(_state != null) {
       _state.setQuizAnswer(answer);
     }
   }

  CustomQuizAnswerButtonWidget( this._onPressed, this._buttonId, this._quizAnswer, this._edgeInsets);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   _state = CustomQuizAnswerButtonWidgetState(this, _onPressed, _buttonId, _quizAnswer, _edgeInsets);
   return _state;
  }

  /*
  Change color
   */
  void changeColor(id){
    _state._changeColor(id);
  }

  void resetColor(){
    _state.resetColor();
  }

}

class CustomQuizAnswerButtonWidgetState extends State<CustomQuizAnswerButtonWidget>{
  String _quizAnswer = "";
  EdgeInsets _edgeInsets;
  final int _buttonId;
  Function _onPressed;
  CustomQuizAnswerButtonWidget _customQuizAnswerButtonWidget;

  List<Color> _colorList;

  void setQuizAnswer(String answer){
    setState(() {
      _quizAnswer = answer;
    });
  }
  /*
  Change color
   */
  void _changeColor(id){
    if(id == _buttonId) {
      setState(() {
        _colorList = [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[700],
          Colors.orange[600],
        ];
      });
    }
    _colorList = _colorList;
  }

  void resetColor(){
    setState(() {
      initColor();
    });
  }
  /**
   * Initial color
   */
  void initColor(){
    _colorList = _colorList = [
    Colors.deepPurple[900],
    Colors.deepPurple[800],
    Colors.deepPurple[700],
    Colors.deepPurple[600],
    ];
  }

  @override
  void initState() {
    super.initState();
    initColor();
  }

  CustomQuizAnswerButtonWidgetState(this._customQuizAnswerButtonWidget,this._onPressed, this._buttonId, this._quizAnswer, this._edgeInsets);


  @override
  Widget build(BuildContext context) {

      return GestureDetector(
        child: Padding(
          padding: _edgeInsets,
          child: Container(
            decoration: new BoxDecoration(
              gradient: LinearGradient(colors: _colorList),
                border: new Border.all(color: Colors.white, width: 1),
                borderRadius: new BorderRadius.all(Radius.circular(40.0))
            ),
            child: Padding(padding: EdgeInsets.all(16.0),
            child: Center(
                child: Text(_quizAnswer, style: TextStyle(color: Colors.white, fontSize: 18.0,
                    fontFamily: 'Raleway')),
            ),
            ),
          ),
        ),
        onTap: (){
          _onPressed(_buttonId, _customQuizAnswerButtonWidget);
        },
      );
  }

}