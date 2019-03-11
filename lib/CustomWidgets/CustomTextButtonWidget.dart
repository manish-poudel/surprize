import 'package:flutter/material.dart';
import 'Styles.dart';

/***
 * Custom button widget with a text
 */

class CustomTextButtonWidget extends StatefulWidget{

  String _label ="";
  Function _onPressed = ()=>{};
  Color _color = Colors.white;

  CustomTextButtonWidget(String label, Color color, Function onPressed){
    _label = label;
    _onPressed = onPressed;
    _color = color;
  }

  State<StatefulWidget> createState(){
    return _CustomTextButtonWidgetState(_label, _onPressed, _color);
  }
}

class _CustomTextButtonWidgetState extends State <CustomTextButtonWidget>
{
  String _label;
  Function _onPressed;
  Color _color;

  _CustomTextButtonWidgetState(String label, Function onPressed, Color color){
    _label = label;
    _onPressed = onPressed;
    _color = color;

  }
  @override
  Widget build(context) {
    return CustomRaisedButton(_label, _onPressed, _color);
  }
}

