import 'package:flutter/material.dart';

/***
 * Custom text field  widget with a label
 */

class CustomLabelTextFieldWidget extends StatefulWidget{

  String _label ="";
  _CustomLabelTextFieldWidgetState _state;
  Color _color = Colors.white;
  bool _enabled = true;

  CustomLabelTextFieldWidget(String label, Color color, {bool enabled}){
    _label = label;
    _color = color;
    _enabled = enabled;
  }


  String getValue()
  {
    return _state.getValue();
  }

  State<StatefulWidget> createState(){
     _state = new _CustomLabelTextFieldWidgetState(_label, _color, _enabled);
     return _state;
  }
}

class _CustomLabelTextFieldWidgetState extends State <CustomLabelTextFieldWidget>
{
  String _label = "";
  bool _enabled = true;
  String _value ="";
  Color _color = Colors.white;
  final textFldcontroller = TextEditingController();

  _CustomLabelTextFieldWidgetState(String label, Color color , bool enabled){
    _label = label;
    _color = color;
    _enabled = enabled;
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
          enabled: true,
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

