import 'package:flutter/material.dart';

/***
 * Custom text field  widget with a label
 */

class CustomLabelTextFieldWidget extends StatefulWidget{

  String _label ="";
  _CustomLabelTextFieldWidgetState _state;
  Color _color = Colors.white;

  CustomLabelTextFieldWidget(String label, Color color){
    _label = label;
    _color = color;
  }


  String getValue()
  {
    return _state.getValue();
  }

  State<StatefulWidget> createState(){
     _state = new _CustomLabelTextFieldWidgetState(_label, _color);
     return _state;
  }
}

class _CustomLabelTextFieldWidgetState extends State <CustomLabelTextFieldWidget>
{
  String _label = "";
  String _value ="";
  Color _color = Colors.white;
  final textFldcontroller = TextEditingController();

  _CustomLabelTextFieldWidgetState(String label, Color color){
    _label = label;
    _color = color;
  }

  String getValue()
  {
    return textFldcontroller.text;
  }

  @override
  Widget build(context) {
    return Container(child: Row(
      children:<Widget>[
        Flexible(child:
        TextFormField(controller: textFldcontroller,
        decoration: InputDecoration(
          filled: true,
          labelText:_label,
          fillColor: _color,
          border:InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.0)
          )

        ),)

        
        )
      ]

    ));
  }
}

