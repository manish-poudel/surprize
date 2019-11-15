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
  void changeColor(id, String type){
    _state._changeColor(id , type);
  }

  void resetColor(){
    if(_state != null)
      _state.resetColor();
  }

}

class CustomQuizAnswerButtonWidgetState extends State<CustomQuizAnswerButtonWidget> with TickerProviderStateMixin{
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
  void _changeColor(id, String type){
    if(id == _buttonId) {
      setState(() {
        if(type == "SELECTED") {
          _colorList = [
            Colors.orange[900],
            Colors.orange[800],
            Colors.orange[700],
            Colors.orange[600],
          ];
        }
        if(type == "CORRECT"){
          _colorList = [
            Colors.green[900],
            Colors.green[800],
            Colors.green[700],
            Colors.green[600],
          ];
        }
        if(type == "WRONG"){
          _colorList = [
            Colors.red[900],
            Colors.red[800],
            Colors.red[700],
            Colors.red[600],
          ];
        }
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

  AnimationController _fadeInAnimation;
  @override
  void initState() {
    super.initState();
    initColor();

  }

  CustomQuizAnswerButtonWidgetState(this._customQuizAnswerButtonWidget,this._onPressed, this._buttonId, this._quizAnswer, this._edgeInsets);


  @override
  Widget build(BuildContext context) {
    _fadeInAnimation = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
      _fadeInAnimation.forward();
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
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Text(_quizAnswer, style: TextStyle(color: Colors.white, fontSize: 18.0,
                      fontFamily: 'Raleway')),
                ),
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