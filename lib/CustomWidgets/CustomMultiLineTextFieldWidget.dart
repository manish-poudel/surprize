import 'package:flutter/material.dart';

/***
 * Custom text field  widget with a label
 */

class CustomMultiLineTextFieldWidget extends StatefulWidget{

  String _label ="";
  CustomMultiLineTextFieldWidgetState _state;
  Color _color = Colors.white;
  String value;
  double height;

  CustomMultiLineTextFieldWidget(String label, this.value, Color color, this.height){
    _label = label;
    _color = color;
  }


  String getValue() {
    return _state.getValue();
  }

  State<StatefulWidget> createState(){
    _state = new CustomMultiLineTextFieldWidgetState(_label, _color,value);
    return _state;
  }
}

class CustomMultiLineTextFieldWidgetState extends State <CustomMultiLineTextFieldWidget>
{
  String _label = "";
  String _value ="";
  Color _color = Colors.white;
  final textFldcontroller = TextEditingController();

  CustomMultiLineTextFieldWidgetState(String label, Color color,String value){
    _label = label;
    _color = color;
    textFldcontroller.text  = _value = value;
  }

  String getValue()
  {
    return textFldcontroller.text;
  }

  @override
  Widget build(context) {
    return Container(
        decoration: BoxDecoration(color:Colors.grey[300],shape: BoxShape.rectangle, border: new Border.all(
          color: Colors.grey[200],
          width: 0.5,
        )),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              Flexible(child:
              TextField(
                style: TextStyle(fontFamily: 'Raleway',color: _color),
                controller: textFldcontroller,   decoration: InputDecoration.collapsed(
                hintText: _label,
                hintStyle: TextStyle(color:Colors.grey),
              ),
                maxLines: 7,
                keyboardType: TextInputType.multiline,
              )
              )
            ]

        ));
  }
}

